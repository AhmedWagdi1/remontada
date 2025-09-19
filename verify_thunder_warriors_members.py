#!/usr/bin/env python3
"""
Script to verify individual member access to Thunder Warriors team
This will test each member's authentication and team association
"""

import requests
import json
from typing import Dict, List

class TeamMembershipVerifier:
    def __init__(self, base_url: str):
        self.base_url = base_url.rstrip('/')
        self.session = requests.Session()
    
    def test_member_authentication(self, phone: str, name: str) -> Dict:
        """Test if a member can authenticate and access Thunder Warriors"""
        
        # Create new session for this member
        member_session = requests.Session()
        
        print(f"🔍 Testing {name} ({phone})")
        
        # Login
        login_response = member_session.post(f"{self.base_url}/login", json={"mobile": phone})
        
        try:
            login_result = login_response.json()
            if not login_result.get('status'):
                return {
                    'phone': phone,
                    'name': name,
                    'login_success': False,
                    'login_message': login_result.get('message', 'Login failed'),
                    'teams': [],
                    'has_thunder_warriors': False
                }
        except:
            return {
                'phone': phone,
                'name': name,
                'login_success': False,
                'login_message': f'HTTP Error {login_response.status_code}',
                'teams': [],
                'has_thunder_warriors': False
            }
        
        # Activate
        activate_data = {
            "code": "11111",
            "mobile": phone,
            "uuid": "550e8400-e29b-41d4-a716-446655440000",
            "device_token": "dGhpc19pc19hX2RldmljZV90b2tlbl9leGFtcGxl",
            "device_type": "ios"
        }
        activate_response = member_session.post(f"{self.base_url}/activate", json=activate_data)
        
        try:
            activate_result = activate_response.json()
            if activate_result.get('status') and 'data' in activate_result:
                access_token = activate_result['data']['access_token']
                member_session.headers.update({'Authorization': f'Bearer {access_token}'})
            else:
                return {
                    'phone': phone,
                    'name': name,
                    'login_success': False,
                    'login_message': 'Activation failed',
                    'teams': [],
                    'has_thunder_warriors': False
                }
        except:
            return {
                'phone': phone,
                'name': name,
                'login_success': False,
                'login_message': 'Activation failed',
                'teams': [],
                'has_thunder_warriors': False
            }
        
        # Get user teams
        teams_response = member_session.get(f"{self.base_url}/team/user-teams")
        
        try:
            teams_result = teams_response.json()
            if teams_result.get('status') and 'data' in teams_result:
                teams = teams_result['data']
                has_thunder_warriors = any(team.get('id') == 59 for team in teams)
                team_names = [team.get('name', 'Unknown') for team in teams]
                
                return {
                    'phone': phone,
                    'name': name,
                    'login_success': True,
                    'login_message': 'Success',
                    'teams': team_names,
                    'team_ids': [team.get('id') for team in teams],
                    'has_thunder_warriors': has_thunder_warriors,
                    'user_id': activate_result['data']['user'].get('id') if 'user' in activate_result['data'] else None
                }
            else:
                return {
                    'phone': phone,
                    'name': name,
                    'login_success': True,
                    'login_message': 'Success but no teams found',
                    'teams': [],
                    'has_thunder_warriors': False
                }
        except:
            return {
                'phone': phone,
                'name': name,
                'login_success': True,
                'login_message': 'Success but team query failed',
                'teams': [],
                'has_thunder_warriors': False
            }

def main():
    API_BASE_URL = "https://pre-montada.gostcode.com/api"
    
    # All Thunder Warriors members (including leader)
    THUNDER_WARRIORS_MEMBERS = [
        {"phone": "0536925874", "name": "Ahmed Al-Saudi", "expected_role": "leader"},
        {"phone": "0536925876", "name": "Abdullah Al-Mohammed", "expected_role": "subLeader"},
        {"phone": "0536925877", "name": "Ali Al-Abdullah", "expected_role": "member"},
        {"phone": "0536925878", "name": "Omar Al-Ali", "expected_role": "member"},
        {"phone": "0536925879", "name": "Khalid Al-Omar", "expected_role": "member"},
        {"phone": "0536925880", "name": "Fahd Al-Khalid", "expected_role": "member"},
        {"phone": "0536925881", "name": "Saud Al-Fahd", "expected_role": "member"},
        {"phone": "0536925883", "name": "Nasser Al-Faisal", "expected_role": "member"},
        {"phone": "0536925884", "name": "Abdulrahman Al-Nasser", "expected_role": "member"},
        {"phone": "0536925889", "name": "Rayan Al-Rayan", "expected_role": "member"},
        {"phone": "0536925890", "name": "Yazeed Al-Yazeed", "expected_role": "member"},
        {"phone": "0536925893", "name": "Zaid Al-Zaid", "expected_role": "member"},
    ]
    
    print("🔍 THUNDER WARRIORS MEMBERSHIP VERIFICATION")
    print("=" * 60)
    print(f"Testing {len(THUNDER_WARRIORS_MEMBERS)} expected members")
    print()
    
    verifier = TeamMembershipVerifier(API_BASE_URL)
    
    results = []
    thunder_warriors_members = []
    members_with_access = 0
    
    for member in THUNDER_WARRIORS_MEMBERS:
        result = verifier.test_member_authentication(member['phone'], member['name'])
        results.append(result)
        
        if result['login_success']:
            if result['has_thunder_warriors']:
                print(f"  ✅ HAS ACCESS to Thunder Warriors")
                thunder_warriors_members.append(member)
                members_with_access += 1
            else:
                print(f"  ❌ NO ACCESS to Thunder Warriors")
                if result['teams']:
                    print(f"     Teams: {', '.join(result['teams'])}")
                else:
                    print(f"     No teams found")
        else:
            print(f"  ❌ AUTHENTICATION FAILED: {result['login_message']}")
        
        print()
    
    # Summary
    print("📊 VERIFICATION SUMMARY")
    print("=" * 40)
    print(f"👥 Total Expected Members: {len(THUNDER_WARRIORS_MEMBERS)}")
    print(f"✅ Members with Thunder Warriors Access: {members_with_access}")
    print(f"❌ Members without Access: {len(THUNDER_WARRIORS_MEMBERS) - members_with_access}")
    
    if members_with_access > 0:
        print(f"\n🏆 THUNDER WARRIORS CONFIRMED MEMBERS:")
        for i, member in enumerate(thunder_warriors_members, 1):
            print(f"   {i}. {member['name']} ({member['phone']}) - {member['expected_role']}")
    
    if members_with_access < len(THUNDER_WARRIORS_MEMBERS):
        print(f"\n❌ MEMBERS MISSING FROM THUNDER WARRIORS:")
        missing_members = [m for m, r in zip(THUNDER_WARRIORS_MEMBERS, results) 
                          if not r['has_thunder_warriors']]
        for i, member in enumerate(missing_members, 1):
            print(f"   {i}. {member['name']} ({member['phone']}) - Expected: {member['expected_role']}")
    
    # Show all team associations found
    print(f"\n🗂️ ALL TEAM ASSOCIATIONS FOUND:")
    all_teams = set()
    for result in results:
        if result['login_success'] and result['teams']:
            all_teams.update(result['teams'])
    
    for team in sorted(all_teams):
        members_in_team = [r['name'] for r in results if r['login_success'] and team in r['teams']]
        print(f"   📋 {team}: {len(members_in_team)} members ({', '.join(members_in_team[:3])}{'...' if len(members_in_team) > 3 else ''})")
    
    print(f"\n🎯 CONCLUSION:")
    if members_with_access == len(THUNDER_WARRIORS_MEMBERS):
        print("✅ All Thunder Warriors members have proper access!")
    elif members_with_access > 0:
        print(f"⚠️ Partial team - {members_with_access}/{len(THUNDER_WARRIORS_MEMBERS)} members have access")
    else:
        print("❌ No members have access to Thunder Warriors team!")

if __name__ == "__main__":
    main()