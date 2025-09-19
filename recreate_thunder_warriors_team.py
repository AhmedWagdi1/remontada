#!/usr/bin/env python3
"""
Recreate Thunder Warriors Team with Brand New Accounts
=====================================================

This script creates a completely fresh Thunder Warriors team with 12 new accounts
to avoid any conflicts with existing multi-team captains.

New phone number range: 0537000001 - 0537000012
"""

import requests
import json
import time
import random
import string

class ThunderWarriorsRecreator:
    def __init__(self):
        self.base_url = "https://pre-montada.gostcode.com/api"
        self.headers = {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'User-Agent': 'Remuntada-Test/1.0'
        }
        self.new_team_members = []
        self.team_id = None
        
        # Generate 12 new Thunder Warriors members
        self.generate_new_member_data()
    
    def generate_new_member_data(self):
        """Generate completely new member data for Thunder Warriors"""
        
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
            phone = f"053700000{i+1:01d}" if i < 9 else f"0537000{i+1:02d}"
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
        
        print("📋 Generated 12 new Thunder Warriors members:")
        for i, member in enumerate(self.new_team_members):
            role_emoji = "👑" if member['role'] == 'leader' else "⚡" if member['role'] == 'subLeader' else "⚔️"
            print(f"  {i+1:2d}. {role_emoji} {member['name']} - {member['phone']} ({member['role']})")
    
    def register_and_activate_user(self, member_data):
        """Register and activate a new user"""
        
        print(f"\n🔄 Processing: {member_data['name']} ({member_data['phone']})")
        
        # Step 1: Login (which creates account if not exists)
        login_data = {
            "mobile": member_data['phone']
        }
        
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
            "uuid": f"thunder-{member_data['phone'][-4:]}-{random.randint(1000, 9999)}",
            "device_token": f"thunder_token_{member_data['phone'][-4:]}_{random.randint(100000, 999999)}",
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
                if response_data.get('status') == 'success':
                    member_data['user_id'] = response_data.get('data', {}).get('user', {}).get('id')
                    member_data['token'] = response_data.get('data', {}).get('access_token')
                    print(f"  ✅ Account activated - User ID: {member_data['user_id']}, Token: {member_data['token'][:20]}...")
                    return True
                else:
                    print(f"  ❌ Activation failed: {response_data}")
                    return False
            else:
                print(f"  ❌ Activation HTTP error: {activate_response.status_code} - {activate_response.text}")
                return False
                
        except Exception as e:
            print(f"  ❌ Activation error: {str(e)}")
            return False
    
    def create_new_team(self, captain_token):
        """Create a brand new Thunder Warriors team"""
        
        print(f"\n🏆 Creating new Thunder Warriors team...")
        
        team_data = {
            "name": "Thunder Warriors",
            "area_id": 1,
            "description": "Elite Thunder Warriors - Recreated Team"
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
                if response_data.get('status') == 'success':
                    self.team_id = response_data.get('data', {}).get('team', {}).get('id')
                    print(f"  ✅ Team created successfully! Team ID: {self.team_id}")
                    return True
                else:
                    print(f"  ❌ Team creation failed: {response_data}")
                    return False
            else:
                print(f"  ❌ Team creation HTTP error: {team_response.status_code} - {team_response.text}")
                return False
                
        except Exception as e:
            print(f"  ❌ Team creation error: {str(e)}")
            return False
    
    def add_member_to_team(self, member_data, captain_token):
        """Add a member to the team and assign role"""
        
        if not self.team_id:
            print(f"  ❌ No team ID available for {member_data['name']}")
            return False
        
        # Skip captain (already team owner)
        if member_data['role'] == 'leader':
            print(f"  👑 {member_data['name']} is captain (team owner) - skipping add")
            return True
        
        print(f"  🔄 Adding {member_data['name']} to team...")
        
        # Step 1: Add member to team
        add_member_data = {
            "user_id": member_data['user_id'],
            "team_id": self.team_id
        }
        
        headers_with_auth = self.headers.copy()
        headers_with_auth['Authorization'] = f'Bearer {captain_token}'
        
        try:
            add_response = requests.post(
                f"{self.base_url}/team/add-member",
                headers=headers_with_auth,
                json=add_member_data,
                timeout=10
            )
            
            if add_response.status_code == 200:
                print(f"    ✅ Member added to team")
            else:
                response_text = add_response.text
                if "المستخدم عضو بالفعل في هذا الفريق" in response_text:
                    print(f"    ℹ️ Member already in team")
                else:
                    print(f"    ❌ Add member failed: {add_response.status_code} - {response_text}")
                    return False
                    
        except Exception as e:
            print(f"    ❌ Add member error: {str(e)}")
            return False
        
        # Step 2: Assign role (only for sub-leader, regular members get default role)
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
                    print(f"    ⚠️ Role assignment warning: {role_response.status_code} - {role_response.text}")
                    
            except Exception as e:
                print(f"    ⚠️ Role assignment error: {str(e)}")
        
        return True
    
    def verify_team_member(self, member_data):
        """Verify that a member can access the team"""
        
        print(f"  🔍 Verifying {member_data['name']}...")
        
        if not member_data['token']:
            print(f"    ❌ No token available")
            return False
        
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
                if response_data.get('status') == 'success':
                    teams = response_data.get('data', {}).get('teams', [])
                    thunder_warriors_team = None
                    
                    for team in teams:
                        if team.get('id') == self.team_id or team.get('name') == 'Thunder Warriors':
                            thunder_warriors_team = team
                            break
                    
                    if thunder_warriors_team:
                        print(f"    ✅ Has access to Thunder Warriors (Team ID: {thunder_warriors_team.get('id')})")
                        return True
                    else:
                        print(f"    ❌ No Thunder Warriors access found")
                        available_teams = [f"{t.get('name')} (ID: {t.get('id')})" for t in teams]
                        print(f"    Available teams: {available_teams}")
                        return False
                else:
                    print(f"    ❌ API error: {response_data}")
                    return False
            else:
                print(f"    ❌ HTTP error: {teams_response.status_code} - {teams_response.text}")
                return False
                
        except Exception as e:
            print(f"    ❌ Verification error: {str(e)}")
            return False
    
    def run_complete_recreation(self):
        """Execute the complete Thunder Warriors team recreation process"""
        
        print("🚀 STARTING THUNDER WARRIORS TEAM RECREATION")
        print("=" * 60)
        
        # Phase 1: Create and activate all accounts
        print(f"\n📍 PHASE 1: Creating and activating 12 new accounts")
        print("-" * 40)
        
        success_count = 0
        for member in self.new_team_members:
            if self.register_and_activate_user(member):
                success_count += 1
                time.sleep(0.5)  # Rate limiting
        
        print(f"\n✅ Account creation completed: {success_count}/12 accounts activated")
        
        if success_count < 12:
            print(f"⚠️ Warning: Only {success_count} accounts were successfully created")
            print("Continuing with available accounts...")
        
        # Phase 2: Create team with captain
        captain = next((m for m in self.new_team_members if m['role'] == 'leader'), None)
        if not captain or not captain['token']:
            print(f"\n❌ FATAL: Captain account creation failed")
            return False
        
        print(f"\n📍 PHASE 2: Creating team with captain {captain['name']}")
        print("-" * 40)
        
        if not self.create_new_team(captain['token']):
            print(f"\n❌ FATAL: Team creation failed")
            return False
        
        # Phase 3: Add all members to team
        print(f"\n📍 PHASE 3: Adding members to team (ID: {self.team_id})")
        print("-" * 40)
        
        added_members = 0
        for member in self.new_team_members:
            if member['token']:  # Only process successfully activated accounts
                if self.add_member_to_team(member, captain['token']):
                    added_members += 1
                time.sleep(0.3)
        
        print(f"\n✅ Member addition completed: {added_members}/{success_count} members added")
        
        # Phase 4: Verify all team access
        print(f"\n📍 PHASE 4: Verifying team access for all members")
        print("-" * 40)
        
        verified_members = 0
        for member in self.new_team_members:
            if member['token']:
                if self.verify_team_member(member):
                    verified_members += 1
        
        print(f"\n✅ Verification completed: {verified_members}/{success_count} members verified")
        
        # Final Summary
        print(f"\n🎉 THUNDER WARRIORS RECREATION COMPLETE!")
        print("=" * 60)
        print(f"📊 FINAL STATISTICS:")
        print(f"   • Accounts Created: {success_count}/12")
        print(f"   • Members Added: {added_members}/{success_count}")
        print(f"   • Access Verified: {verified_members}/{success_count}")
        print(f"   • Team ID: {self.team_id}")
        print(f"   • Captain: {captain['name']} ({captain['phone']})")
        
        # Generate summary data for documentation
        self.generate_summary_report()
        
        return True
    
    def generate_summary_report(self):
        """Generate a summary report of the new Thunder Warriors team"""
        
        print(f"\n📝 GENERATING SUMMARY REPORT")
        print("-" * 40)
        
        captain = next((m for m in self.new_team_members if m['role'] == 'leader'), None)
        sub_leader = next((m for m in self.new_team_members if m['role'] == 'subLeader'), None)
        regular_members = [m for m in self.new_team_members if m['role'] == 'member']
        
        report = []
        report.append("NEW THUNDER WARRIORS TEAM - RECREATION SUMMARY")
        report.append("=" * 55)
        report.append(f"Team ID: {self.team_id}")
        report.append(f"Creation Date: {time.strftime('%Y-%m-%d %H:%M:%S')}")
        report.append(f"Total Members: 12")
        report.append("")
        
        if captain:
            report.append("CAPTAIN:")
            report.append(f"  Name: {captain['name']}")
            report.append(f"  Phone: {captain['phone']}")
            report.append(f"  Email: {captain['email']}")
            report.append(f"  User ID: {captain['user_id']}")
            report.append(f"  Token: {captain['token']}")
            report.append("")
        
        if sub_leader:
            report.append("SUB-LEADER:")
            report.append(f"  Name: {sub_leader['name']}")
            report.append(f"  Phone: {sub_leader['phone']}")
            report.append(f"  Email: {sub_leader['email']}")
            report.append(f"  User ID: {sub_leader['user_id']}")
            report.append(f"  Token: {sub_leader['token']}")
            report.append("")
        
        report.append("REGULAR MEMBERS:")
        for i, member in enumerate(regular_members, 1):
            report.append(f"  {i:2d}. {member['name']} - {member['phone']} (ID: {member['user_id']}) - {member['email']}")
        
        report.append("")
        report.append("ALL PHONE NUMBERS:")
        for member in self.new_team_members:
            report.append(f"  {member['phone']} - {member['name']}")
        
        summary_text = "\n".join(report)
        print(summary_text)
        
        # Save to file
        with open('new_thunder_warriors_summary.txt', 'w', encoding='utf-8') as f:
            f.write(summary_text)
        
        print(f"\n💾 Summary saved to: new_thunder_warriors_summary.txt")

def main():
    """Main execution function"""
    
    print("🎯 THUNDER WARRIORS TEAM RECREATION TOOL")
    print("This will create 12 completely new accounts for Thunder Warriors")
    print("to avoid any conflicts with existing multi-team captains.")
    print()
    
    input("Press ENTER to proceed with team recreation...")
    
    recreator = ThunderWarriorsRecreator()
    success = recreator.run_complete_recreation()
    
    if success:
        print(f"\n🎊 SUCCESS! New Thunder Warriors team has been created!")
        print(f"Check 'new_thunder_warriors_summary.txt' for complete details.")
    else:
        print(f"\n💥 FAILED! Team recreation encountered errors.")
        print(f"Check the output above for details.")

if __name__ == "__main__":
    main()