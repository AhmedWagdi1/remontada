#!/usr/bin/env python3
"""
Direct API response debugging for team membership issues
"""

import requests
import json

def test_api_endpoints():
    API_BASE_URL = "https://pre-montada.gostcode.com/api"
    session = requests.Session()
    
    # Authenticate
    captain_mobile = "0536925874"
    
    # Login
    print("🔑 Login...")
    login_response = session.post(f"{API_BASE_URL}/login", json={"mobile": captain_mobile})
    print(f"Status: {login_response.status_code}")
    print(f"Response: {json.dumps(login_response.json(), indent=2, ensure_ascii=False)}")
    
    # Activate
    print("\n🔐 Activate...")
    activate_data = {
        "code": "11111",
        "mobile": captain_mobile,
        "uuid": "550e8400-e29b-41d4-a716-446655440000",
        "device_token": "dGhpc19pc19hX2RldmljZV90b2tlbl9leGFtcGxl",
        "device_type": "ios"
    }
    activate_response = session.post(f"{API_BASE_URL}/activate", json=activate_data)
    print(f"Status: {activate_response.status_code}")
    activate_result = activate_response.json()
    print(f"Response: {json.dumps(activate_result, indent=2, ensure_ascii=False)}")
    
    if activate_result.get('status') and 'data' in activate_result and 'access_token' in activate_result['data']:
        token = activate_result['data']['access_token']
        session.headers.update({'Authorization': f'Bearer {token}'})
        
        print(f"\n✅ Authenticated with token: {token[:50]}...")
        
        # Test different endpoints
        endpoints = [
            "/team/user-teams",
            "/team/59",
            "/teams/59", 
            "/team/59/members",
            "/teams",
        ]
        
        for endpoint in endpoints:
            print(f"\n📡 Testing: {endpoint}")
            response = session.get(f"{API_BASE_URL}{endpoint}")
            print(f"Status: {response.status_code}")
            
            try:
                result = response.json()
                print(f"Response: {json.dumps(result, indent=2, ensure_ascii=False)}")
            except:
                print(f"Raw response: {response.text}")
        
        # Test adding member with detailed error
        print(f"\n👥 Testing add member...")
        add_response = session.post(f"{API_BASE_URL}/team/add-member", json={
            "phone_number": "0536925876",
            "team_id": 59
        })
        print(f"Status: {add_response.status_code}")
        try:
            result = add_response.json()
            print(f"Response: {json.dumps(result, indent=2, ensure_ascii=False)}")
        except:
            print(f"Raw response: {add_response.text}")

if __name__ == "__main__":
    test_api_endpoints()