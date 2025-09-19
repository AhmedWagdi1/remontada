#!/usr/bin/env python3
"""
Script to create additional users and teams for Remuntada app testing
"""

import requests
import json
import uuid
import time
import random
from typing import Dict, List, Any

# API Configuration
BASE_URL = "https://pre-montada.gostcode.com/api"
HEADERS = {
    "Content-Type": "application/json",
    "Accept": "application/json"
}

# Valid location IDs (from successful signups)
VALID_LOCATIONS = [1, 2, 3, 10]

# Additional names for the remaining users
ADDITIONAL_NAMES = [
    ("Mohammed", "Al-Ahmad"), ("Faisal", "Al-Saud"), ("Majed", "Al-Majed"), 
    ("Saad", "Al-Saad"), ("Turki", "Al-Turki"), ("Bandar", "Al-Bandar"),
    ("Sultan", "Al-Sultan"), ("Waleed", "Al-Waleed")
]

# Existing users tokens (from the report file)
EXISTING_USERS = [
    {"name": "Ahmed Al-Saudi", "phone": "0536925874", "token": "2926|ZgkE0Ov2XwX5AYfOC6Dm8driYZ4ZAvHPfS5K6JUif78f46ab"},
    {"name": "Abdullah Al-Mohammed", "phone": "0536925876", "token": "2927|akCk31ztjTIokjK6JpKi5gKXgo5bCpqemOhEIlS60a7600d8"},
    {"name": "Ali Al-Abdullah", "phone": "0536925877", "token": "2928|KrWu1Zg7voXvxCmRrPuevMqVDmaVZ3p3Ew3vjDUH40115335"},
    {"name": "Omar Al-Ali", "phone": "0536925878", "token": "2929|ecLW5FbDHxmtJ8tcShwZfRUu5d75an7XF2pP1rZhcb4c259f"},
    {"name": "Khalid Al-Omar", "phone": "0536925879", "token": "2930|FYU8vsS7p6S9YOesQzzU61PlZR6nBSMJNhropZhj674ab797"},
    {"name": "Fahd Al-Khalid", "phone": "0536925880", "token": "2931|uRLXArQ3fRAbE7ubUvkgFo36dZMgp1wUwLtB9bkLd56fbf75"},
    {"name": "Saud Al-Fahd", "phone": "0536925881", "token": "2932|qdGJImA51T7TxZRnrxvSPUlhawPNrFp5x5ZjWQsIb6d97b65"},
    {"name": "Nasser Al-Faisal", "phone": "0536925883", "token": "2933|hGxxKiC4U6nNrZAhzFiHJudwMWPdTeUxqIvWw3YSd93e1a69"},
    {"name": "Abdulrahman Al-Nasser", "phone": "0536925884", "token": "2934|jegUvjfU0ENsLtzfKGXLAKNnIubh4HGbV8Ca2GBff6e968f8"},
    {"name": "Rayan Al-Rayan", "phone": "0536925889", "token": "2935|7CBvJLWPgMDt44VNoUE7dkMKF3en5lrsBaNvQZmJ66e06258"},
    {"name": "Yazeed Al-Yazeed", "phone": "0536925890", "token": "2936|9UP1nQorUSws6fT1FHB8aKOOI7WVfUjDF3NJY7oN802b31a9"},
    {"name": "Zaid Al-Zaid", "phone": "0536925893", "token": "2937|mAPo0qbwD7JFnMIEcCfHEfCBhLwhabnGzSAcvPW0d50bc354"},
    {"name": "Hamad Al-Hamad", "phone": "0536925894", "token": "2938|nMzSgcGTwgfidTqKFFdJQEEba8a5rr4Oaek5GtnE0476cc99"},
    {"name": "Nawaf Al-Nawaf", "phone": "0536925895", "token": "2939|xCBPbXtGdvoE12aqcjHpG0ebCmr7IM5Oy6y3qM6m8a3e8dc7"},
    {"name": "Tareq Al-Tareq", "phone": "0536925896", "token": "2940|7Eef9fxQ0CvCNDfz5gZQrFhssCgWMOqEvWnm4ozc368260ac"},
    {"name": "Yusuf Al-Yusuf", "phone": "0536925897", "token": "2941|QP5MtzZzmFj00rjrqdGEvAbxwJhwjgK7vGGekLQE741e46e4"},
]

def generate_phone_number(start_index: int) -> str:
    """Generate phone number starting with 05 followed by 8 digits"""
    base_number = 36925874 + start_index
    return f"05{base_number:08d}"

def generate_user_data(index: int, name_tuple: tuple) -> Dict[str, Any]:
    """Generate user data for signup"""
    first_name, last_name = name_tuple
    full_name = f"{first_name} {last_name}"
    phone = generate_phone_number(100 + index)  # Start from higher numbers to avoid conflicts
    email = f"test{100+index}_{first_name.lower()}@remuntada-test.com"
    
    return {
        "name": full_name,
        "mobile": phone,
        "email": email,
        "area_id": 1,
        "location_id": random.choice(VALID_LOCATIONS),
        "password": "TestPass123!",
        "lang": "ar"
    }

def signup_user(user_data: Dict[str, Any]) -> Dict[str, Any]:
    """Sign up a new user"""
    try:
        print(f"Signing up user: {user_data['name']} ({user_data['mobile']})")
        response = requests.post(f"{BASE_URL}/signup", json=user_data, headers=HEADERS)
        
        if response.status_code in [200, 302]:
            result = response.json()
            if result.get('status'):
                print(f"✓ Signup successful for {user_data['name']}")
                return {**user_data, 'signup_response': result}
            else:
                print(f"✗ Signup failed for {user_data['name']}: {result.get('message')}")
                return None
        else:
            print(f"✗ Signup failed for {user_data['name']}: HTTP {response.status_code}")
            return None
    except Exception as e:
        print(f"✗ Error signing up {user_data['name']}: {str(e)}")
        return None

def login_user(mobile: str) -> Dict[str, Any]:
    """Login user to get verification code"""
    try:
        print(f"Logging in user: {mobile}")
        login_data = {"mobile": mobile}
        response = requests.post(f"{BASE_URL}/login", json=login_data, headers=HEADERS)
        
        if response.status_code in [200, 302]:
            result = response.json()
            if result.get('status'):
                print(f"✓ Login successful for {mobile}")
                return result
            else:
                print(f"✗ Login failed for {mobile}: {result.get('message')}")
                return None
        else:
            print(f"✗ Login failed for {mobile}: HTTP {response.status_code}")
            return None
    except Exception as e:
        print(f"✗ Error logging in {mobile}: {str(e)}")
        return None

def activate_user(mobile: str, code: str) -> Dict[str, Any]:
    """Activate user account"""
    try:
        print(f"Activating user: {mobile}")
        activation_data = {
            "code": code,
            "mobile": mobile,
            "uuid": str(uuid.uuid4()),
            "device_token": "dGhpc19pc19hX2RldmljZV90b2tlbl9leGFtcGxl",
            "device_type": "ios"
        }
        response = requests.post(f"{BASE_URL}/activate", json=activation_data, headers=HEADERS)
        
        if response.status_code == 200:
            result = response.json()
            if result.get('status') and result.get('data', {}).get('access_token'):
                print(f"✓ Activation successful for {mobile}")
                return result
            else:
                print(f"✗ Activation failed for {mobile}: {result.get('message')}")
                return None
        else:
            print(f"✗ Activation failed for {mobile}: HTTP {response.status_code}")
            return None
    except Exception as e:
        print(f"✗ Error activating {mobile}: {str(e)}")
        return None

def create_team(team_name: str, bio: str, area_id: int, auth_token: str) -> Dict[str, Any]:
    """Create a new team"""
    try:
        print(f"Creating team: {team_name}")
        
        files = {
            'area_id': (None, str(area_id)),
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
                print(f"✓ Team created successfully: {team_name}")
                return result
            else:
                print(f"✗ Team creation failed for {team_name}: {result.get('message')}")
                return None
        else:
            print(f"✗ Team creation failed for {team_name}: HTTP {response.status_code}")
            print(f"Response: {response.text}")
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

def create_additional_users():
    """Create additional users to reach 24 total"""
    print("=== Creating Additional Users ===")
    new_users = []
    
    for i, name_tuple in enumerate(ADDITIONAL_NAMES):
        print(f"\nProcessing additional user {i+1}/8")
        
        user_data = generate_user_data(i, name_tuple)
        
        signup_result = signup_user(user_data)
        if not signup_result:
            continue
        
        time.sleep(1)
        
        login_result = login_user(user_data['mobile'])
        if not login_result:
            continue
        
        verification_code = login_result.get('data', {}).get('code', '11111')
        time.sleep(1)
        
        activation_result = activate_user(user_data['mobile'], str(verification_code))
        if not activation_result:
            continue
        
        complete_user_data = {
            **user_data,
            'verification_code': verification_code,
            'access_token': activation_result.get('data', {}).get('access_token'),
            'user_id': activation_result.get('data', {}).get('user', {}).get('id'),
        }
        new_users.append(complete_user_data)
        
        print(f"✓ Additional user {i+1}/8 completed successfully")
        time.sleep(2)
    
    print(f"\n=== Additional Users Created: {len(new_users)}/8 ===")
    return new_users

def create_teams():
    """Create teams using existing users"""
    print("\n=== Creating Teams ===")
    
    # Combine existing users with any new ones
    all_users = EXISTING_USERS.copy()
    
    if len(all_users) < 12:
        print(f"Need at least 12 users, have {len(all_users)}")
        return []
    
    teams = []
    
    # Team 1: Phoenix Warriors
    team1_leader = all_users[0]
    team1_subleader = all_users[1]
    team1_members = all_users[2:12] if len(all_users) >= 12 else all_users[2:]
    
    print(f"\nCreating Team 1: Phoenix Warriors with leader {team1_leader['name']}")
    team1_result = create_team(
        "Phoenix Warriors", 
        "Elite football team from Riyadh - Ready for championship battles", 
        1, 
        team1_leader['token']
    )
    
    if team1_result:
        team1_data = team1_result.get('data', {})
        team1_id = team1_data.get('team', {}).get('id') or team1_data.get('id')
        
        if team1_id:
            print(f"Team 1 created with ID: {team1_id}")
            
            # Add subleader
            time.sleep(2)
            if add_member_to_team(team1_subleader['phone'], team1_id, team1_leader['token']):
                time.sleep(1)
                set_member_role(team1_subleader['phone'], team1_id, 'subleader', team1_leader['token'])
            
            # Add members
            for member in team1_members:
                time.sleep(2)
                if add_member_to_team(member['phone'], team1_id, team1_leader['token']):
                    time.sleep(1)
                    set_member_role(member['phone'], team1_id, 'member', team1_leader['token'])
            
            teams.append({
                'team_id': team1_id,
                'name': 'Phoenix Warriors',
                'leader': team1_leader,
                'subleader': team1_subleader,
                'members': team1_members
            })
    
    # Team 2: Desert Eagles (if we have enough users)
    if len(all_users) >= 24:
        team2_leader = all_users[12]
        team2_subleader = all_users[13]
        team2_members = all_users[14:24]
        
        print(f"\nCreating Team 2: Desert Eagles with leader {team2_leader['name']}")
        team2_result = create_team(
            "Desert Eagles", 
            "Powerful football team from Saudi Arabia - Champions in the making", 
            1, 
            team2_leader['token']
        )
        
        if team2_result:
            team2_data = team2_result.get('data', {})
            team2_id = team2_data.get('team', {}).get('id') or team2_data.get('id')
            
            if team2_id:
                print(f"Team 2 created with ID: {team2_id}")
                
                # Add subleader
                time.sleep(2)
                if add_member_to_team(team2_subleader['phone'], team2_id, team2_leader['token']):
                    time.sleep(1)
                    set_member_role(team2_subleader['phone'], team2_id, 'subleader', team2_leader['token'])
                
                # Add members
                for member in team2_members:
                    time.sleep(2)
                    if add_member_to_team(member['phone'], team2_id, team2_leader['token']):
                        time.sleep(1)
                        set_member_role(member['phone'], team2_id, 'member', team2_leader['token'])
                
                teams.append({
                    'team_id': team2_id,
                    'name': 'Desert Eagles',
                    'leader': team2_leader,
                    'subleader': team2_subleader,
                    'members': team2_members
                })
    
    return teams

def generate_final_report(teams):
    """Generate final comprehensive report"""
    print("\n=== Generating Final Report ===")
    
    with open('final_test_data_report.txt', 'w', encoding='utf-8') as f:
        f.write("REMUNTADA FINAL TEST DATA REPORT\n")
        f.write("="*50 + "\n\n")
        f.write(f"Generated on: {time.strftime('%Y-%m-%d %H:%M:%S')}\n")
        f.write(f"Total Users Available: {len(EXISTING_USERS)}\n")
        f.write(f"Total Teams Created: {len(teams)}\n\n")
        
        # All users quick reference
        f.write("ALL USERS QUICK REFERENCE:\n")
        f.write("-"*30 + "\n")
        for i, user in enumerate(EXISTING_USERS, 1):
            f.write(f"{i:2d}. {user['phone']} - {user['name']}\n")
        
        # Teams details
        f.write(f"\n\n{'='*50}\n")
        f.write("TEAMS DETAILS:\n")
        f.write("-"*20 + "\n")
        
        for i, team in enumerate(teams, 1):
            f.write(f"\nTeam #{i}: {team['name']} (ID: {team['team_id']})\n")
            f.write(f"  LEADER: {team['leader']['name']} - {team['leader']['phone']}\n")
            f.write(f"  SUB-LEADER: {team['subleader']['name']} - {team['subleader']['phone']}\n")
            f.write(f"  MEMBERS ({len(team['members'])}):\n")
            for j, member in enumerate(team['members'], 1):
                f.write(f"    {j}. {member['name']} - {member['phone']}\n")
        
        # Quick testing guide
        f.write(f"\n\n{'='*50}\n")
        f.write("TESTING GUIDE:\n")
        f.write("-"*15 + "\n")
        f.write("To test login for any user:\n")
        f.write("1. POST /login with mobile number\n")
        f.write("2. Use verification code: 11111\n")
        f.write("3. POST /activate with code and mobile\n\n")
        
        f.write("Sample requests already work for all phone numbers listed above.\n")
        f.write("All users have password: TestPass123!\n")

def main():
    """Main execution"""
    print("REMUNTADA TEAM CREATION SCRIPT")
    print("="*35)
    
    try:
        # Create additional users if needed
        new_users = create_additional_users()
        
        # Extend existing users list
        if new_users:
            for user in new_users:
                EXISTING_USERS.append({
                    "name": user['name'],
                    "phone": user['mobile'],
                    "token": user['access_token']
                })
        
        # Create teams
        teams = create_teams()
        
        # Generate final report
        generate_final_report(teams)
        
        print(f"\n{'='*50}")
        print("TEAM CREATION COMPLETED!")
        print(f"{'='*50}")
        print(f"✓ Total users available: {len(EXISTING_USERS)}")
        print(f"✓ Teams created: {len(teams)}")
        print("✓ Final report generated: final_test_data_report.txt")
        
    except Exception as e:
        print(f"\n✗ Error: {str(e)}")
        import traceback
        traceback.print_exc()

if __name__ == "__main__":
    main()