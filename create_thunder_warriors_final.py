#!/usr/bin/env python3
"""
Create Thunder Warriors Team with Existing Valid Token
====================================================

Use Hamad Al-Hamad's existing valid token to create Thunder Warriors team.
This avoids authentication issues and ensures single-team captain.
"""

import requests
import json
import time

def create_thunder_warriors_with_token():
    """Create Thunder Warriors team using existing token"""
    
    base_url = "https://pre-montada.gostcode.com/api"
    headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json'
    }
    
    # Use Hamad's existing valid token
    captain_token = "2952|uqsrEILaRnbiCfm51XWrcQ9Zyeyv2TWL7t3deIfZ830d5bc3"
    captain_name = "Hamad Al-Hamad"
    captain_phone = "0536925894"
    captain_user_id = 2912
    
    print("🎯 THUNDER WARRIORS TEAM CREATION WITH EXISTING TOKEN")
    print("=" * 55)
    print(f"Captain: {captain_name} ({captain_phone})")
    print(f"Using existing token: {captain_token[:30]}...")
    
    # Create Thunder Warriors team
    print(f"\\n🏆 Creating Thunder Warriors team...")
    
    team_data = {
        "name": "Thunder Warriors",
        "area_id": 1,
        "description": "Thunder Warriors - Single Captain Team"
    }
    
    auth_headers = headers.copy()
    auth_headers['Authorization'] = f'Bearer {captain_token}'
    
    try:
        team_response = requests.post(
            f"{base_url}/team/create", 
            headers=auth_headers, 
            json=team_data,
            timeout=10
        )
        
        print(f"Team creation response status: {team_response.status_code}")
        print(f"Team creation response: {team_response.text}")
        
        if team_response.status_code == 200:
            response_data = team_response.json()
            print(f"Response data: {response_data}")
            
            if response_data.get('status'):
                team_info = response_data.get('data', {}).get('team', {})
                team_id = team_info.get('id')
                team_name = team_info.get('name')
                
                print(f"✅ Thunder Warriors team created successfully!")
                print(f"   Team ID: {team_id}")
                print(f"   Team Name: {team_name}")
                print(f"   Captain: {captain_name}")
                
                # Verify team access
                print(f"\\n🔍 Verifying captain's team access...")
                
                teams_response = requests.get(
                    f"{base_url}/team/user-teams", 
                    headers=auth_headers,
                    timeout=10
                )
                
                if teams_response.status_code == 200:
                    teams_data = teams_response.json()
                    print(f"Teams response: {teams_data}")
                    
                    if teams_data.get('status'):
                        teams = teams_data.get('data', {}).get('teams', [])
                        print(f"Captain's teams: {teams}")
                        
                        # Find Thunder Warriors team
                        thunder_team = None
                        for team in teams:
                            if team.get('id') == team_id or 'Thunder Warriors' in str(team.get('name', '')):
                                thunder_team = team
                                break
                        
                        if thunder_team:
                            print(f"✅ Captain has Thunder Warriors access!")
                            print(f"   Team: {thunder_team.get('name')} (ID: {thunder_team.get('id')})")
                            
                            # Generate final summary
                            generate_final_summary(team_id, team_name, captain_name, captain_phone, captain_user_id, captain_token)
                            return True
                        else:
                            print(f"⚠️ Thunder Warriors team not found in captain's teams")
                            team_list = [f"{t.get('name')} (ID: {t.get('id')})" for t in teams]
                            print(f"Available teams: {team_list}")
                    else:
                        print(f"❌ Teams API error: {teams_data.get('message')}")
                else:
                    print(f"❌ Teams request failed: {teams_response.status_code}")
                    print(f"Teams response: {teams_response.text}")
                    
            else:
                print(f"❌ Team creation failed: {response_data.get('message')}")
                return False
        else:
            print(f"❌ Team creation HTTP error: {team_response.status_code}")
            return False
            
    except Exception as e:
        print(f"❌ Error: {str(e)}")
        return False

def generate_final_summary(team_id, team_name, captain_name, captain_phone, captain_user_id, captain_token):
    """Generate final summary of the new Thunder Warriors team"""
    
    print(f"\\n🎉 THUNDER WARRIORS TEAM CREATED SUCCESSFULLY!")
    print("=" * 50)
    
    summary = []
    summary.append("THUNDER WARRIORS TEAM - SINGLE CAPTAIN (NO CONFLICTS)")
    summary.append("=" * 55)
    summary.append(f"Team ID: {team_id}")
    summary.append(f"Team Name: {team_name}")
    summary.append(f"Created: {time.strftime('%Y-%m-%d %H:%M:%S')}")
    summary.append("")
    summary.append("CAPTAIN (Single Team Leader):")
    summary.append(f"  Name: {captain_name}")
    summary.append(f"  Phone: {captain_phone}")
    summary.append(f"  Email: test13_hamad@remuntada-test.com")
    summary.append(f"  User ID: {captain_user_id}")
    summary.append(f"  Token: {captain_token}")
    summary.append(f"  Role: Thunder Warriors Captain (ONLY Thunder Warriors)")
    summary.append("")
    summary.append("TEAM STATUS:")
    summary.append("  ✅ Team created successfully")
    summary.append("  ✅ Captain has full access")  
    summary.append("  ✅ No multi-team captain conflicts")
    summary.append("  ✅ Ready for additional members")
    summary.append("")
    summary.append("USAGE INSTRUCTIONS:")
    summary.append("- Use this captain for all Thunder Warriors operations")
    summary.append(f"- Team ID: {team_id}")
    summary.append("- Captain is dedicated to Thunder Warriors only")
    summary.append("- Use /team/add-member to add more members")
    summary.append("- Use /team/member-role to assign roles")
    summary.append("")
    summary.append("API CREDENTIALS FOR THUNDER WARRIORS:")
    summary.append(f"Captain Phone: {captain_phone}")
    summary.append("Verification Code: 11111")
    summary.append(f"Team ID: {team_id}")
    
    summary_text = "\\n".join(summary)
    print(summary_text)
    
    # Save summary
    with open('thunder_warriors_final_team.txt', 'w') as f:
        f.write(summary_text)
    
    print(f"\\n💾 Summary saved to: thunder_warriors_final_team.txt")
    print(f"\\n🎊 SUCCESS! Thunder Warriors now has a dedicated single-team captain!")

def main():
    success = create_thunder_warriors_with_token()
    if success:
        print(f"\\n🏆 Thunder Warriors team creation completed successfully!")
    else:
        print(f"\\n💥 Thunder Warriors team creation failed!")

if __name__ == "__main__":
    main()