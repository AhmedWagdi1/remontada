#!/usr/bin/env python3
"""
Script to check detailed team membership for Thunder Warriors vs Desert Falcons
And add missing members to Thunder Warriors if needed
"""

import requests
import json
from typing import Dict, List

class TeamManager:
    def __init__(self, base_url: str):
        self.base_url = base_url.rstrip('/')
        self.session = requests.Session()
        self.access_token = None
    
    def authenticate(self, mobile: str) -> bool:
        """Login and activate account"""
        # Login
        login_url = f"{self.base_url}/login"
        login_data = {"mobile": mobile}
        
        response = self.session.post(login_url, json=login_data)
        try:
            result = response.json()
            if not result.get('status'):
                return False
        except:
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
                return True
        except:
            pass
        
        return False
    
    def get_team_members_via_api(self, team_id: int) -> List[Dict]:
        """Try to get team members from various API endpoints"""
        endpoints_to_try = [
            f"/team/{team_id}",
            f"/team/{team_id}/members", 
            f"/team/details/{team_id}",
            f"/teams/{team_id}",
        ]
        
        for endpoint in endpoints_to_try:
            url = f"{self.base_url}{endpoint}"
            response = self.session.get(url)
            
            try:
                result = response.json()
                if result.get('status') and 'data' in result:
                    data = result['data']
                    # Check different possible structures
                    if isinstance(data, dict):
                        if 'users' in data:
                            return data['users']
                        elif 'members' in data:
                            return data['members']
                    elif isinstance(data, list):
                        return data
            except:
                continue
        
        return []
    
    def add_member_to_team(self, phone_number: str, team_id: int) -> bool:
        """Add member to team"""
        url = f"{self.base_url}/team/add-member"
        data = {"phone_number": phone_number, "team_id": team_id}
        
        response = self.session.post(url, json=data)
        try:
            result = response.json()
            return result.get('status', False)
        except:
            return False
    
    def set_member_role(self, phone_number: str, team_id: int, role: str) -> bool:
        """Set member role"""
        url = f"{self.base_url}/team/member-role"
        data = {"phone_number": phone_number, "team_id": team_id, "role": role}
        
        response = self.session.post(url, json=data)
        try:
            result = response.json()
            return result.get('status', False)
        except:
            return False

def main():
    API_BASE_URL = "https://pre-montada.gostcode.com/api"
    THUNDER_WARRIORS_ID = 59
    DESERT_FALCONS_ID = 60
    
    # Members from our test data for Thunder Warriors
    THUNDER_WARRIORS_MEMBERS = [
        {"phone": "0536925874", "name": "Ahmed Al-Saudi", "role": "leader"},
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
    
    # Desert Falcons members for comparison
    DESERT_FALCONS_MEMBERS = [
        {"phone": "0536925894", "name": "Hamad Al-Hamad", "role": "leader"},
        {"phone": "0536925895", "name": "Nawaf Al-Nawaf", "role": "subLeader"},
        {"phone": "0536925896", "name": "Tareq Al-Tareq", "role": "member"},
        {"phone": "0536925897", "name": "Yusuf Al-Yusuf", "role": "member"},
        # ... more members
    ]
    
    manager = TeamManager(API_BASE_URL)
    
    print("🔍 DETAILED TEAM ANALYSIS")
    print("=" * 50)
    
    # Check Thunder Warriors (Team #1)
    print(f"🏆 THUNDER WARRIORS (Team #{THUNDER_WARRIORS_ID})")
    print("-" * 40)
    
    captain_mobile = "0536925874"  # Ahmed Al-Saudi
    if manager.authenticate(captain_mobile):
        thunder_members = manager.get_team_members_via_api(THUNDER_WARRIORS_ID)
        
        print(f"📊 Current Thunder Warriors Members: {len(thunder_members)}")
        if thunder_members:
            for i, member in enumerate(thunder_members, 1):
                print(f"  {i}. {member.get('name', 'N/A')} ({member.get('mobile', 'N/A')}) - {member.get('role', 'member')}")
        else:
            print("  ❌ No members found in API response")
            
            print(f"\n🚀 ADDING MISSING MEMBERS TO THUNDER WARRIORS")
            print("-" * 40)
            
            successful = 0
            for member in THUNDER_WARRIORS_MEMBERS:
                print(f"Adding: {member['name']} ({member['phone']})")
                
                # Try to add member
                if manager.add_member_to_team(member['phone'], THUNDER_WARRIORS_ID):
                    # Set role if needed
                    if member['role'] != 'member':
                        if manager.set_member_role(member['phone'], THUNDER_WARRIORS_ID, member['role']):
                            print(f"  ✅ Added with role: {member['role']}")
                        else:
                            print(f"  ⚠️ Added but role setting failed")
                    else:
                        print(f"  ✅ Added as member")
                    successful += 1
                else:
                    print(f"  ❌ Failed to add")
            
            print(f"\n📈 Added {successful}/{len(THUNDER_WARRIORS_MEMBERS)} members")
    else:
        print("❌ Authentication failed")
    
    print(f"\n🏆 DESERT FALCONS (Team #{DESERT_FALCONS_ID})")
    print("-" * 40)
    
    # Check Desert Falcons (Team #2)
    falcon_captain = "0536925894"  # Hamad Al-Hamad
    if manager.authenticate(falcon_captain):
        falcon_members = manager.get_team_members_via_api(DESERT_FALCONS_ID)
        
        print(f"📊 Current Desert Falcons Members: {len(falcon_members)}")
        if falcon_members:
            for i, member in enumerate(falcon_members, 1):
                print(f"  {i}. {member.get('name', 'N/A')} ({member.get('mobile', 'N/A')}) - {member.get('role', 'member')}")
        else:
            print("  ❌ No members found in API response")
    else:
        print("❌ Authentication failed")
    
    print(f"\n🎯 CONCLUSION")
    print("=" * 30)
    print("This script helps identify and fix the membership discrepancy")
    print("between Thunder Warriors and Desert Falcons teams.")

if __name__ == "__main__":
    main()