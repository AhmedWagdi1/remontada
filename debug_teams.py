#!/usr/bin/env python3
"""
Script to verify team memberships and debug team data
Checks both teams (Thunder Warriors and Desert Falcons) to understand the issue
"""

import requests
import json
from typing import Dict, List

class RemuntadaDebug:
    def __init__(self, base_url: str):
        self.base_url = base_url.rstrip('/')
        self.session = requests.Session()
        self.access_token = None
    
    def authenticate(self, mobile: str) -> bool:
        """Login and activate account"""
        # Login
        login_url = f"{self.base_url}/login"
        login_data = {"mobile": mobile}
        
        print(f"🔑 Authenticating with mobile: {mobile}")
        response = self.session.post(login_url, json=login_data)
        
        try:
            result = response.json()
            if not result.get('status'):
                print(f"❌ Login failed: {result.get('message')}")
                return False
        except:
            print(f"❌ Login failed: {response.status_code}")
            return False
        
        # Activate
        activate_url = f"{self.base_url}/activate"
        activate_data = {
            "code": "11111",
            "mobile": mobile,
            "uuid": "550e8400-e29b-41d4-a716-446655440000",
            "device_token": "dGhpc19pc19hX2RldmljZV90b2tlbl9leGFtcGxl",
            "device_type": "ios"
        }
        
        response = self.session.post(activate_url, json=activate_data)
        
        try:
            result = response.json()
            if result.get('status') and 'data' in result and 'access_token' in result['data']:
                self.access_token = result['data']['access_token']
                self.session.headers.update({'Authorization': f'Bearer {self.access_token}'})
                print(f"✅ Authenticated successfully")
                return True
        except:
            pass
        
        print(f"❌ Authentication failed")
        return False
    
    def get_user_teams(self) -> Dict:
        """Get user's teams with full details"""
        url = f"{self.base_url}/team/user-teams"
        response = self.session.get(url)
        
        try:
            result = response.json()
            return result if result.get('status') else {}
        except:
            return {}
    
    def get_team_details(self, team_id: int) -> Dict:
        """Get specific team details"""
        url = f"{self.base_url}/team/{team_id}"
        response = self.session.get(url)
        
        try:
            result = response.json()
            return result if result.get('status') else {}
        except:
            return {}
    
    def list_all_teams(self) -> Dict:
        """List all available teams"""
        url = f"{self.base_url}/teams"
        response = self.session.get(url)
        
        try:
            result = response.json()
            return result if result.get('status') else {}
        except:
            return {}

def main():
    API_BASE_URL = "https://pre-montada.gostcode.com/api"
    
    # Test users from different teams
    test_users = [
        {"mobile": "0536925874", "name": "Ahmed Al-Saudi", "expected_team": "Thunder Warriors"},
        {"mobile": "0536925894", "name": "Hamad Al-Hamad", "expected_team": "Desert Falcons"},
    ]
    
    debug = RemuntadaDebug(API_BASE_URL)
    
    print("🔍 TEAM MEMBERSHIP DEBUG REPORT")
    print("=" * 50)
    
    for user in test_users:
        print(f"\n👤 Testing User: {user['name']} ({user['mobile']})")
        print(f"Expected Team: {user['expected_team']}")
        print("-" * 40)
        
        if debug.authenticate(user['mobile']):
            # Get user's teams
            teams_result = debug.get_user_teams()
            
            if teams_result and 'data' in teams_result:
                print(f"📊 User's Teams ({len(teams_result['data'])}):")
                
                for team in teams_result['data']:
                    print(f"  🏆 Team ID: {team.get('id')}")
                    print(f"     Name: {team.get('name')}")
                    print(f"     Status: {'Active' if team.get('status') else 'Inactive'}")
                    print(f"     Members Count: {team.get('members_count', 'N/A')}")
                    
                    if 'users' in team:
                        print(f"     Users in data: {len(team['users'])}")
                        for i, member in enumerate(team['users'][:3]):  # Show first 3 members
                            print(f"       {i+1}. {member.get('name')} ({member.get('mobile')}) - {member.get('role', 'member')}")
                        if len(team['users']) > 3:
                            print(f"       ... and {len(team['users']) - 3} more members")
                    print()
            else:
                print("❌ No teams found for this user")
        else:
            print("❌ Authentication failed for this user")
    
    # Try to get all teams list
    print("\n🌐 CHECKING ALL AVAILABLE TEAMS")
    print("=" * 40)
    
    if debug.authenticate("0536925874"):  # Use first user
        all_teams = debug.list_all_teams()
        
        if all_teams and 'data' in all_teams:
            print(f"📋 Total Teams Available: {len(all_teams['data'])}")
            
            for team in all_teams['data']:
                print(f"  🏆 ID: {team.get('id')} | Name: {team.get('name')} | Status: {'Active' if team.get('status') else 'Inactive'}")
        else:
            print("❌ Could not retrieve all teams list")
    
    print("\n" + "=" * 50)
    print("🎯 DEBUG SUMMARY:")
    print("1. Check if users are assigned to correct teams")
    print("2. Verify team member counts vs actual user lists")
    print("3. Identify any team ID mismatches")
    print("4. Compare with local team59.json data")

if __name__ == "__main__":
    main()