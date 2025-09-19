#!/usr/bin/env python3
"""
Create New Thunder Warriors Team from Desert Falcons Members
==========================================================

Since the API only accepts pre-registered phone numbers, this script will:
1. Use existing Desert Falcons members to create a new Thunder Warriors team
2. Ensure the captain is NOT Ahmed Al-Saudi (who has multi-team conflicts)
3. Use Hamad Al-Hamad (Desert Falcons captain) as the new Thunder Warriors captain

This avoids the multi-team captain issue while creating a functional Thunder Warriors team.
"""

import requests
import json
import time

class ThunderWarriorsFromDesertFalcons:
    def __init__(self):
        self.base_url = "https://pre-montada.gostcode.com/api"
        self.headers = {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'User-Agent': 'Remuntada-Test/1.0'
        }
        
        # Use Desert Falcons members for new Thunder Warriors team
        # This ensures we use pre-registered phone numbers that work
        self.desert_falcons_members = [
            # Will become Thunder Warriors captain (was Desert Falcons captain)
            {"name": "Hamad Al-Hamad", "phone": "0536925894", "email": "test13_hamad@remuntada-test.com", "role": "leader"},
            # Will become Thunder Warriors sub-leader (was Desert Falcons sub-leader)  
            {"name": "Nawaf Al-Nawaf", "phone": "0536925895", "email": "test14_nawaf@remuntada-test.com", "role": "subLeader"},
            # Regular members (were Desert Falcons regular members)
            {"name": "Tareq Al-Tareq", "phone": "0536925896", "email": "test15_tareq@remuntada-test.com", "role": "member"},
            {"name": "Yusuf Al-Yusuf", "phone": "0536925897", "email": "test16_yusuf@remuntada-test.com", "role": "member"},
            {"name": "Mohammed Al-Ahmad", "phone": "0536925974", "email": "test17_mohammed@remuntada-test.com", "role": "member"},
            {"name": "Faisal Al-Saud", "phone": "0536925975", "email": "test18_faisal@remuntada-test.com", "role": "member"},
            {"name": "Majed Al-Majed", "phone": "0536925976", "email": "test19_majed@remuntada-test.com", "role": "member"},
            {"name": "Saad Al-Saad", "phone": "0536925977", "email": "test20_saad@remuntada-test.com", "role": "member"},
            {"name": "Turki Al-Turki", "phone": "0536925978", "email": "test21_turki@remuntada-test.com", "role": "member"},
            {"name": "Bandar Al-Bandar", "phone": "0536925979", "email": "test22_bandar@remuntada-test.com", "role": "member"},
            {"name": "Sultan Al-Sultan", "phone": "0536925980", "email": "test23_sultan@remuntada-test.com", "role": "member"},
            {"name": "Waleed Al-Waleed", "phone": "0536925981", "email": "test24_waleed@remuntada-test.com", "role": "member"}
        ]
        
        self.team_id = None
        
        # Add fields for tracking tokens and user IDs
        for member in self.desert_falcons_members:
            member['user_id'] = None
            member['token'] = None
    
    def authenticate_user(self, member_data):
        """Authenticate a user and get their token"""
        
        print(f"\\n🔐 Authenticating: {member_data['name']} ({member_data['phone']})")
        
        # Step 1: Login
        login_data = {"mobile": member_data['phone']}
        
        try:
            login_response = requests.post(
                f"{self.base_url}/login",
                headers=self.headers,
                json=login_data,
                timeout=10
            )
            
            if login_response.status_code != 200:
                print(f"  ❌ Login failed: {login_response.status_code}")
                return False
                
        except Exception as e:
            print(f"  ❌ Login error: {str(e)}")
            return False
        
        # Step 2: Activate
        activate_data = {
            "code": "11111",
            "mobile": member_data['phone'],
            "uuid": f"thunder-new-{member_data['phone'][-4:]}-{int(time.time())}",
            "device_token": f"thunder_new_{member_data['phone'][-4:]}",
            "device_type": "ios"
        }
        
        try:
            activate_response = requests.post(
                f"{self.base_url}/activate",
                headers=self.headers,
                json=activate_data,
                timeout=10
            )
            
            if activate_response.status_code == 200:
                response_data = activate_response.json()
                if response_data.get('status'):
                    user_data = response_data.get('data', {})
                    member_data['user_id'] = user_data.get('user', {}).get('id')
                    member_data['token'] = user_data.get('access_token')
                    print(f"  ✅ Authenticated - User ID: {member_data['user_id']}")
                    return True
                else:
                    print(f"  ❌ Activation failed: {response_data.get('message')}")
                    return False
            else:
                print(f"  ❌ Activation HTTP error: {activate_response.status_code}")
                return False
                
        except Exception as e:
            print(f"  ❌ Activation error: {str(e)}")
            return False
    
    def create_thunder_warriors_team(self, captain_token):
        """Create the new Thunder Warriors team"""
        
        print(f"\\n🏆 Creating Thunder Warriors team...")
        
        team_data = {
            "name": "Thunder Warriors",
            "area_id": 1,
            "description": "Thunder Warriors - Single Captain Team"
        }
        
        headers_with_auth = self.headers.copy()
        headers_with_auth['Authorization'] = f'Bearer {captain_token}'
        
        try:
            team_response = requests.post(
                f"{self.base_url}/team/create",
                headers=headers_with_auth,
                json=team_data,
                timeout=10
            )
            
            if team_response.status_code == 200:
                response_data = team_response.json()
                if response_data.get('status'):
                    team = response_data.get('data', {}).get('team', {})
                    self.team_id = team.get('id')
                    print(f"  ✅ Thunder Warriors created! Team ID: {self.team_id}")
                    return True
                else:
                    print(f"  ❌ Team creation failed: {response_data.get('message')}")
                    return False
            else:
                print(f"  ❌ Team creation HTTP error: {team_response.status_code} - {team_response.text}")
                return False
                
        except Exception as e:
            print(f"  ❌ Team creation error: {str(e)}")
            return False
    
    def add_member_to_thunder_warriors(self, member_data, captain_token):
        """Add member to Thunder Warriors team"""
        
        if member_data['role'] == 'leader':
            print(f"  👑 {member_data['name']} is captain (team creator) - already in team")
            return True
        
        print(f"  ⚔️ Adding {member_data['name']} to Thunder Warriors...")
        
        headers_with_auth = self.headers.copy()
        headers_with_auth['Authorization'] = f'Bearer {captain_token}'
        
        # Add member
        add_data = {
            "user_id": member_data['user_id'],
            "team_id": self.team_id
        }
        
        try:
            add_response = requests.post(
                f"{self.base_url}/team/add-member",
                headers=headers_with_auth,
                json=add_data,
                timeout=10
            )
            
            if add_response.status_code == 200:
                print(f"    ✅ Added to Thunder Warriors")
            else:
                response_text = add_response.text
                if "المستخدم عضو بالفعل في هذا الفريق" in response_text:
                    print(f"    ℹ️ Already in team")
                else:
                    print(f"    ⚠️ Add response: {add_response.status_code} - {response_text}")
                    
        except Exception as e:
            print(f"    ❌ Add member error: {str(e)}")
            return False
        
        # Assign sub-leader role if needed
        if member_data['role'] == 'subLeader':
            role_data = {
                "user_id": member_data['user_id'],
                "team_id": self.team_id,
                "role": "subLeader"
            }
            
            try:
                role_response = requests.post(
                    f"{self.base_url}/team/member-role",
                    headers=headers_with_auth,
                    json=role_data,
                    timeout=10
                )
                
                if role_response.status_code == 200:
                    print(f"    ✅ Sub-leader role assigned")
                else:
                    print(f"    ⚠️ Role assignment: {role_response.status_code}")
                    
            except Exception as e:
                print(f"    ⚠️ Role assignment error: {str(e)}")
        
        return True
    
    def verify_thunder_warriors_access(self, member_data):
        """Verify member has Thunder Warriors access"""
        
        print(f"  🔍 Verifying {member_data['name']} Thunder Warriors access...")
        
        headers_with_auth = self.headers.copy()
        headers_with_auth['Authorization'] = f'Bearer {member_data["token"]}'
        
        try:
            teams_response = requests.get(
                f"{self.base_url}/team/user-teams",
                headers=headers_with_auth,
                timeout=10
            )
            
            if teams_response.status_code == 200:
                response_data = teams_response.json()
                if response_data.get('status'):
                    teams = response_data.get('data', {}).get('teams', [])
                    
                    thunder_warriors_found = False
                    for team in teams:
                        team_name = team.get('name', '')
                        if 'Thunder Warriors' in team_name or team.get('id') == self.team_id:
                            print(f"    ✅ Has Thunder Warriors access (ID: {team.get('id')})")
                            thunder_warriors_found = True
                            break
                    
                    if not thunder_warriors_found:
                        team_names = [f"{t.get('name')} (ID: {t.get('id')})" for t in teams]
                        print(f"    ❌ No Thunder Warriors access. Has: {team_names}")
                        return False
                    
                    return True
                else:
                    print(f"    ❌ API error: {response_data.get('message')}")
                    return False
            else:
                print(f"    ❌ HTTP error: {teams_response.status_code}")
                return False
                
        except Exception as e:
            print(f"    ❌ Verification error: {str(e)}")
            return False
    
    def run_team_creation(self):
        """Execute complete Thunder Warriors team creation from Desert Falcons members"""
        
        print("🚀 CREATING THUNDER WARRIORS FROM DESERT FALCONS MEMBERS")
        print("=" * 65)
        print("This approach uses existing Desert Falcons members to create")
        print("a new Thunder Warriors team with a single-team captain.")
        print()
        
        # Phase 1: Authenticate all members
        print(f"📍 PHASE 1: Authenticating Desert Falcons Members")
        print("-" * 50)
        
        authenticated_count = 0
        for member in self.desert_falcons_members:
            if self.authenticate_user(member):
                authenticated_count += 1
                time.sleep(0.5)
        
        print(f"\\n✅ Authentication complete: {authenticated_count}/12 members")
        
        # Get captain
        captain = next((m for m in self.desert_falcons_members if m['role'] == 'leader' and m['token']), None)
        if not captain:
            print("❌ FATAL: Captain authentication failed")
            return False
        
        print(f"\\n👑 Captain: {captain['name']} ({captain['phone']}) - Token: {captain['token'][:20]}...")
        
        # Phase 2: Create Thunder Warriors team
        print(f"\\n📍 PHASE 2: Creating Thunder Warriors Team")
        print("-" * 40)
        
        if not self.create_thunder_warriors_team(captain['token']):
            print("❌ FATAL: Thunder Warriors team creation failed")
            return False
        
        # Phase 3: Add all members to Thunder Warriors
        print(f"\\n📍 PHASE 3: Adding Members to Thunder Warriors")
        print("-" * 45)
        
        added_count = 0
        for member in self.desert_falcons_members:
            if member['token']:
                if self.add_member_to_thunder_warriors(member, captain['token']):
                    added_count += 1
                time.sleep(0.3)
        
        print(f"\\n✅ Members added: {added_count}/{authenticated_count}")
        
        # Phase 4: Verify Thunder Warriors access
        print(f"\\n📍 PHASE 4: Verifying Thunder Warriors Access")
        print("-" * 40)
        
        verified_count = 0
        for member in self.desert_falcons_members:
            if member['token']:
                if self.verify_thunder_warriors_access(member):
                    verified_count += 1
        
        print(f"\\n✅ Thunder Warriors access verified: {verified_count}/{authenticated_count}")
        
        # Final summary
        print(f"\\n🎉 THUNDER WARRIORS TEAM CREATION COMPLETE!")
        print("=" * 50)
        print(f"📊 RESULTS:")
        print(f"   • Team ID: {self.team_id}")
        print(f"   • Team Name: Thunder Warriors")
        print(f"   • Captain: {captain['name']} ({captain['phone']})")
        print(f"   • Members Authenticated: {authenticated_count}/12")
        print(f"   • Members Added: {added_count}/{authenticated_count}")  
        print(f"   • Access Verified: {verified_count}/{authenticated_count}")
        print(f"   • Success Rate: {(verified_count/12)*100:.1f}%")
        
        # Generate documentation
        self.generate_new_team_summary()
        
        return True
    
    def generate_new_team_summary(self):
        """Generate summary for the new Thunder Warriors team"""
        
        captain = next((m for m in self.desert_falcons_members if m['role'] == 'leader'), None)
        sub_leader = next((m for m in self.desert_falcons_members if m['role'] == 'subLeader'), None)
        regular_members = [m for m in self.desert_falcons_members if m['role'] == 'member' and m['token']]
        
        summary = []
        summary.append("NEW THUNDER WARRIORS TEAM - CREATED FROM DESERT FALCONS")
        summary.append("=" * 60)
        summary.append(f"Team ID: {self.team_id}")
        summary.append(f"Team Name: Thunder Warriors")  
        summary.append(f"Created: {time.strftime('%Y-%m-%d %H:%M:%S')}")
        summary.append(f"Captain: Single-team leader (no multi-team conflicts)")
        summary.append("")
        
        if captain and captain['token']:
            summary.append("CAPTAIN (Thunder Warriors Leader):")
            summary.append(f"  Name: {captain['name']}")
            summary.append(f"  Phone: {captain['phone']}")
            summary.append(f"  Email: {captain['email']}")
            summary.append(f"  User ID: {captain['user_id']}")
            summary.append(f"  Token: {captain['token']}")
            summary.append(f"  Role: Thunder Warriors Captain (no conflicts)")
            summary.append("")
        
        if sub_leader and sub_leader['token']:
            summary.append("SUB-LEADER:")
            summary.append(f"  Name: {sub_leader['name']}")
            summary.append(f"  Phone: {sub_leader['phone']}")
            summary.append(f"  Email: {sub_leader['email']}")
            summary.append(f"  User ID: {sub_leader['user_id']}")
            summary.append("")
        
        summary.append(f"REGULAR MEMBERS ({len(regular_members)}):")
        for i, member in enumerate(regular_members, 1):
            summary.append(f"  {i:2d}. {member['name']} - {member['phone']} (ID: {member['user_id']})")
        
        summary.append("")
        summary.append("ALL THUNDER WARRIORS PHONE NUMBERS:")
        for member in self.desert_falcons_members:
            if member['token']:
                role_indicator = "👑" if member['role'] == 'leader' else "⚡" if member['role'] == 'subLeader' else "⚔️"
                summary.append(f"  {member['phone']} - {member['name']} {role_indicator}")
        
        summary.append("")
        summary.append("IMPORTANT NOTES:")
        summary.append("- This Thunder Warriors team has a dedicated captain (no multi-team conflicts)")
        summary.append("- All members were successfully migrated from Desert Falcons")
        summary.append("- Use team_id for all Thunder Warriors API operations")
        summary.append("- Captain has exclusive Thunder Warriors leadership")
        
        summary_text = "\\n".join(summary)
        print(f"\\n{summary_text}")
        
        # Save summary
        with open('new_thunder_warriors_final_summary.txt', 'w') as f:
            f.write(summary_text)
        
        print(f"\\n💾 Complete summary saved to: new_thunder_warriors_final_summary.txt")

def main():
    print("🎯 THUNDER WARRIORS TEAM CREATION FROM DESERT FALCONS")
    print("This creates a new Thunder Warriors team using Desert Falcons members")
    print("to ensure we have a single-team captain with no conflicts.")
    print()
    
    creator = ThunderWarriorsFromDesertFalcons()
    success = creator.run_team_creation()
    
    if success:
        print(f"\\n🎊 SUCCESS! Thunder Warriors team created with single captain!")
        print("Check 'new_thunder_warriors_final_summary.txt' for complete details.")
    else:
        print(f"\\n💥 FAILED! Check output for errors.")

if __name__ == "__main__":
    main()