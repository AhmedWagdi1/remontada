#!/usr/bin/env python3
"""
Script to add members to TEAM #1: THUNDER WARRIORS using Remuntada API
Uses /team/add-member and /team/member-role endpoints

This script adds test members to the Thunder Warriors team (Team ID: 59)
"""

import requests
import json
import time
from typing import Dict, List, Optional

class RemuntadaAPI:
    def __init__(self, base_url: str):
        self.base_url = base_url.rstrip('/')
        self.session = requests.Session()
        self.access_token = None
    
    def login(self, mobile: str) -> Dict:
        """Login with mobile number"""
        url = f"{self.base_url}/login"
        data = {"mobile": mobile}
        
        print(f"🔑 Logging in with mobile: {mobile}")
        response = self.session.post(url, json=data)
        
        try:
            result = response.json()
            if result.get('status'):
                print(f"✅ Login successful: {result.get('message', 'Success')}")
                return result
            else:
                print(f"❌ Login failed - API returned error: {result.get('message', 'Unknown error')}")
                return {}
        except:
            print(f"❌ Login failed: {response.status_code} - {response.text}")
            return {}
    
    def activate(self, mobile: str, code: str = "11111") -> Dict:
        """Activate account with verification code"""
        url = f"{self.base_url}/activate"
        data = {
            "code": code,
            "mobile": mobile,
            "uuid": "550e8400-e29b-41d4-a716-446655440000",
            "device_token": "dGhpc19pc19hX2RldmljZV90b2tlbl9leGFtcGxl",
            "device_type": "ios"
        }
        
        print(f"🔐 Activating account for: {mobile}")
        response = self.session.post(url, json=data)
        
        try:
            result = response.json()
            if result.get('status') and 'data' in result and 'access_token' in result['data']:
                self.access_token = result['data']['access_token']
                self.session.headers.update({'Authorization': f'Bearer {self.access_token}'})
                print(f"✅ Account activated successfully")
                return result
        except:
            pass
        
        print(f"❌ Activation failed: {response.status_code} - {response.text}")
        return {}
    
    def add_member_to_team(self, phone_number: str, team_id: int) -> Dict:
        """Add member to team using /team/add-member"""
        url = f"{self.base_url}/team/add-member"
        data = {
            "phone_number": phone_number,
            "team_id": team_id
        }
        
        print(f"👥 Adding member {phone_number} to team {team_id}")
        response = self.session.post(url, json=data)
        
        try:
            result = response.json()
            if result.get('status'):
                print(f"✅ Member added successfully: {result.get('message', 'Success')}")
                return result
            else:
                print(f"❌ Failed to add member - API error: {result.get('message', 'Unknown error')}")
                return {}
        except:
            print(f"❌ Failed to add member: {response.status_code} - {response.text}")
            return {}
    
    def set_member_role(self, phone_number: str, team_id: int, role: str) -> Dict:
        """Set member role using /team/member-role"""
        url = f"{self.base_url}/team/member-role"
        data = {
            "phone_number": phone_number,
            "team_id": team_id,
            "role": role  # "member", "subLeader", or "leader"
        }
        
        print(f"🎖️ Setting role '{role}' for {phone_number} in team {team_id}")
        response = self.session.post(url, json=data)
        
        try:
            result = response.json()
            if result.get('status'):
                print(f"✅ Role set successfully: {result.get('message', 'Success')}")
                return result
            else:
                print(f"❌ Failed to set role - API error: {result.get('message', 'Unknown error')}")
                return {}
        except:
            print(f"❌ Failed to set role: {response.status_code} - {response.text}")
            return {}
    
    def get_user_teams(self) -> Dict:
        """Get user's teams"""
        url = f"{self.base_url}/team/user-teams"
        
        response = self.session.get(url)
        
        try:
            result = response.json()
            if result.get('status'):
                print(f"✅ Teams retrieved successfully")
                return result
            else:
                print(f"❌ Failed to get teams - API error: {result.get('message', 'Unknown error')}")
                return {}
        except:
            print(f"❌ Failed to get teams: {response.status_code} - {response.text}")
            return {}

def main():
    # Configuration
    API_BASE_URL = "https://pre-montada.gostcode.com/api"
    THUNDER_WARRIORS_TEAM_ID = 59  # From team59.json
    
    # Team captain (will be used to add other members)
    CAPTAIN_MOBILE = "0536925874"  # Ahmed Al-Saudi from the data
    
    # Members to add to Thunder Warriors (from test data)
    MEMBERS_TO_ADD = [
        {"phone": "0536925876", "name": "Abdullah Al-Mohammed", "role": "subLeader"},
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
    
    # Initialize API client
    api = RemuntadaAPI(API_BASE_URL)
    
    print("🏆 THUNDER WARRIORS TEAM MEMBER ADDITION")
    print("=" * 50)
    print(f"Team ID: {THUNDER_WARRIORS_TEAM_ID}")
    print(f"Captain Mobile: {CAPTAIN_MOBILE}")
    print(f"Members to Add: {len(MEMBERS_TO_ADD)}")
    print()
    
    # Step 1: Login as team captain
    login_result = api.login(CAPTAIN_MOBILE)
    if not login_result.get('status'):
        print("❌ Failed to login as captain. Exiting...")
        return
    
    # Step 2: Activate account
    activate_result = api.activate(CAPTAIN_MOBILE)
    if not activate_result.get('status'):
        print("❌ Failed to activate captain account. Exiting...")
        return
    
    print(f"🎯 Successfully authenticated as captain: {CAPTAIN_MOBILE}")
    print()
    
    # Step 3: Add members to team
    successful_additions = 0
    failed_additions = 0
    
    for member in MEMBERS_TO_ADD:
        print(f"Processing: {member['name']} ({member['phone']})")
        
        # Add member to team
        add_result = api.add_member_to_team(member['phone'], THUNDER_WARRIORS_TEAM_ID)
        
        if add_result.get('status'):
            # Set member role (if not default member)
            if member['role'] != 'member':
                role_result = api.set_member_role(member['phone'], THUNDER_WARRIORS_TEAM_ID, member['role'])
                if role_result.get('status'):
                    print(f"✅ {member['name']} added with role: {member['role']}")
                else:
                    print(f"⚠️ {member['name']} added but role setting failed")
            else:
                print(f"✅ {member['name']} added as member")
            
            successful_additions += 1
        else:
            print(f"❌ Failed to add {member['name']}")
            failed_additions += 1
        
        print()
        time.sleep(0.5)  # Small delay between requests
    
    # Step 4: Get final team status
    print("📊 FINAL RESULTS")
    print("=" * 30)
    print(f"✅ Successful additions: {successful_additions}")
    print(f"❌ Failed additions: {failed_additions}")
    print()
    
    # Get updated team info
    print("🔍 Fetching updated team information...")
    teams_result = api.get_user_teams()
    
    if teams_result.get('status') and 'data' in teams_result:
        for team in teams_result['data']:
            if team.get('id') == THUNDER_WARRIORS_TEAM_ID:
                print(f"🏆 Team: {team.get('name')}")
                print(f"👥 Members Count: {team.get('members_count', 0)}")
                print(f"📈 Status: {'Active' if team.get('status') else 'Inactive'}")
                break
    
    print("\n🎉 Thunder Warriors team member addition completed!")

if __name__ == "__main__":
    main()
