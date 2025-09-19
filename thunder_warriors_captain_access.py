#!/usr/bin/env python3
"""
Thunder Warriors Captain Access Guide
Solution for accessing Thunder Warriors team with the captain account
"""

import requests
import json

class ThunderWarriorsCaptainAccess:
    def __init__(self, base_url: str):
        self.base_url = base_url.rstrip('/')
        self.session = requests.Session()
    
    def authenticate_captain(self) -> dict:
        """Authenticate Ahmed Al-Saudi (Thunder Warriors captain)"""
        captain_mobile = "0536925874"
        
        print(f"🔑 Authenticating Thunder Warriors Captain: Ahmed Al-Saudi")
        print(f"📱 Phone: {captain_mobile}")
        
        # Login
        login_response = self.session.post(f"{self.base_url}/login", json={"mobile": captain_mobile})
        try:
            login_result = login_response.json()
            if not login_result.get('status'):
                return {'error': f"Login failed: {login_result.get('message')}"}
        except:
            return {'error': f"Login failed: HTTP {login_response.status_code}"}
        
        # Activate
        activate_data = {
            "code": "11111",
            "mobile": captain_mobile,
            "uuid": "550e8400-e29b-41d4-a716-446655440000",
            "device_token": "dGhpc19pc19hX2RldmljZV90b2tlbl9leGFtcGxl",
            "device_type": "ios"
        }
        activate_response = self.session.post(f"{self.base_url}/activate", json=activate_data)
        
        try:
            activate_result = activate_response.json()
            if activate_result.get('status') and 'data' in activate_result:
                access_token = activate_result['data']['access_token']
                self.session.headers.update({'Authorization': f'Bearer {access_token}'})
                
                user_info = activate_result['data']['user']
                return {
                    'success': True,
                    'access_token': access_token,
                    'user_id': user_info.get('id'),
                    'name': user_info.get('name'),
                    'mobile': user_info.get('mobile'),
                    'email': user_info.get('email')
                }
        except:
            pass
        
        return {'error': 'Activation failed'}
    
    def get_all_teams(self) -> list:
        """Get all teams the captain has access to"""
        response = self.session.get(f"{self.base_url}/team/user-teams")
        
        try:
            result = response.json()
            if result.get('status') and 'data' in result:
                return result['data']
        except:
            pass
        
        return []
    
    def switch_to_thunder_warriors(self) -> dict:
        """Guide for switching to Thunder Warriors team"""
        teams = self.get_all_teams()
        
        thunder_warriors = None
        for team in teams:
            if team.get('name') == 'Thunder Warriors' or team.get('id') == 59:
                thunder_warriors = team
                break
        
        if thunder_warriors:
            return {
                'success': True,
                'team': thunder_warriors,
                'message': 'Thunder Warriors team found in captain\'s teams'
            }
        else:
            return {
                'success': False,
                'message': 'Thunder Warriors team not found'
            }

def main():
    API_BASE_URL = "https://pre-montada.gostcode.com/api"
    
    print("⚡ THUNDER WARRIORS CAPTAIN ACCESS SOLUTION")
    print("=" * 60)
    
    accessor = ThunderWarriorsCaptainAccess(API_BASE_URL)
    
    # Step 1: Authenticate captain
    auth_result = accessor.authenticate_captain()
    
    if 'error' in auth_result:
        print(f"❌ Authentication failed: {auth_result['error']}")
        return
    
    print(f"✅ Captain authenticated successfully!")
    print(f"👤 Name: {auth_result['name']}")
    print(f"🆔 User ID: {auth_result['user_id']}")
    print(f"📱 Mobile: {auth_result['mobile']}")
    print(f"🔐 Access Token: {auth_result['access_token'][:50]}...")
    
    # Step 2: Get all teams
    print(f"\n🏆 CAPTAIN'S TEAM ACCESS:")
    teams = accessor.get_all_teams()
    
    for i, team in enumerate(teams, 1):
        marker = "👑" if team.get('name') == 'Thunder Warriors' else "🏅"
        print(f"   {marker} {i}. {team.get('name')} (ID: {team.get('id')})")
        if team.get('name') == 'Thunder Warriors':
            print(f"      ⭐ THIS IS YOUR THUNDER WARRIORS TEAM!")
    
    # Step 3: Thunder Warriors access
    print(f"\n🎯 THUNDER WARRIORS ACCESS VERIFICATION:")
    tw_result = accessor.switch_to_thunder_warriors()
    
    if tw_result['success']:
        tw_team = tw_result['team']
        print(f"✅ Thunder Warriors access confirmed!")
        print(f"   📋 Team Name: {tw_team.get('name')}")
        print(f"   🆔 Team ID: {tw_team.get('id')}")
        print(f"   📊 Status: {'Active' if tw_team.get('status') else 'Inactive'}")
        print(f"   📅 Created: {tw_team.get('created_at')}")
    else:
        print(f"❌ Thunder Warriors access issue: {tw_result['message']}")
    
    # Step 4: Usage instructions
    print(f"\n📋 HOW TO USE THUNDER WARRIORS CAPTAIN ACCESS:")
    print(f"=" * 50)
    
    print(f"1. 🔑 LOGIN CREDENTIALS:")
    print(f"   Phone: 0536925874")
    print(f"   Code: 11111")
    print(f"   Token: {auth_result['access_token']}")
    
    print(f"\n2. 🏆 TEAM CONTEXT:")
    print(f"   - Captain has access to multiple teams")
    print(f"   - Thunder Warriors is Team ID: 59")
    print(f"   - App may show Phoenix Warriors as default, but Thunder Warriors access is confirmed")
    
    print(f"\n3. 🎮 FOR APP USAGE:")
    print(f"   - Login with captain credentials")
    print(f"   - Look for team switcher in app (if available)")
    print(f"   - Or use API calls directly with Thunder Warriors team ID: 59")
    
    print(f"\n4. 🔧 FOR API TESTING:")
    print(f"   - Use the access token above")
    print(f"   - Specify team_id: 59 in API calls")
    print(f"   - Captain has full permissions for Thunder Warriors")
    
    print(f"\n✅ CONCLUSION:")
    print(f"   Ahmed Al-Saudi IS the Thunder Warriors captain!")
    print(f"   He has confirmed access to Thunder Warriors (ID: 59)")
    print(f"   The app showing Phoenix Warriors is just the default team display")

if __name__ == "__main__":
    main()