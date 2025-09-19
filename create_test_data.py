#!/usr/bin/env python3
"""
Script to create test data for Remuntada app:
- 24 users with phone numbers starting with '05' + 8 digits
- Login and activate all accounts
- Create 2 teams with specific roles:
  - Team 1: 1 leader + 1 sub-leader + 10 members
  - Team 2: 1 leader + 1 sub-leader + 10 members
- Generate detailed text files with all account info
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

# Sample data for users
FIRST_NAMES = [
    "Ahmed", "Mohammed", "Abdullah", "Ali", "Omar", "Khalid", "Fahd", "Saud", "Faisal", "Nasser",
    "Abdulrahman", "Majed", "Saad", "Turki", "Bandar", "Rayan", "Yazeed", "Sultan", "Waleed", "Zaid",
    "Hamad", "Nawaf", "Tareq", "Yusuf"
]

LAST_NAMES = [
    "Al-Saudi", "Al-Ahmad", "Al-Mohammed", "Al-Abdullah", "Al-Ali", "Al-Omar", "Al-Khalid", "Al-Fahd",
    "Al-Saud", "Al-Faisal", "Al-Nasser", "Al-Majed", "Al-Saad", "Al-Turki", "Al-Bandar", "Al-Rayan",
    "Al-Yazeed", "Al-Sultan", "Al-Waleed", "Al-Zaid", "Al-Hamad", "Al-Nawaf", "Al-Tareq", "Al-Yusuf"
]

LOCATIONS = [1, 2, 3, 4, 5, 10]  # Different position IDs
AREAS = [1]  # Riyadh area

class RemuntadaTestDataGenerator:
    def __init__(self):
        self.users_data = []
        self.teams_data = []
        
    def generate_phone_number(self, index: int) -> str:
        """Generate phone number starting with 05 followed by 8 digits"""
        # Start with 05 + 8 more digits, ensuring uniqueness
        base_number = 36925874  # Base from your example
        unique_number = base_number + index
        return f"05{unique_number:08d}"
    
    def generate_user_data(self, index: int) -> Dict[str, Any]:
        """Generate user data for signup"""
        first_name = FIRST_NAMES[index % len(FIRST_NAMES)]
        last_name = LAST_NAMES[index % len(LAST_NAMES)]
        full_name = f"{first_name} {last_name}"
        phone = self.generate_phone_number(index)
        email = f"test{index+1}_{first_name.lower()}@remuntada-test.com"
        
        return {
            "name": full_name,
            "mobile": phone,
            "email": email,
            "area_id": random.choice(AREAS),
            "location_id": random.choice(LOCATIONS),
            "password": "TestPass123!",
            "lang": "ar"
        }
    
    def signup_user(self, user_data: Dict[str, Any]) -> Dict[str, Any]:
        """Sign up a new user"""
        try:
            print(f"Signing up user: {user_data['name']} ({user_data['mobile']})")
            response = requests.post(f"{BASE_URL}/signup", json=user_data, headers=HEADERS)
            
            if response.status_code in [200, 302]:  # 302 is also success based on Postman
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
    
    def login_user(self, mobile: str) -> Dict[str, Any]:
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
    
    def activate_user(self, mobile: str, code: str) -> Dict[str, Any]:
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
    
    def create_team(self, team_name: str, bio: str, area_id: int, auth_token: str) -> Dict[str, Any]:
        """Create a new team"""
        try:
            print(f"Creating team: {team_name}")
            
            # Using form-data format like in Postman
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
    
    def add_member_to_team(self, phone_number: str, team_id: int, auth_token: str) -> bool:
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
    
    def set_member_role(self, phone_number: str, team_id: int, role: str, auth_token: str) -> bool:
        """Set member role in team"""
        try:
            print(f"Setting role {role} for member {phone_number} in team {team_id}")
            
            data = {
                "phone_number": phone_number,
                "team_id": team_id,
                "role": role  # member or subleader (leader is automatic for team creator)
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
    
    def create_all_users(self) -> List[Dict[str, Any]]:
        """Create and activate all 24 users"""
        print("=== Creating 24 Users ===")
        activated_users = []
        
        for i in range(24):
            print(f"\nProcessing user {i+1}/24")
            
            # Generate user data
            user_data = self.generate_user_data(i)
            
            # Sign up user
            signup_result = self.signup_user(user_data)
            if not signup_result:
                continue
            
            # Small delay between requests
            time.sleep(1)
            
            # Login user
            login_result = self.login_user(user_data['mobile'])
            if not login_result:
                continue
            
            # Extract verification code (usually 11111 for test environment)
            verification_code = login_result.get('data', {}).get('code', '11111')
            
            time.sleep(1)
            
            # Activate user
            activation_result = self.activate_user(user_data['mobile'], str(verification_code))
            if not activation_result:
                continue
            
            # Store complete user data
            complete_user_data = {
                **user_data,
                'verification_code': verification_code,
                'access_token': activation_result.get('data', {}).get('access_token'),
                'user_id': activation_result.get('data', {}).get('user', {}).get('id'),
                'activation_success': True
            }
            activated_users.append(complete_user_data)
            
            print(f"✓ User {i+1}/24 completed successfully")
            time.sleep(2)  # Delay between users to avoid rate limiting
        
        print(f"\n=== User Creation Complete: {len(activated_users)}/24 users activated ===")
        return activated_users
    
    def create_teams_with_members(self, users: List[Dict[str, Any]]) -> List[Dict[str, Any]]:
        """Create 2 teams and assign members with roles"""
        print("\n=== Creating Teams and Assigning Members ===")
        
        if len(users) < 24:
            print(f"Warning: Only {len(users)} users available, need 24 for proper team structure")
        
        teams = []
        
        # Team 1: Phoenix Warriors
        team1_leader = users[0]  # First user as leader
        team1_subleader = users[1]  # Second user as sub-leader
        team1_members = users[2:12]  # Next 10 users as members
        
        print(f"\nCreating Team 1 with leader: {team1_leader['name']}")
        team1_result = self.create_team(
            "Phoenix Warriors", 
            "Elite football team from Riyadh - Ready for championship battles", 
            1, 
            team1_leader['access_token']
        )
        
        if team1_result:
            team1_id = team1_result.get('data', {}).get('team', {}).get('id')
            if team1_id:
                team1_data = {
                    'team_id': team1_id,
                    'name': 'Phoenix Warriors',
                    'leader': team1_leader,
                    'subleader': team1_subleader,
                    'members': team1_members,
                    'all_members': [team1_leader, team1_subleader] + team1_members
                }
                
                # Add subleader and members to team
                time.sleep(2)
                if self.add_member_to_team(team1_subleader['mobile'], team1_id, team1_leader['access_token']):
                    time.sleep(1)
                    self.set_member_role(team1_subleader['mobile'], team1_id, 'subleader', team1_leader['access_token'])
                
                # Add regular members
                for member in team1_members:
                    time.sleep(2)
                    if self.add_member_to_team(member['mobile'], team1_id, team1_leader['access_token']):
                        time.sleep(1)
                        self.set_member_role(member['mobile'], team1_id, 'member', team1_leader['access_token'])
                
                teams.append(team1_data)
                print(f"✓ Team 1 (Phoenix Warriors) created with {len(team1_data['all_members'])} members")
        
        # Team 2: Desert Eagles
        if len(users) >= 24:
            team2_leader = users[12]  # 13th user as leader
            team2_subleader = users[13]  # 14th user as sub-leader
            team2_members = users[14:24]  # Last 10 users as members
            
            print(f"\nCreating Team 2 with leader: {team2_leader['name']}")
            team2_result = self.create_team(
                "Desert Eagles", 
                "Powerful football team from Saudi Arabia - Champions in the making", 
                1, 
                team2_leader['access_token']
            )
            
            if team2_result:
                team2_id = team2_result.get('data', {}).get('team', {}).get('id')
                if team2_id:
                    team2_data = {
                        'team_id': team2_id,
                        'name': 'Desert Eagles',
                        'leader': team2_leader,
                        'subleader': team2_subleader,
                        'members': team2_members,
                        'all_members': [team2_leader, team2_subleader] + team2_members
                    }
                    
                    # Add subleader and members to team
                    time.sleep(2)
                    if self.add_member_to_team(team2_subleader['mobile'], team2_id, team2_leader['access_token']):
                        time.sleep(1)
                        self.set_member_role(team2_subleader['mobile'], team2_id, 'subleader', team2_leader['access_token'])
                    
                    # Add regular members
                    for member in team2_members:
                        time.sleep(2)
                        if self.add_member_to_team(member['mobile'], team2_id, team2_leader['access_token']):
                            time.sleep(1)
                            self.set_member_role(member['mobile'], team2_id, 'member', team2_leader['access_token'])
                    
                    teams.append(team2_data)
                    print(f"✓ Team 2 (Desert Eagles) created with {len(team2_data['all_members'])} members")
        
        print(f"\n=== Teams Creation Complete: {len(teams)} teams created ===")
        return teams
    
    def generate_report_files(self, users: List[Dict[str, Any]], teams: List[Dict[str, Any]]):
        """Generate comprehensive text files with all details"""
        print("\n=== Generating Report Files ===")
        
        # Main comprehensive report
        with open('remuntada_test_data_complete.txt', 'w', encoding='utf-8') as f:
            f.write("REMUNTADA TEST DATA - COMPLETE REPORT\n")
            f.write("="*50 + "\n\n")
            f.write(f"Generated on: {time.strftime('%Y-%m-%d %H:%M:%S')}\n")
            f.write(f"Total Users Created: {len(users)}\n")
            f.write(f"Total Teams Created: {len(teams)}\n\n")
            
            # API Configuration
            f.write("API CONFIGURATION:\n")
            f.write("-"*20 + "\n")
            f.write(f"Base URL: {BASE_URL}\n")
            f.write("Login Endpoint: /login\n")
            f.write("Activate Endpoint: /activate\n")
            f.write("Team Store Endpoint: /team/store\n\n")
            
            # Users Section
            f.write("ALL USERS DETAILS:\n")
            f.write("-"*20 + "\n")
            for i, user in enumerate(users, 1):
                f.write(f"\nUser #{i}:\n")
                f.write(f"  Name: {user['name']}\n")
                f.write(f"  Phone: {user['mobile']}\n")
                f.write(f"  Email: {user['email']}\n")
                f.write(f"  Password: {user['password']}\n")
                f.write(f"  Access Token: {user.get('access_token', 'N/A')}\n")
                f.write(f"  User ID: {user.get('user_id', 'N/A')}\n")
                f.write(f"  Verification Code: {user.get('verification_code', 'N/A')}\n")
                f.write(f"  Area ID: {user['area_id']}\n")
                f.write(f"  Location ID: {user['location_id']}\n")
            
            # Teams Section
            f.write(f"\n\n{'='*50}\n")
            f.write("TEAMS DETAILS:\n")
            f.write("-"*20 + "\n")
            
            for i, team in enumerate(teams, 1):
                f.write(f"\nTeam #{i}: {team['name']}\n")
                f.write(f"  Team ID: {team['team_id']}\n")
                f.write(f"  Total Members: {len(team['all_members'])}\n\n")
                
                f.write(f"  LEADER:\n")
                leader = team['leader']
                f.write(f"    Name: {leader['name']}\n")
                f.write(f"    Phone: {leader['mobile']}\n")
                f.write(f"    Access Token: {leader['access_token']}\n\n")
                
                f.write(f"  SUB-LEADER:\n")
                subleader = team['subleader']
                f.write(f"    Name: {subleader['name']}\n")
                f.write(f"    Phone: {subleader['mobile']}\n")
                f.write(f"    Access Token: {subleader['access_token']}\n\n")
                
                f.write(f"  MEMBERS:\n")
                for j, member in enumerate(team['members'], 1):
                    f.write(f"    Member {j}: {member['name']} - {member['mobile']}\n")
                    f.write(f"      Token: {member['access_token']}\n")
            
            # Quick Login Guide
            f.write(f"\n\n{'='*50}\n")
            f.write("QUICK LOGIN GUIDE:\n")
            f.write("-"*20 + "\n")
            f.write("To login any account:\n")
            f.write("1. Use POST /login with mobile number\n")
            f.write("2. Use verification code: 11111 (or check above)\n")
            f.write("3. Use POST /activate with code and mobile\n")
            f.write("4. Use the access token for authenticated requests\n\n")
            
            f.write("Sample Login Request:\n")
            f.write('{\n  "mobile": "0536925874"\n}\n\n')
            
            f.write("Sample Activate Request:\n")
            f.write('{\n')
            f.write('  "code": "11111",\n')
            f.write('  "mobile": "0536925874",\n')
            f.write('  "uuid": "550e8400-e29b-41d4-a716-446655440000",\n')
            f.write('  "device_token": "dGhpc19pc19hX2RldmljZV90b2tlbl9leGFtcGxl",\n')
            f.write('  "device_type": "ios"\n')
            f.write('}\n')
        
        # Quick reference file for phone numbers only
        with open('phone_numbers_only.txt', 'w', encoding='utf-8') as f:
            f.write("PHONE NUMBERS FOR QUICK TESTING\n")
            f.write("="*35 + "\n\n")
            for i, user in enumerate(users, 1):
                f.write(f"{i:2d}. {user['mobile']} - {user['name']}\n")
        
        # Teams summary file
        with open('teams_summary.txt', 'w', encoding='utf-8') as f:
            f.write("TEAMS SUMMARY\n")
            f.write("="*20 + "\n\n")
            for team in teams:
                f.write(f"Team: {team['name']} (ID: {team['team_id']})\n")
                f.write(f"Leader: {team['leader']['name']} - {team['leader']['mobile']}\n")
                f.write(f"Sub-Leader: {team['subleader']['name']} - {team['subleader']['mobile']}\n")
                f.write(f"Members ({len(team['members'])}):\n")
                for member in team['members']:
                    f.write(f"  - {member['name']} - {member['mobile']}\n")
                f.write("\n")
        
        print("✓ Report files generated:")
        print("  - remuntada_test_data_complete.txt (comprehensive report)")
        print("  - phone_numbers_only.txt (quick reference)")
        print("  - teams_summary.txt (teams overview)")
    
    def run(self):
        """Main execution method"""
        print("REMUNTADA TEST DATA GENERATOR")
        print("="*40)
        print("This will create:")
        print("- 24 users with phone numbers starting with '05'")
        print("- Login and activate all accounts") 
        print("- Create 2 teams with proper role assignments")
        print("- Generate comprehensive text files with all details")
        print()
        
        try:
            # Create and activate users
            users = self.create_all_users()
            
            if len(users) < 12:
                print(f"Error: Only {len(users)} users created. Need at least 12 for teams.")
                return
            
            # Create teams with members
            teams = self.create_teams_with_members(users)
            
            # Generate report files
            self.generate_report_files(users, teams)
            
            print(f"\n{'='*50}")
            print("TEST DATA GENERATION COMPLETED SUCCESSFULLY!")
            print(f"{'='*50}")
            print(f"✓ Created {len(users)} users")
            print(f"✓ Created {len(teams)} teams")
            print("✓ Generated detailed report files")
            print("\nFiles created:")
            print("- remuntada_test_data_complete.txt")
            print("- phone_numbers_only.txt") 
            print("- teams_summary.txt")
            
        except Exception as e:
            print(f"\n✗ Error during execution: {str(e)}")
            import traceback
            traceback.print_exc()

if __name__ == "__main__":
    generator = RemuntadaTestDataGenerator()
    generator.run()