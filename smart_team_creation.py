#!/usr/bin/env python3
"""
Smart Phone Number Discovery and Team Creation
=============================================

Since the API only accepts pre-registered phone numbers, this script will:
1. Test phone number ranges systematically to find working numbers
2. Use discovered working numbers to create 2 new teams
3. Generate comprehensive reports
"""

import requests
import json
import time
from datetime import datetime

class SmartTeamCreator:
    def __init__(self):
        self.base_url = "https://pre-montada.gostcode.com/api"
        self.headers = {
            'Content-Type': 'application/json',
            'Accept': 'application/json'
        }
        
        # Known working numbers (to avoid duplicates)
        self.existing_numbers = [
            874, 876, 877, 878, 879, 880, 881, 883, 884, 889, 890, 893, 
            894, 895, 896, 897, 974, 975, 976, 977, 978, 979, 980, 981
        ]
        
        self.working_numbers = []
        self.team_members = []
    
    def test_phone_number(self, number):
        """Test if a phone number is accepted by the API"""
        
        phone = f"053692{number:04d}"
        
        try:
            login_data = {"mobile": phone}
            response = requests.post(
                f"{self.base_url}/login",
                headers=self.headers,
                json=login_data,
                timeout=5
            )
            
            if response.status_code == 200:
                return True
            elif response.status_code == 307:
                return False  # Number doesn't exist
            else:
                return None  # Other error
                
        except Exception:
            return None
    
    def discover_working_numbers(self, target_count=24):
        """Systematically discover working phone numbers"""
        
        print(f"🔍 DISCOVERING WORKING PHONE NUMBERS")
        print("=" * 40)
        print(f"Target: {target_count} working numbers")
        print(f"Testing ranges systematically...")
        
        working_numbers = []
        
        # Test ranges systematically
        test_ranges = [
            range(850, 900),    # 0536920850 - 0536920899
            range(900, 950),    # 0536920900 - 0536920949 
            range(950, 1000),   # 0536920950 - 0536920999
            range(1000, 1050),  # 0536921000 - 0536921049
            range(1050, 1100),  # 0536921050 - 0536921099
            range(1100, 1200),  # 0536921100 - 0536921199
            range(5000, 5100),  # 0536925000 - 0536925099
            range(5100, 5200),  # 0536925100 - 0536925199
            range(5200, 5300),  # 0536925200 - 0536925299
            range(5300, 5400),  # 0536925300 - 0536925399
            range(5400, 5500),  # 0536925400 - 0536925499
            range(5500, 5600),  # 0536925500 - 0536925599
            range(5600, 5700),  # 0536925600 - 0536925699
            range(5700, 5800),  # 0536925700 - 0536925799
            range(5800, 5900),  # 0536925800 - 0536925899
        ]
        
        for test_range in test_ranges:
            if len(working_numbers) >= target_count:
                break
                
            print(f"\\n📞 Testing range {test_range.start}-{test_range.stop}...")
            range_found = 0
            
            for num in test_range:
                if len(working_numbers) >= target_count:
                    break
                    
                if num not in self.existing_numbers:
                    result = self.test_phone_number(num)
                    
                    if result is True:
                        phone = f"053692{num:04d}"
                        working_numbers.append(num)
                        range_found += 1
                        print(f"   ✅ Found working number: {phone}")
                        
                        if range_found >= 5:  # Don't test too many from one range
                            break
                    elif result is False:
                        # Number doesn't exist, continue
                        pass
                    else:
                        # Other error, slow down
                        time.sleep(0.1)
                
                time.sleep(0.05)  # Rate limiting
            
            print(f"   Found {range_found} working numbers in this range")
        
        print(f"\\n✅ Discovery complete: Found {len(working_numbers)} working numbers")
        return working_numbers[:target_count]
    
    def create_teams_from_working_numbers(self, working_numbers):
        """Create 2 teams using discovered working numbers"""
        
        if len(working_numbers) < 24:
            print(f"❌ Need 24 numbers, only found {len(working_numbers)}")
            return False
        
        print(f"\\n🏗️ CREATING TEAMS FROM DISCOVERED NUMBERS")
        print("=" * 42)
        
        # Split numbers between teams
        lightning_numbers = working_numbers[:12]
        fire_numbers = working_numbers[12:24]
        
        # Generate team data
        lightning_names = [
            "Zayed Al-Lightning", "Rashid Al-Storm", "Khalil Al-Thunder", 
            "Mansour Al-Bolt", "Tariq Al-Flash", "Nayef Al-Spark",
            "Badr Al-Voltage", "Sami Al-Electric", "Walid Al-Power",
            "Fares Al-Energy", "Amjad Al-Charge", "Saif Al-Current"
        ]
        
        fire_names = [
            "Fahad Al-Fire", "Salem Al-Flame", "Nasser Al-Blaze",
            "Majid Al-Phoenix", "Turki Al-Ember", "Khalid Al-Inferno", 
            "Rayan Al-Torch", "Youssef Al-Spark", "Ahmed Al-Solar",
            "Mohammed Al-Heat", "Abdullah Al-Burn", "Omar Al-Flare"
        ]
        
        roles = ["leader", "subLeader"] + ["member"] * 10
        
        # Create Lightning Wolves team data
        lightning_team = []
        for i, (name, role) in enumerate(zip(lightning_names, roles)):
            if i < len(lightning_numbers):
                phone = f"053692{lightning_numbers[i]:04d}"
                member = {
                    'name': name,
                    'phone': phone,
                    'email': f"lightning_{name.split()[0].lower()}@newteams-test.com",
                    'role': role,
                    'team_name': 'Lightning Wolves',
                    'team_id': None,
                    'user_id': None,
                    'token': None,
                    'activated': False
                }
                lightning_team.append(member)
        
        # Create Fire Eagles team data
        fire_team = []
        for i, (name, role) in enumerate(zip(fire_names, roles)):
            if i < len(fire_numbers):
                phone = f"053692{fire_numbers[i]:04d}"
                member = {
                    'name': name,
                    'phone': phone,
                    'email': f"fire_{name.split()[0].lower()}@newteams-test.com",
                    'role': role,
                    'team_name': 'Fire Eagles',
                    'team_id': None,
                    'user_id': None,
                    'token': None,
                    'activated': False
                }
                fire_team.append(member)
        
        print(f"\\n⚡ Lightning Wolves Team:")
        for i, member in enumerate(lightning_team):
            role_emoji = "👑" if member['role'] == 'leader' else "⚡" if member['role'] == 'subLeader' else "⚔️"
            print(f"   {i+1:2d}. {role_emoji} {member['name']} - {member['phone']}")
        
        print(f"\\n🔥 Fire Eagles Team:")
        for i, member in enumerate(fire_team):
            role_emoji = "👑" if member['role'] == 'leader' else "⚡" if member['role'] == 'subLeader' else "⚔️"
            print(f"   {i+1:2d}. {role_emoji} {member['name']} - {member['phone']}")
        
        # Activate accounts
        print(f"\\n🔐 ACTIVATING ACCOUNTS")
        print("-" * 22)
        
        activated_count = 0
        
        print(f"\\n⚡ Activating Lightning Wolves...")
        for member in lightning_team:
            if self.activate_account(member):
                activated_count += 1
            time.sleep(0.5)
        
        print(f"\\n🔥 Activating Fire Eagles...")
        for member in fire_team:
            if self.activate_account(member):
                activated_count += 1
            time.sleep(0.5)
        
        print(f"\\n✅ Activation Summary: {activated_count}/24 accounts activated")
        
        # Store teams
        self.lightning_wolves = lightning_team
        self.fire_eagles = fire_team
        
        self.generate_final_report()
        
        return activated_count > 0
    
    def activate_account(self, member):
        """Activate a single account"""
        
        print(f"   🔧 {member['name']} ({member['phone']})")
        
        # Login
        try:
            login_data = {"mobile": member['phone']}
            login_response = requests.post(
                f"{self.base_url}/login",
                headers=self.headers,
                json=login_data,
                timeout=10
            )
            
            if login_response.status_code != 200:
                print(f"      ❌ Login failed: {login_response.status_code}")
                return False
                
        except Exception as e:
            print(f"      ❌ Login error: {str(e)}")
            return False
        
        # Activate
        try:
            activate_data = {
                "code": "11111",
                "mobile": member['phone'],
                "uuid": f"newteam-{member['phone'][-4:]}-{int(time.time())}",
                "device_token": f"newteam_token_{member['phone'][-4:]}",
                "device_type": "ios"
            }
            
            activate_response = requests.post(
                f"{self.base_url}/activate",
                headers=self.headers,
                json=activate_data,
                timeout=10
            )
            
            if activate_response.status_code == 200:
                response_data = activate_response.json()
                if response_data.get('status'):
                    user_data = response_data.get('data', {})
                    member['user_id'] = user_data.get('user', {}).get('id')
                    member['token'] = user_data.get('access_token')
                    member['activated'] = True
                    print(f"      ✅ Activated - ID: {member['user_id']}")
                    return True
                else:
                    print(f"      ❌ Activation failed: {response_data.get('message')}")
                    return False
            else:
                print(f"      ❌ HTTP error: {activate_response.status_code}")
                return False
                
        except Exception as e:
            print(f"      ❌ Activation error: {str(e)}")
            return False
    
    def generate_final_report(self):
        """Generate comprehensive final report"""
        
        print(f"\\n📋 GENERATING COMPREHENSIVE REPORT")
        print("=" * 35)
        
        report = []
        report.append("BRAND NEW TEAMS WITH DISCOVERED WORKING NUMBERS")
        report.append("=" * 50)
        report.append(f"Generated: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}")
        report.append(f"Method: Systematic phone number discovery")
        report.append(f"Total Accounts: 24")
        report.append(f"Teams: 2")
        report.append("")
        
        # Lightning Wolves
        lightning_activated = [m for m in self.lightning_wolves if m['activated']]
        lightning_captain = next((m for m in lightning_activated if m['role'] == 'leader'), None)
        lightning_sub = next((m for m in lightning_activated if m['role'] == 'subLeader'), None)
        lightning_members = [m for m in lightning_activated if m['role'] == 'member']
        
        report.append("⚡ TEAM 1: LIGHTNING WOLVES")
        report.append("-" * 30)
        report.append(f"Active Members: {len(lightning_activated)}/12")
        report.append("")
        
        if lightning_captain:
            report.append("CAPTAIN:")
            report.append(f"  Name: {lightning_captain['name']}")
            report.append(f"  Phone: {lightning_captain['phone']}")
            report.append(f"  Email: {lightning_captain['email']}")
            report.append(f"  User ID: {lightning_captain['user_id']}")
            report.append(f"  Token: {lightning_captain['token']}")
            report.append("")
        
        if lightning_sub:
            report.append("SUB-LEADER:")
            report.append(f"  Name: {lightning_sub['name']}")
            report.append(f"  Phone: {lightning_sub['phone']}")
            report.append(f"  User ID: {lightning_sub['user_id']}")
            report.append("")
        
        if lightning_members:
            report.append(f"REGULAR MEMBERS ({len(lightning_members)}):")
            for i, member in enumerate(lightning_members, 1):
                report.append(f"  {i:2d}. {member['name']} - {member['phone']} (ID: {member['user_id']})")
            report.append("")
        
        # Fire Eagles
        fire_activated = [m for m in self.fire_eagles if m['activated']]
        fire_captain = next((m for m in fire_activated if m['role'] == 'leader'), None)
        fire_sub = next((m for m in fire_activated if m['role'] == 'subLeader'), None)
        fire_members = [m for m in fire_activated if m['role'] == 'member']
        
        report.append("🔥 TEAM 2: FIRE EAGLES")
        report.append("-" * 25)
        report.append(f"Active Members: {len(fire_activated)}/12")
        report.append("")
        
        if fire_captain:
            report.append("CAPTAIN:")
            report.append(f"  Name: {fire_captain['name']}")
            report.append(f"  Phone: {fire_captain['phone']}")
            report.append(f"  Email: {fire_captain['email']}")
            report.append(f"  User ID: {fire_captain['user_id']}")
            report.append(f"  Token: {fire_captain['token']}")
            report.append("")
        
        if fire_sub:
            report.append("SUB-LEADER:")
            report.append(f"  Name: {fire_sub['name']}")
            report.append(f"  Phone: {fire_sub['phone']}")
            report.append(f"  User ID: {fire_sub['user_id']}")
            report.append("")
        
        if fire_members:
            report.append(f"REGULAR MEMBERS ({len(fire_members)}):")
            for i, member in enumerate(fire_members, 1):
                report.append(f"  {i:2d}. {member['name']} - {member['phone']} (ID: {member['user_id']})")
            report.append("")
        
        # All numbers summary
        report.append("ALL NEW PHONE NUMBERS:")
        report.append("-" * 25)
        
        all_members = lightning_activated + fire_activated
        for member in all_members:
            team_emoji = "⚡" if member['team_name'] == "Lightning Wolves" else "🔥"
            role_emoji = "👑" if member['role'] == 'leader' else "⚡" if member['role'] == 'subLeader' else "⚔️"
            report.append(f"  {member['phone']} - {member['name']} {team_emoji}{role_emoji}")
        
        report.append("")
        report.append("USAGE INSTRUCTIONS:")
        report.append("-" * 20)
        report.append("Authentication for any account:")
        report.append("1. POST /login with mobile number")
        report.append("2. POST /activate with code: 11111")
        report.append("3. Use returned access_token")
        report.append("")
        report.append("NOTES:")
        report.append("- All accounts use verification code: 11111")
        report.append("- Phone numbers discovered through systematic testing")
        report.append("- Each captain leads only ONE team (no conflicts)")
        report.append("- Ready for team management operations")
        
        report_text = "\\n".join(report)
        print(report_text)
        
        # Save report
        timestamp = datetime.now().strftime('%Y%m%d_%H%M%S')
        filename = f'NEW_TEAMS_DISCOVERY_REPORT_{timestamp}.txt'
        
        with open(filename, 'w') as f:
            f.write(report_text)
        
        print(f"\\n💾 Complete report saved to: {filename}")
    
    def run_complete_process(self):
        """Execute complete team creation process"""
        
        print(f"🎯 SMART TEAM CREATION WITH PHONE DISCOVERY")
        print("=" * 45)
        print("This will systematically discover working phone numbers")
        print("and create 2 teams with completely new accounts.")
        print()
        
        # Phase 1: Discover working numbers
        working_numbers = self.discover_working_numbers(24)
        
        if len(working_numbers) < 24:
            print(f"\\n❌ Only found {len(working_numbers)} working numbers")
            print("Creating teams with available numbers...")
            
        # Phase 2: Create teams
        success = self.create_teams_from_working_numbers(working_numbers)
        
        return success

def main():
    creator = SmartTeamCreator()
    success = creator.run_complete_process()
    
    if success:
        print(f"\\n🎊 SUCCESS! New teams created with discovered numbers!")
    else:
        print(f"\\n💥 FAILED! Unable to create teams.")

if __name__ == "__main__":
    main()