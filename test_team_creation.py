#!/usr/bin/env python3
"""
Simple script to create teams manually
"""

import requests
import time

# API Configuration
BASE_URL = "https://pre-montada.gostcode.com/api"

# First user token (from the original report)
LEADER_TOKEN = "2926|ZgkE0Ov2XwX5AYfOC6Dm8driYZ4ZAvHPfS5K6JUif78f46ab"

def create_team_simple(team_name: str, bio: str, token: str):
    """Create a team with simple approach"""
    print(f"Creating team: {team_name}")
    
    files = {
        'area_id': (None, '1'),
        'bio': (None, bio),
        'name': (None, team_name)
    }
    
    headers = {
        "Accept": "application/json",
        "Authorization": f"Bearer {token}"
    }
    
    try:
        response = requests.post(f"{BASE_URL}/team/store", files=files, headers=headers)
        print(f"Status code: {response.status_code}")
        print(f"Response: {response.text}")
        
        if response.status_code == 200:
            result = response.json()
            if result.get('status'):
                print(f"✓ Team created successfully: {team_name}")
                return result
            else:
                print(f"✗ Team creation failed: {result.get('message')}")
        else:
            print(f"✗ HTTP Error: {response.status_code}")
        
    except Exception as e:
        print(f"✗ Error: {str(e)}")
    
    return None

def test_user_login():
    """Test login with first user"""
    print("Testing login with first user...")
    
    login_data = {"mobile": "0536925874"}
    headers = {"Content-Type": "application/json", "Accept": "application/json"}
    
    try:
        response = requests.post(f"{BASE_URL}/login", json=login_data, headers=headers)
        print(f"Login response: {response.status_code}")
        print(f"Login data: {response.text}")
        
        if response.status_code in [200, 302]:
            result = response.json()
            verification_code = result.get('data', {}).get('code', '11111')
            
            # Now activate
            activation_data = {
                "code": str(verification_code),
                "mobile": "0536925874",
                "uuid": "550e8400-e29b-41d4-a716-446655440000",
                "device_token": "dGhpc19pc19hX2RldmljZV90b2tlbl9leGFtcGxl",
                "device_type": "ios"
            }
            
            time.sleep(1)
            activate_response = requests.post(f"{BASE_URL}/activate", json=activation_data, headers=headers)
            print(f"Activate response: {activate_response.status_code}")
            activate_result = activate_response.json()
            print(f"Activate data: {activate_result}")
            
            if activate_result.get('status'):
                new_token = activate_result.get('data', {}).get('access_token')
                print(f"New token: {new_token}")
                return new_token
        
    except Exception as e:
        print(f"Error: {str(e)}")
    
    return None

# Test login and get new token
new_token = test_user_login()
if new_token:
    print(f"\nUsing new token: {new_token}")
    # Try creating a team with unique name
    create_team_simple("Thunder Bolts FC", "Fast and powerful team from Riyadh", new_token)
else:
    print("Failed to get new token")