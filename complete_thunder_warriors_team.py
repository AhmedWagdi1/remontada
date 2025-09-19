#!/usr/bin/env python3
"""
Script to properly add all missing members to TEAM #1: THUNDER WARRIORS
This will add the sub-leader and 10 regular members to complete the team
"""

import requests
import json
import time
from typing import Dict, List

class ThunderWarriorsTeamBuilder:
    def __init__(self, base_url: str):
        self.base_url = base_url.rstrip('/')
        self.session = requests.Session()
        self.access_token = None
        self.team_id = 59  # Thunder Warriors team ID
    
    def authenticate_as_leader(self) -> bool:
        """Authenticate as Ahmed Al-Saudi (team leader)"""
        leader_mobile = "0536925874"
        
        # Login
        print(f"🔑 Logging in as Thunder Warriors leader: {leader_mobile}")
        login_response = self.session.post(f"{self.base_url}/login", json={"mobile": leader_mobile})
        
        try:
            login_result = login_response.json()
            if not login_result.get('status'):
                print(f"❌ Login failed: {login_result.get('message')}")
                return False
        except:
            print(f"❌ Login failed: {login_response.status_code}")
            return False
        
        # Activate
        print(f"🔐 Activating leader account...")
        activate_data = {
            "code": "11111",
            "mobile": leader_mobile,
            "uuid": "550e8400-e29b-41d4-a716-446655440000",
            "device_token": "dGhpc19pc19hX2RldmljZV90b2tlbl9leGFtcGxl",
            "device_type": "ios"
        }
        activate_response = self.session.post(f"{self.base_url}/activate", json=activate_data)
        
        try:
            activate_result = activate_response.json()
            if activate_result.get('status') and 'data' in activate_result:
                self.access_token = activate_result['data']['access_token']
                self.session.headers.update({'Authorization': f'Bearer {self.access_token}'})
                print(f"✅ Successfully authenticated as Thunder Warriors leader")
                return True
        except:
            pass
        
        print(f"❌ Authentication failed")
        return False
    
    def add_member_to_team(self, phone: str, name: str) -> Dict:
        """Add a member to Thunder Warriors team"""
        print(f"👥 Adding {name} ({phone}) to Thunder Warriors...")
        
        response = self.session.post(f"{self.base_url}/team/add-member", json={
            "phone_number": phone,
            "team_id": self.team_id
        })
        
        try:
            result = response.json()
            if result.get('status'):
                print(f"✅ Successfully added {name}")
                return {'success': True, 'message': result.get('message')}
            else:
                error_msg = result.get('message', 'Unknown error')
                print(f"❌ Failed to add {name}: {error_msg}")
                return {'success': False, 'message': error_msg}
        except:
            print(f"❌ Failed to add {name}: HTTP {response.status_code}")
            return {'success': False, 'message': f'HTTP {response.status_code}'}
    
    def set_member_role(self, phone: str, name: str, role: str) -> Dict:
        """Set member role in Thunder Warriors team"""
        print(f"🎖️ Setting {name} ({phone}) as {role}...")
        
        response = self.session.post(f"{self.base_url}/team/member-role", json={
            "phone_number": phone,
            "team_id": self.team_id,
            "role": role
        })
        
        try:
            result = response.json()
            if result.get('status'):
                print(f"✅ Successfully set {name} as {role}")
                return {'success': True, 'message': result.get('message')}
            else:
                error_msg = result.get('message', 'Unknown error')
                print(f"❌ Failed to set role for {name}: {error_msg}")
                return {'success': False, 'message': error_msg}
        except:
            print(f"❌ Failed to set role for {name}: HTTP {response.status_code}")
            return {'success': False, 'message': f'HTTP {response.status_code}'}
    
    def verify_team_status(self) -> None:
        """Check the final team status"""
        print(f"\n🔍 Verifying Thunder Warriors team status...")
        
        response = self.session.get(f"{self.base_url}/team/user-teams")
        
        try:
            result = response.json()
            if result.get('status') and 'data' in result:
                for team in result['data']:
                    if team.get('id') == self.team_id:
                        print(f"🏆 Team: {team.get('name')}")
                        print(f"📊 Status: {'Active' if team.get('status') else 'Inactive'}")
                        print(f"👥 Members: Check individual member logins to verify")
                        return
                
                print(f"❌ Thunder Warriors team not found in user's teams")
            else:
                print(f"❌ Failed to get team status")
        except:
            print(f"❌ Error checking team status")

def main():
    API_BASE_URL = "https://pre-montada.gostcode.com/api"
    
    # Members to add to Thunder Warriors (excluding the leader who already exists)
    MEMBERS_TO_ADD = [
        # Sub-leader
        {"phone": "0536925876", "name": "Abdullah Al-Mohammed", "role": "subLeader"},
        
        # Regular members
        {"phone": "0536925877", "name": "Ali Al-Abdullah", "role": "member"},
        {"phone": "0536925878", "name": "Omar Al-Ali", "role": "member"},
        {"phone": "0536925879", "name": "Khalid Al-Omar", "role": "member"},
        {"phone": "0536925880", "name": "Fahd Al-Khalid", "role": "member"},
        {"phone": "0536925881", "name": "Saud Al-Fahd", "role": "member"},
        {"phone": "0536925883", "name": "Nasser Al-Faisal", "role": "member"},
        {"phone": "0536925884", "name": "Abdulrahman Al-Nasser", "role": "member"},
        {"phone": "0536925889", "name": "Rayan Al-Rayan", "role": "member"},
        {"phone": "0536925890", "name": "Yazeed Al-Yazeed", "role": "member"},
        {"phone": "0536925893", "name": "Zaid Al-Zaid", "role": "member"},
    ]
    
    print("⚡ THUNDER WARRIORS TEAM COMPLETION")
    print("=" * 50)
    print(f"Team ID: 59")
    print(f"Current Status: Only leader present")
    print(f"Members to Add: {len(MEMBERS_TO_ADD)}")
    print()
    
    builder = ThunderWarriorsTeamBuilder(API_BASE_URL)
    
    # Step 1: Authenticate as team leader
    if not builder.authenticate_as_leader():
        print("❌ Cannot proceed without leader authentication. Exiting...")
        return
    
    print()
    
    # Step 2: Add all missing members
    successful_additions = 0
    successful_roles = 0
    
    for member in MEMBERS_TO_ADD:
        print(f"Processing: {member['name']}")
        
        # Add member to team
        add_result = builder.add_member_to_team(member['phone'], member['name'])
        
        if add_result['success']:
            successful_additions += 1
            
            # Set role if not default member
            if member['role'] != 'member':
                role_result = builder.set_member_role(member['phone'], member['name'], member['role'])
                if role_result['success']:
                    successful_roles += 1
                else:
                    print(f"⚠️ {member['name']} added but role setting failed")
            else:
                successful_roles += 1  # Default member role doesn't need setting
        
        print()
        time.sleep(0.5)  # Small delay between requests
    
    # Step 3: Show results
    print("📊 FINAL RESULTS")
    print("=" * 30)
    print(f"✅ Successfully added: {successful_additions}/{len(MEMBERS_TO_ADD)} members")
    print(f"🎖️ Roles properly set: {successful_roles}/{len(MEMBERS_TO_ADD)} members")
    
    if successful_additions == len(MEMBERS_TO_ADD):
        print(f"\n🎉 SUCCESS! Thunder Warriors team is now complete with 12 members!")
        print(f"📋 Team composition:")
        print(f"   1 Leader: Ahmed Al-Saudi")
        print(f"   1 Sub-leader: Abdullah Al-Mohammed") 
        print(f"   10 Regular members")
    else:
        print(f"\n⚠️ INCOMPLETE: {len(MEMBERS_TO_ADD) - successful_additions} members still need to be added")
    
    # Step 4: Verify team status
    builder.verify_team_status()
    
    print(f"\n🎯 Thunder Warriors team building completed!")

if __name__ == "__main__":
    main()