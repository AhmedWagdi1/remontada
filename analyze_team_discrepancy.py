#!/usr/bin/env python3
"""
Script to identify the actual team assignments in the app vs our test data
This will help resolve the discrepancy between expected and actual teams
"""

import requests
import json
from typing import Dict, List

class TeamDiscrepancyAnalyzer:
    def __init__(self, base_url: str):
        self.base_url = base_url.rstrip('/')
        self.session = requests.Session()
    
    def get_user_actual_teams(self, phone: str, name: str) -> Dict:
        """Get the actual teams this user belongs to"""
        # Create fresh session
        session = requests.Session()
        
        print(f"🔍 Analyzing {name} ({phone})")
        
        # Login
        login_response = session.post(f"{self.base_url}/login", json={"mobile": phone})
        try:
            login_result = login_response.json()
            if not login_result.get('status'):
                return {'error': f"Login failed: {login_result.get('message')}"}
        except:
            return {'error': f"Login failed: HTTP {login_response.status_code}"}
        
        # Activate
        activate_data = {
            "code": "11111",
            "mobile": phone,
            "uuid": "550e8400-e29b-41d4-a716-446655440000",
            "device_token": "dGhpc19pc19hX2RldmljZV90b2tlbl9leGFtcGxl",
            "device_type": "ios"
        }
        activate_response = session.post(f"{self.base_url}/activate", json=activate_data)
        
        try:
            activate_result = activate_response.json()
            if activate_result.get('status') and 'data' in activate_result:
                access_token = activate_result['data']['access_token']
                session.headers.update({'Authorization': f'Bearer {access_token}'})
                user_id = activate_result['data']['user'].get('id')
            else:
                return {'error': 'Activation failed'}
        except:
            return {'error': 'Activation failed'}
        
        # Get teams
        teams_response = session.get(f"{self.base_url}/team/user-teams")
        
        try:
            teams_result = teams_response.json()
            if teams_result.get('status') and 'data' in teams_result:
                teams = []
                for team in teams_result['data']:
                    teams.append({
                        'id': team.get('id'),
                        'name': team.get('name'),
                        'status': team.get('status'),
                        'created_at': team.get('created_at')
                    })
                
                return {
                    'phone': phone,
                    'name': name,
                    'user_id': user_id,
                    'teams': teams,
                    'team_count': len(teams)
                }
            else:
                return {'error': 'Failed to get teams'}
        except:
            return {'error': 'Team query failed'}

def main():
    API_BASE_URL = "https://pre-montada.gostcode.com/api"
    
    # Test key users to understand the actual team structure
    KEY_USERS = [
        # Expected Thunder Warriors leader
        {"phone": "0536925874", "name": "Ahmed Al-Saudi", "expected_team": "Thunder Warriors", "expected_id": 59},
        
        # Expected Thunder Warriors sub-leader  
        {"phone": "0536925876", "name": "Abdullah Al-Mohammed", "expected_team": "Thunder Warriors", "expected_id": 59},
        
        # Expected Desert Falcons leader
        {"phone": "0536925894", "name": "Hamad Al-Hamad", "expected_team": "Desert Falcons", "expected_id": 60},
        
        # Expected Desert Falcons sub-leader
        {"phone": "0536925895", "name": "Nawaf Al-Nawaf", "expected_team": "Desert Falcons", "expected_id": 60},
    ]
    
    print("🔍 TEAM ASSIGNMENT DISCREPANCY ANALYSIS")
    print("=" * 60)
    
    analyzer = TeamDiscrepancyAnalyzer(API_BASE_URL)
    
    actual_teams = {}  # team_id -> team_info
    user_assignments = {}  # user -> teams
    
    for user in KEY_USERS:
        result = analyzer.get_user_actual_teams(user['phone'], user['name'])
        
        if 'error' in result:
            print(f"  ❌ Error: {result['error']}")
            continue
        
        print(f"\n👤 {result['name']} (ID: {result['user_id']})")
        print(f"   📱 Phone: {result['phone']}")
        print(f"   🏆 Teams ({result['team_count']}):")
        
        user_assignments[user['name']] = result['teams']
        
        for team in result['teams']:
            print(f"     • ID: {team['id']} | Name: {team['name']} | Status: {'Active' if team['status'] else 'Inactive'}")
            
            # Store team info
            if team['id'] not in actual_teams:
                actual_teams[team['id']] = team
        
        # Check if expected team matches actual
        expected_team_found = any(team['id'] == user['expected_id'] for team in result['teams'])
        if expected_team_found:
            print(f"   ✅ Expected team '{user['expected_team']}' (ID: {user['expected_id']}) FOUND")
        else:
            print(f"   ❌ Expected team '{user['expected_team']}' (ID: {user['expected_id']}) NOT FOUND")
        
        print()
    
    # Summary of all discovered teams
    print("📊 DISCOVERED TEAM STRUCTURE")
    print("=" * 40)
    
    for team_id, team_info in sorted(actual_teams.items()):
        print(f"🏆 Team ID: {team_id}")
        print(f"   Name: {team_info['name']}")
        print(f"   Status: {'Active' if team_info['status'] else 'Inactive'}")
        print(f"   Created: {team_info['created_at']}")
        
        # Show which users are in this team
        users_in_team = [user_name for user_name, teams in user_assignments.items() 
                        if any(t['id'] == team_id for t in teams)]
        print(f"   Members tested: {', '.join(users_in_team) if users_in_team else 'None'}")
        print()
    
    print("🎯 ANALYSIS CONCLUSIONS:")
    print("=" * 30)
    
    # Check if our expected teams exist
    thunder_warriors_exists = 59 in actual_teams
    desert_falcons_exists = 60 in actual_teams
    
    if thunder_warriors_exists:
        print(f"✅ Thunder Warriors (ID: 59) exists: {actual_teams[59]['name']}")
    else:
        print(f"❌ Thunder Warriors (ID: 59) NOT FOUND")
    
    if desert_falcons_exists:
        print(f"✅ Desert Falcons (ID: 60) exists: {actual_teams[60]['name']}")  
    else:
        print(f"❌ Desert Falcons (ID: 60) NOT FOUND")
    
    # Show the discrepancy
    print(f"\n🚨 DISCREPANCY IDENTIFIED:")
    ahmed_teams = user_assignments.get('Ahmed Al-Saudi', [])
    if ahmed_teams:
        actual_team_names = [t['name'] for t in ahmed_teams]
        print(f"   Ahmed Al-Saudi is actually in: {', '.join(actual_team_names)}")
        print(f"   But test data says: Thunder Warriors")
        print(f"   📱 App screenshot confirms: Phoenix Warriors")
    
    print(f"\n📋 RECOMMENDED ACTION:")
    print(f"   1. Update test data to reflect actual team assignments")
    print(f"   2. Use the correct team IDs and names from this analysis")
    print(f"   3. Re-verify member assignments for accurate testing")

if __name__ == "__main__":
    main()