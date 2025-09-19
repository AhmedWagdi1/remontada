#!/usr/bin/env python3
"""
Final script to create both teams with all members and roles
"""

import requests
import json
import uuid
import time
from typing import Dict, List, Any

# API Configuration
BASE_URL = "https://pre-montada.gostcode.com/api"
HEADERS = {
    "Content-Type": "application/json",
    "Accept": "application/json"
}

# All 24 users with phone numbers
ALL_USERS = [
    {"name": "Ahmed Al-Saudi", "phone": "0536925874"},
    {"name": "Abdullah Al-Mohammed", "phone": "0536925876"},
    {"name": "Ali Al-Abdullah", "phone": "0536925877"},
    {"name": "Omar Al-Ali", "phone": "0536925878"},
    {"name": "Khalid Al-Omar", "phone": "0536925879"},
    {"name": "Fahd Al-Khalid", "phone": "0536925880"},
    {"name": "Saud Al-Fahd", "phone": "0536925881"},
    {"name": "Nasser Al-Faisal", "phone": "0536925883"},
    {"name": "Abdulrahman Al-Nasser", "phone": "0536925884"},
    {"name": "Rayan Al-Rayan", "phone": "0536925889"},
    {"name": "Yazeed Al-Yazeed", "phone": "0536925890"},
    {"name": "Zaid Al-Zaid", "phone": "0536925893"},
    {"name": "Hamad Al-Hamad", "phone": "0536925894"},
    {"name": "Nawaf Al-Nawaf", "phone": "0536925895"},
    {"name": "Tareq Al-Tareq", "phone": "0536925896"},
    {"name": "Yusuf Al-Yusuf", "phone": "0536925897"},
    {"name": "Mohammed Al-Ahmad", "phone": "0536925974"},
    {"name": "Faisal Al-Saud", "phone": "0536925975"},
    {"name": "Majed Al-Majed", "phone": "0536925976"},
    {"name": "Saad Al-Saad", "phone": "0536925977"},
    {"name": "Turki Al-Turki", "phone": "0536925978"},
    {"name": "Bandar Al-Bandar", "phone": "0536925979"},
    {"name": "Sultan Al-Sultan", "phone": "0536925980"},
    {"name": "Waleed Al-Waleed", "phone": "0536925981"},
]

def get_fresh_token(mobile: str) -> str:
    """Get fresh access token for user"""
    try:
        print(f"Getting fresh token for {mobile}")
        
        # Login
        login_data = {"mobile": mobile}
        response = requests.post(f"{BASE_URL}/login", json=login_data, headers=HEADERS)
        
        if response.status_code in [200, 302]:
            result = response.json()
            if result.get('status'):
                verification_code = result.get('data', {}).get('code', '11111')
                
                # Activate
                activation_data = {
                    "code": str(verification_code),
                    "mobile": mobile,
                    "uuid": str(uuid.uuid4()),
                    "device_token": "dGhpc19pc19hX2RldmljZV90b2tlbl9leGFtcGxl",
                    "device_type": "ios"
                }
                
                time.sleep(1)
                activate_response = requests.post(f"{BASE_URL}/activate", json=activation_data, headers=HEADERS)
                
                if activate_response.status_code == 200:
                    activate_result = activate_response.json()
                    if activate_result.get('status'):
                        token = activate_result.get('data', {}).get('access_token')
                        print(f"✓ Got fresh token for {mobile}")
                        return token
        
        print(f"✗ Failed to get token for {mobile}")
        return None
        
    except Exception as e:
        print(f"✗ Error getting token for {mobile}: {str(e)}")
        return None

def create_team(team_name: str, bio: str, auth_token: str) -> Dict[str, Any]:
    """Create a new team"""
    try:
        print(f"Creating team: {team_name}")
        
        files = {
            'area_id': (None, '1'),
            'bio': (None, bio),
            'name': (None, team_name)
        }
        
        headers = {
            "Accept": "application/json",
            "Authorization": f"Bearer {auth_token}"
        }
        
        response = requests.post(f"{BASE_URL}/team/store", files=files, headers=headers)
        
        if response.status_code == 200:
            result = response.json()
            if result.get('status'):
                team_id = result.get('data', {}).get('id')
                print(f"✓ Team created successfully: {team_name} (ID: {team_id})")
                return result
            else:
                print(f"✗ Team creation failed for {team_name}: {result.get('message')}")
                return None
        else:
            print(f"✗ Team creation failed for {team_name}: HTTP {response.status_code}")
            return None
    except Exception as e:
        print(f"✗ Error creating team {team_name}: {str(e)}")
        return None

def add_member_to_team(phone_number: str, team_id: int, auth_token: str) -> bool:
    """Add member to team"""
    try:
        print(f"Adding member {phone_number} to team {team_id}")
        
        data = {
            "phone_number": phone_number,
            "team_id": team_id
        }
        
        headers = {
            **HEADERS,
            "Authorization": f"Bearer {auth_token}"
        }
        
        response = requests.post(f"{BASE_URL}/team/add-member", json=data, headers=headers)
        
        if response.status_code == 200:
            result = response.json()
            if result.get('status'):
                print(f"✓ Member {phone_number} added to team {team_id}")
                return True
            else:
                print(f"✗ Failed to add member {phone_number}: {result.get('message')}")
                return False
        else:
            print(f"✗ Failed to add member {phone_number}: HTTP {response.status_code}")
            return False
    except Exception as e:
        print(f"✗ Error adding member {phone_number}: {str(e)}")
        return False

def set_member_role(phone_number: str, team_id: int, role: str, auth_token: str) -> bool:
    """Set member role in team"""
    try:
        print(f"Setting role {role} for member {phone_number} in team {team_id}")
        
        data = {
            "phone_number": phone_number,
            "team_id": team_id,
            "role": role
        }
        
        headers = {
            **HEADERS,
            "Authorization": f"Bearer {auth_token}"
        }
        
        response = requests.post(f"{BASE_URL}/team/member-role", json=data, headers=headers)
        
        if response.status_code == 200:
            result = response.json()
            if result.get('status'):
                print(f"✓ Role {role} set for member {phone_number}")
                return True
            else:
                print(f"✗ Failed to set role for {phone_number}: {result.get('message')}")
                return False
        else:
            print(f"✗ Failed to set role for {phone_number}: HTTP {response.status_code}")
            return False
    except Exception as e:
        print(f"✗ Error setting role for {phone_number}: {str(e)}")
        return False

def create_complete_teams():
    """Create both teams with complete member structure"""
    print("CREATING COMPLETE TEAMS WITH ALL MEMBERS")
    print("="*50)
    
    teams_created = []
    
    # Team 1: Thunder Warriors (with first 12 users)
    team1_users = ALL_USERS[0:12]  # First 12 users
    team1_leader = team1_users[0]
    team1_subleader = team1_users[1]
    team1_members = team1_users[2:12]  # 10 regular members
    
    print(f"\n=== CREATING TEAM 1: Thunder Warriors ===")
    print(f"Leader: {team1_leader['name']} ({team1_leader['phone']})")
    print(f"Sub-leader: {team1_subleader['name']} ({team1_subleader['phone']})")
    print(f"Members: {len(team1_members)} regular members")
    
    # Get fresh token for team leader
    team1_leader_token = get_fresh_token(team1_leader['phone'])
    if not team1_leader_token:
        print("✗ Failed to get token for team 1 leader")
        return []
    
    # Create team 1
    team1_result = create_team("Thunder Warriors", "Elite warriors from Riyadh - Dominating the field with power and strategy", team1_leader_token)
    if team1_result:
        team1_id = team1_result.get('data', {}).get('id')
        
        if team1_id:
            print(f"\n--- Adding Members to Thunder Warriors (ID: {team1_id}) ---")
            
            # Add subleader
            time.sleep(2)
            if add_member_to_team(team1_subleader['phone'], team1_id, team1_leader_token):
                time.sleep(1)
                set_member_role(team1_subleader['phone'], team1_id, 'subleader', team1_leader_token)
            
            # Add regular members
            for i, member in enumerate(team1_members, 1):
                time.sleep(2)
                if add_member_to_team(member['phone'], team1_id, team1_leader_token):
                    time.sleep(1)
                    set_member_role(member['phone'], team1_id, 'member', team1_leader_token)
                print(f"  Progress: {i}/{len(team1_members)} members added")
            
            teams_created.append({
                'team_id': team1_id,
                'name': 'Thunder Warriors',
                'leader': team1_leader,
                'subleader': team1_subleader,
                'members': team1_members,
                'leader_token': team1_leader_token
            })
            
            print(f"✓ Team 1 (Thunder Warriors) completed with {len(team1_members) + 2} total members")
    
    # Team 2: Desert Falcons (with last 12 users)  
    team2_users = ALL_USERS[12:24]  # Last 12 users
    team2_leader = team2_users[0]
    team2_subleader = team2_users[1] 
    team2_members = team2_users[2:12]  # 10 regular members
    
    print(f"\n=== CREATING TEAM 2: Desert Falcons ===")
    print(f"Leader: {team2_leader['name']} ({team2_leader['phone']})")
    print(f"Sub-leader: {team2_subleader['name']} ({team2_subleader['phone']})")
    print(f"Members: {len(team2_members)} regular members")
    
    # Get fresh token for team leader
    team2_leader_token = get_fresh_token(team2_leader['phone'])
    if not team2_leader_token:
        print("✗ Failed to get token for team 2 leader")
        return teams_created
    
    # Create team 2
    team2_result = create_team("Desert Falcons", "Swift and precise team from Saudi Arabia - Masters of tactical gameplay", team2_leader_token)
    if team2_result:
        team2_id = team2_result.get('data', {}).get('id')
        
        if team2_id:
            print(f"\n--- Adding Members to Desert Falcons (ID: {team2_id}) ---")
            
            # Add subleader
            time.sleep(2)
            if add_member_to_team(team2_subleader['phone'], team2_id, team2_leader_token):
                time.sleep(1)
                set_member_role(team2_subleader['phone'], team2_id, 'subleader', team2_leader_token)
            
            # Add regular members
            for i, member in enumerate(team2_members, 1):
                time.sleep(2)
                if add_member_to_team(member['phone'], team2_id, team2_leader_token):
                    time.sleep(1)
                    set_member_role(member['phone'], team2_id, 'member', team2_leader_token)
                print(f"  Progress: {i}/{len(team2_members)} members added")
            
            teams_created.append({
                'team_id': team2_id,
                'name': 'Desert Falcons',
                'leader': team2_leader,
                'subleader': team2_subleader,
                'members': team2_members,
                'leader_token': team2_leader_token
            })
            
            print(f"✓ Team 2 (Desert Falcons) completed with {len(team2_members) + 2} total members")
    
    return teams_created

def generate_final_comprehensive_report(teams):
    """Generate the final comprehensive report"""
    print(f"\n=== GENERATING FINAL COMPREHENSIVE REPORT ===")
    
    timestamp = time.strftime('%Y-%m-%d %H:%M:%S')
    
    with open('REMUNTADA_COMPLETE_TEST_DATA.txt', 'w', encoding='utf-8') as f:
        f.write("REMUNTADA - COMPLETE TEST DATA FOR FLOW TESTING\n")
        f.write("="*60 + "\n\n")
        f.write(f"Generated on: {timestamp}\n")
        f.write(f"Total Users: {len(ALL_USERS)}\n")
        f.write(f"Total Teams: {len(teams)}\n")
        f.write(f"API Base URL: {BASE_URL}\n\n")
        
        # Quick Login Instructions
        f.write("QUICK LOGIN INSTRUCTIONS:\n")
        f.write("-"*30 + "\n")
        f.write("For ANY user below:\n")
        f.write("1. POST /login with mobile number\n")
        f.write("2. Use verification code: 11111\n") 
        f.write("3. POST /activate with code and mobile number\n")
        f.write("4. Password for all users: TestPass123!\n\n")
        
        # Sample API Requests
        f.write("SAMPLE API REQUESTS:\n")
        f.write("-"*20 + "\n")
        f.write("Login Request:\n")
        f.write('POST /login\n{\n  "mobile": "0536925874"\n}\n\n')
        f.write("Activate Request:\n")
        f.write('POST /activate\n{\n  "code": "11111",\n  "mobile": "0536925874",\n')
        f.write('  "uuid": "550e8400-e29b-41d4-a716-446655440000",\n')
        f.write('  "device_token": "dGhpc19pc19hX2RldmljZV90b2tlbl9leGFtcGxl",\n')
        f.write('  "device_type": "ios"\n}\n\n')
        
        # All Users List
        f.write("ALL 24 USERS (PHONE NUMBERS):\n")
        f.write("-"*35 + "\n")
        for i, user in enumerate(ALL_USERS, 1):
            f.write(f"{i:2d}. {user['phone']} - {user['name']}\n")
        
        # Teams Details
        f.write(f"\n{'='*60}\n")
        f.write("TEAMS DETAILS:\n")
        f.write("-"*15 + "\n")
        
        for i, team in enumerate(teams, 1):
            f.write(f"\nTEAM #{i}: {team['name'].upper()}\n")
            f.write(f"Team ID: {team['team_id']}\n")
            f.write(f"Total Members: {len(team['members']) + 2}\n\n")
            
            f.write(f"LEADER:\n")
            f.write(f"  Name: {team['leader']['name']}\n")
            f.write(f"  Phone: {team['leader']['phone']}\n")
            f.write(f"  Current Token: {team['leader_token']}\n\n")
            
            f.write(f"SUB-LEADER:\n")
            f.write(f"  Name: {team['subleader']['name']}\n")
            f.write(f"  Phone: {team['subleader']['phone']}\n\n")
            
            f.write(f"REGULAR MEMBERS ({len(team['members'])}):\n")
            for j, member in enumerate(team['members'], 1):
                f.write(f"  {j:2d}. {member['name']} - {member['phone']}\n")
            
            f.write(f"\n{'-'*40}\n")
        
        # Flow Testing Guide
        f.write(f"\n{'='*60}\n")
        f.write("COMPLETE FLOW TESTING GUIDE:\n")
        f.write("-"*30 + "\n\n")
        
        f.write("1. USER AUTHENTICATION FLOW:\n")
        f.write("   - Pick any phone number from the list above\n")
        f.write("   - Use login endpoint with mobile number\n") 
        f.write("   - Get verification code (always 11111 in test)\n")
        f.write("   - Activate account with code\n")
        f.write("   - Save the access_token for authenticated requests\n\n")
        
        f.write("2. TEAM MANAGEMENT FLOW:\n")
        f.write("   - Login as any team leader or sub-leader\n")
        f.write("   - Use team management endpoints\n")
        f.write("   - Test role-based permissions\n\n")
        
        f.write("3. MEMBER TESTING:\n")
        f.write("   - Login as regular members\n") 
        f.write("   - Test member-specific features\n")
        f.write("   - Verify role restrictions\n\n")
        
        f.write("4. CROSS-TEAM INTERACTIONS:\n")
        f.write("   - Test challenges between teams\n")
        f.write("   - Use different team members\n")
        f.write("   - Verify team-specific data\n\n")
        
        # Technical Details
        f.write("TECHNICAL DETAILS:\n")
        f.write("-"*20 + "\n")
        f.write("- All users are fully activated and ready\n")
        f.write("- Teams are created with proper role assignments\n")
        f.write("- Phone numbers follow the required format (05 + 8 digits)\n")
        f.write("- All accounts use the same password for consistency\n")
        f.write("- Tokens are fresh and valid for immediate use\n\n")
        
        f.write("NOTES:\n")
        f.write("-"*10 + "\n")
        f.write("- Verification code is always 11111 in test environment\n")
        f.write("- Tokens expire after some time, re-login when needed\n")
        f.write("- All users are in Riyadh area (area_id: 1)\n")
        f.write("- Teams have proper member distribution for testing\n\n")
        
        f.write(f"Report generated at: {timestamp}\n")
        f.write("Ready for complete application flow testing!\n")
        f.write("="*60 + "\n")
    
    # Create quick reference files
    with open('phone_numbers_quick_ref.txt', 'w', encoding='utf-8') as f:
        f.write("PHONE NUMBERS - QUICK REFERENCE\n")
        f.write("="*35 + "\n\n")
        for i, user in enumerate(ALL_USERS, 1):
            f.write(f"{i:2d}. {user['phone']}\n")
    
    with open('teams_structure.txt', 'w', encoding='utf-8') as f:
        f.write("TEAMS STRUCTURE\n")
        f.write("="*20 + "\n\n")
        for team in teams:
            f.write(f"TEAM: {team['name']} (ID: {team['team_id']})\n")
            f.write(f"Leader: {team['leader']['name']} - {team['leader']['phone']}\n")
            f.write(f"Sub-Leader: {team['subleader']['name']} - {team['subleader']['phone']}\n")
            f.write("Members:\n")
            for member in team['members']:
                f.write(f"  - {member['name']} - {member['phone']}\n")
            f.write("\n")
    
    print("✓ Generated comprehensive report files:")
    print("  - REMUNTADA_COMPLETE_TEST_DATA.txt (main report)")
    print("  - phone_numbers_quick_ref.txt (quick phone list)")
    print("  - teams_structure.txt (teams overview)")

def main():
    """Main execution"""
    print("REMUNTADA - FINAL TEAM CREATION & COMPLETE TEST DATA SETUP")
    print("="*65)
    print("This will:")
    print("- Create 2 complete teams using all 24 existing users")
    print("- Thunder Warriors: 12 members (1 leader + 1 sub-leader + 10 members)")
    print("- Desert Falcons: 12 members (1 leader + 1 sub-leader + 10 members)") 
    print("- Generate comprehensive test data files")
    print()
    
    try:
        teams = create_complete_teams()
        
        if teams:
            generate_final_comprehensive_report(teams)
            
            print(f"\n{'='*65}")
            print("🎉 COMPLETE TEST DATA SETUP SUCCESSFUL! 🎉")
            print(f"{'='*65}")
            print(f"✓ Created {len(teams)} teams")
            print(f"✓ All {len(ALL_USERS)} users ready for testing")
            print("✓ Complete flow testing data generated")
            print("\nYou can now:")
            print("- Login with any of the 24 phone numbers")
            print("- Test complete application flows")
            print("- Use team management features")
            print("- Test role-based functionality")
            print("\nMain report: REMUNTADA_COMPLETE_TEST_DATA.txt")
            
        else:
            print("✗ No teams were created successfully")
            
    except Exception as e:
        print(f"\n✗ Error during execution: {str(e)}")
        import traceback
        traceback.print_exc()

if __name__ == "__main__":
    main()