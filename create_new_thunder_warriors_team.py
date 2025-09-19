#!/usr/bin/env python3
"""
Recreate Thunder Warriors Team with New Available Phone Numbers
==============================================================

This script creates a fresh Thunder Warriors team using available phone numbers
in the existing 0536925xxx range to avoid conflicts with multi-team captains.
"""

import requests
import json
import time
import random

class ThunderWarriorsNewTeam:
    def __init__(self):
        self.base_url = "https://pre-montada.gostcode.com/api"
        self.headers = {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'User-Agent': 'Remuntada-Test/1.0'
        }
        
        # Use available phone numbers in the existing range
        # Skip numbers already used: 874, 876-881, 883-884, 889-890, 893-897, 974-981
        self.available_numbers = [
            875,   # between 874 and 876
            882,   # between 881 and 883
            885, 886, 887, 888,  # between 884 and 889
            891, 892,  # between 890 and 893
            898, 899,  # after 897
            982, 983   # after 981
        ]
        
        self.new_team_members = []
        self.team_id = None
        self.generate_new_member_data()
    
    def generate_new_member_data(self):
        """Generate member data using available phone numbers"""
        
        names = [
            # Captain
            "Hassan Al-Rashid",
            # Sub-leader  
            "Mansour Al-Hassan",
            # Regular members
            "Ibrahim Al-Mansour", "Yousef Al-Ibrahim", "Salem Al-Yousef",
            "Rashid Al-Salem", "Muhannad Al-Rashid", "Bassam Al-Muhannad",
            "Talal Al-Bassam", "Nawaf Al-Talal", "Adel Al-Nawaf", "Khaled Al-Adel"
        ]
        
        roles = ["leader"] + ["subLeader"] + ["member"] * 10
        
        for i, (name, role) in enumerate(zip(names, roles)):
            if i < len(self.available_numbers):
                phone = f"053692{self.available_numbers[i]:04d}"
                first_name = name.split()[0].lower()
                
                member_data = {
                    'name': name,
                    'phone': phone,
                    'email': f"newteam_{first_name}@thunderwarriors-test.com",
                    'role': role,
                    'password': 'ThunderPass123!',
                    'user_id': None,
                    'token': None
                }
                
                self.new_team_members.append(member_data)
        
        print("📋 Generated new Thunder Warriors members with available numbers:")
        for i, member in enumerate(self.new_team_members):
            role_emoji = "👑" if member['role'] == 'leader' else "⚡" if member['role'] == 'subLeader' else "⚔️"
            print(f"  {i+1:2d}. {role_emoji} {member['name']} - {member['phone']} ({member['role']})")
    
    def register_and_activate_user(self, member_data):
        """Register and activate a new user"""
        
        print(f"\\n🔄 Processing: {member_data['name']} ({member_data['phone']})")
        
        # Step 1: Login
        login_data = {"mobile": member_data['phone']}
        
        try:
            login_response = requests.post(
                f"{self.base_url}/login",
                headers=self.headers,
                json=login_data,
                timeout=10
            )
            
            if login_response.status_code == 200:
                print("  ✅ Login request successful")
            else:
                print(f"  ❌ Login failed: {login_response.status_code} - {login_response.text}")
                return False
                
        except Exception as e:
            print(f"  ❌ Login error: {str(e)}")
            return False
        
        # Step 2: Activate account
        activate_data = {
            "code": "11111",
            "mobile": member_data['phone'],
            "uuid": f"thunder-new-{member_data['phone'][-4:]}-{random.randint(1000, 9999)}",
            "device_token": f"thunder_new_token_{member_data['phone'][-4:]}",
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
                    print(f"  ✅ Account activated - User ID: {member_data['user_id']}")
                    return True
                else:
                    print(f"  ❌ Activation failed: {response_data.get('message', 'Unknown error')}")
                    return False
            else:
                print(f"  ❌ Activation HTTP error: {activate_response.status_code}")
                return False
                
        except Exception as e:
            print(f"  ❌ Activation error: {str(e)}")
            return False
    
    def create_team(self, captain_token):
        """Create new Thunder Warriors team"""
        
        print(f"\\n🏆 Creating Thunder Warriors team...")
        
        team_data = {
            "name": "Thunder Warriors New",
            "area_id": 1,
            "description": "Thunder Warriors - New Team (Single Captain)"
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
                    team_data = response_data.get('data', {}).get('team', {})
                    self.team_id = team_data.get('id')
                    print(f"  ✅ Team created! ID: {self.team_id}, Name: {team_data.get('name')}")
                    return True
                else:
                    print(f"  ❌ Team creation failed: {response_data.get('message')}")
                    return False
            else:
                print(f"  ❌ Team creation HTTP error: {team_response.status_code}")
                return False
                
        except Exception as e:
            print(f"  ❌ Team creation error: {str(e)}")
            return False
    
    def add_member_to_team(self, member_data, captain_token):
        """Add member to team and assign role"""
        
        if member_data['role'] == 'leader':
            print(f"  👑 {member_data['name']} is captain (team owner) - skipping add")
            return True
        
        print(f"  🔄 Adding {member_data['name']} to team...")
        
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
                print(f"    ✅ Added to team")
            else:
                print(f"    ⚠️ Add response: {add_response.status_code} - {add_response.text}")
                
        except Exception as e:
            print(f"    ❌ Add member error: {str(e)}")
            return False
        
        # Assign role for sub-leader
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
    
    def verify_team_access(self, member_data):
        """Verify member has team access"""
        
        print(f"  🔍 Verifying {member_data['name']}...")
        
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
                    
                    # Check for Thunder Warriors team
                    for team in teams:
                        team_name = team.get('name', '')
                        if 'Thunder Warriors' in team_name or team.get('id') == self.team_id:
                            print(f"    ✅ Has Thunder Warriors access (Team: {team_name}, ID: {team.get('id')})")
                            return True
                    
                    team_names = [t.get('name') for t in teams]
                    print(f"    ❌ No Thunder Warriors access. Available: {team_names}")
                    return False
                else:
                    print(f"    ❌ API error: {response_data.get('message')}")
                    return False
            else:
                print(f"    ❌ HTTP error: {teams_response.status_code}")
                return False
                
        except Exception as e:
            print(f"    ❌ Verification error: {str(e)}")
            return False
    
    def run_recreation(self):
        """Execute complete team recreation"""
        
        print("🚀 RECREATING THUNDER WARRIORS TEAM")
        print("=" * 50)
        
        # Phase 1: Create accounts
        print(f"\\n📍 PHASE 1: Account Creation")
        print("-" * 30)
        
        success_count = 0
        for member in self.new_team_members:
            if self.register_and_activate_user(member):
                success_count += 1
                time.sleep(0.5)
        
        print(f"\\n✅ Accounts created: {success_count}/{len(self.new_team_members)}")
        
        # Get captain
        captain = next((m for m in self.new_team_members if m['role'] == 'leader' and m['token']), None)
        if not captain:
            print("❌ FATAL: No captain available")
            return False
        
        # Phase 2: Create team
        print(f"\\n📍 PHASE 2: Team Creation")
        print("-" * 30)
        
        if not self.create_team(captain['token']):
            print("❌ FATAL: Team creation failed")
            return False
        
        # Phase 3: Add members
        print(f"\\n📍 PHASE 3: Adding Members")
        print("-" * 30)
        
        added_count = 0
        for member in self.new_team_members:
            if member['token']:
                if self.add_member_to_team(member, captain['token']):
                    added_count += 1
                time.sleep(0.3)
        
        print(f"\\n✅ Members added: {added_count}/{success_count}")
        
        # Phase 4: Verify access
        print(f"\\n📍 PHASE 4: Access Verification")
        print("-" * 30)
        
        verified_count = 0
        for member in self.new_team_members:
            if member['token']:
                if self.verify_team_access(member):
                    verified_count += 1
        
        print(f"\\n✅ Access verified: {verified_count}/{success_count}")
        
        # Summary
        print(f"\\n🎉 RECREATION COMPLETE!")
        print("=" * 30)
        print(f"Team ID: {self.team_id}")
        print(f"Captain: {captain['name']} ({captain['phone']})")
        print(f"Success Rate: {verified_count}/{len(self.new_team_members)}")
        
        self.generate_summary()
        return True
    
    def generate_summary(self):
        """Generate summary for documentation"""
        
        captain = next((m for m in self.new_team_members if m['role'] == 'leader'), None)
        sub_leader = next((m for m in self.new_team_members if m['role'] == 'subLeader'), None)
        
        summary = []
        summary.append("NEW THUNDER WARRIORS TEAM SUMMARY")
        summary.append("=" * 40)
        summary.append(f"Team ID: {self.team_id}")
        summary.append(f"Team Name: Thunder Warriors New")
        summary.append(f"Created: {time.strftime('%Y-%m-%d %H:%M:%S')}")
        summary.append("")
        
        if captain and captain['token']:
            summary.append("CAPTAIN:")
            summary.append(f"  Name: {captain['name']}")
            summary.append(f"  Phone: {captain['phone']}")
            summary.append(f"  Email: {captain['email']}")
            summary.append(f"  User ID: {captain['user_id']}")
            summary.append(f"  Token: {captain['token']}")
            summary.append("")
        
        if sub_leader and sub_leader['token']:
            summary.append("SUB-LEADER:")
            summary.append(f"  Name: {sub_leader['name']}")
            summary.append(f"  Phone: {sub_leader['phone']}")
            summary.append(f"  Email: {sub_leader['email']}")
            summary.append(f"  User ID: {sub_leader['user_id']}")
            summary.append("")
        
        active_members = [m for m in self.new_team_members if m['role'] == 'member' and m['token']]
        summary.append(f"REGULAR MEMBERS ({len(active_members)}):")
        for i, member in enumerate(active_members, 1):
            summary.append(f"  {i:2d}. {member['name']} - {member['phone']} (ID: {member['user_id']})")
        
        summary.append("")
        summary.append("ALL PHONE NUMBERS:")
        for member in self.new_team_members:
            if member['token']:
                summary.append(f"  {member['phone']} - {member['name']} ✅")
            else:
                summary.append(f"  {member['phone']} - {member['name']} ❌")
        
        summary_text = "\\n".join(summary)
        print(f"\\n{summary_text}")
        
        # Save to file
        with open('new_thunder_warriors_team_summary.txt', 'w') as f:
            f.write(summary_text)
        
        print(f"\\n💾 Summary saved to: new_thunder_warriors_team_summary.txt")

def main():
    recreator = ThunderWarriorsNewTeam()
    success = recreator.run_recreation()
    
    if success:
        print(f"\\n🎊 SUCCESS! New Thunder Warriors team created!")
    else:
        print(f"\\n💥 FAILED! Check output for errors.")

if __name__ == "__main__":
    main()