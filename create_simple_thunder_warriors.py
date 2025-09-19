#!/usr/bin/env python3
"""
Simple Thunder Warriors Team Creation
===================================

Use the Desert Falcons captain (Hamad Al-Hamad) to create a new Thunder Warriors team.
This ensures we have a single-team captain without conflicts.
"""

import requests
import json
import time

def create_thunder_warriors_simple():
    """Create Thunder Warriors team with Hamad as captain"""
    
    base_url = "https://pre-montada.gostcode.com/api"
    headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json'
    }
    
    # Use Hamad Al-Hamad (Desert Falcons captain) credentials
    captain_phone = "0536925894"
    
    print("🎯 SIMPLE THUNDER WARRIORS TEAM CREATION")
    print("=" * 45)
    print(f"Using {captain_phone} (Hamad Al-Hamad) as new Thunder Warriors captain")
    
    # Step 1: Login and activate Hamad
    print(f"\\n🔐 Authenticating captain...")
    
    # Login
    login_data = {"mobile": captain_phone}
    login_response = requests.post(f"{base_url}/login", headers=headers, json=login_data)
    
    if login_response.status_code != 200:
        print(f"❌ Login failed: {login_response.status_code}")
        return False
    
    print("✅ Login successful")
    
    # Activate
    activate_data = {
        "code": "11111",
        "mobile": captain_phone,
        "uuid": f"thunder-captain-{int(time.time())}",
        "device_token": f"thunder_captain_token_{int(time.time())}",
        "device_type": "ios"
    }
    
    activate_response = requests.post(f"{base_url}/activate", headers=headers, json=activate_data)
    
    if activate_response.status_code != 200:
        print(f"❌ Activation failed: {activate_response.status_code}")
        return False
    
    response_data = activate_response.json()
    if not response_data.get('status'):
        print(f"❌ Activation error: {response_data.get('message')}")
        return False
    
    captain_token = response_data.get('data', {}).get('access_token')
    captain_user_id = response_data.get('data', {}).get('user', {}).get('id')
    
    print(f"✅ Captain activated - User ID: {captain_user_id}")
    print(f"Token: {captain_token[:30]}...")
    
    # Step 2: Create Thunder Warriors team
    print(f"\\n🏆 Creating Thunder Warriors team...")
    
    team_data = {
        "name": "Thunder Warriors New",
        "area_id": 1,
        "description": "Thunder Warriors - Single Captain Team (Hamad Al-Hamad)"
    }
    
    auth_headers = headers.copy()
    auth_headers['Authorization'] = f'Bearer {captain_token}'
    
    team_response = requests.post(f"{base_url}/team/create", headers=auth_headers, json=team_data)
    
    if team_response.status_code != 200:
        print(f"❌ Team creation failed: {team_response.status_code}")
        print(f"Response: {team_response.text}")
        return False
    
    team_response_data = team_response.json()
    if not team_response_data.get('status'):
        print(f"❌ Team creation error: {team_response_data.get('message')}")
        return False
    
    team_id = team_response_data.get('data', {}).get('team', {}).get('id')
    team_name = team_response_data.get('data', {}).get('team', {}).get('name')
    
    print(f"✅ Thunder Warriors team created!")
    print(f"   Team ID: {team_id}")
    print(f"   Team Name: {team_name}")
    print(f"   Captain: Hamad Al-Hamad ({captain_phone})")
    
    # Step 3: Verify captain's team access
    print(f"\\n🔍 Verifying captain's team access...")
    
    teams_response = requests.get(f"{base_url}/team/user-teams", headers=auth_headers)
    
    if teams_response.status_code == 200:
        teams_data = teams_response.json()
        if teams_data.get('status'):
            teams = teams_data.get('data', {}).get('teams', [])
            
            thunder_team = None
            for team in teams:
                if team.get('id') == team_id or 'Thunder Warriors' in team.get('name', ''):
                    thunder_team = team
                    break
            
            if thunder_team:
                print(f"✅ Captain has Thunder Warriors access!")
                print(f"   Team: {thunder_team.get('name')} (ID: {thunder_team.get('id')})")
            else:
                print(f"❌ Captain does not have Thunder Warriors access")
                available_teams = [f"{t.get('name')} (ID: {t.get('id')})" for t in teams]
                print(f"Available teams: {available_teams}")
                return False
        else:
            print(f"❌ Teams API error: {teams_data.get('message')}")
            return False
    else:
        print(f"❌ Teams request failed: {teams_response.status_code}")
        return False
    
    # Generate summary
    print(f"\\n🎉 SUCCESS! Thunder Warriors team created!")
    print("=" * 40)
    
    summary = []
    summary.append("THUNDER WARRIORS TEAM - SINGLE CAPTAIN")
    summary.append("=" * 40)
    summary.append(f"Team ID: {team_id}")
    summary.append(f"Team Name: {team_name}")
    summary.append(f"Created: {time.strftime('%Y-%m-%d %H:%M:%S')}")
    summary.append("")
    summary.append("CAPTAIN:")
    summary.append(f"  Name: Hamad Al-Hamad")
    summary.append(f"  Phone: {captain_phone}")
    summary.append(f"  Email: test13_hamad@remuntada-test.com")
    summary.append(f"  User ID: {captain_user_id}")
    summary.append(f"  Token: {captain_token}")
    summary.append(f"  Role: Thunder Warriors Captain (Single Team)")
    summary.append("")
    summary.append("NOTES:")
    summary.append("- This captain only leads Thunder Warriors (no multi-team conflicts)")
    summary.append("- Team is ready for additional members")
    summary.append("- Use this team_id for all Thunder Warriors operations")
    summary.append("- Captain has full access and permissions")
    
    summary_text = "\\n".join(summary)
    print(summary_text)
    
    # Save summary
    with open('thunder_warriors_single_captain_team.txt', 'w') as f:
        f.write(summary_text)
    
    print(f"\\n💾 Summary saved to: thunder_warriors_single_captain_team.txt")
    
    return True

if __name__ == "__main__":
    success = create_thunder_warriors_simple()
    if success:
        print(f"\\n🎊 Thunder Warriors team successfully created with single captain!")
    else:
        print(f"\\n💥 Failed to create Thunder Warriors team")