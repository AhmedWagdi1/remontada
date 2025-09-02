const axios = require('axios');
const fs = require('fs');

const API_BASE_URL = 'https://pre-montada.gostcode.com/public/api';

// Generate a random phone number starting with 05 followed by 8 digits
function generatePhoneNumber() {
  const randomDigits = Math.floor(Math.random() * 100000000).toString().padStart(8, '0');
  return `05${randomDigits}`;
}

// Generate a random name
function generateName() {
  const firstNames = ['Ahmed', 'Mohammed', 'Ali', 'Hassan', 'Omar', 'Khaled', 'Sultan', 'Abdullah', 'Youssef', 'Ibrahim', 'Fahad', 'Saad', 'Nasser', 'Bandar', 'Talal'];
  const lastNames = ['Al-Saud', 'Al-Rashid', 'Al-Harbi', 'Al-Zahrani', 'Al-Fahad', 'Al-Mansouri', 'Al-Qasimi', 'Al-Naimi', 'Al-Thani', 'Al-Mahmoud', 'Al-Khalidi', 'Al-Zamil', 'Al-Ghamdi', 'Al-Sharif', 'Al-Muqrin'];
  const firstName = firstNames[Math.floor(Math.random() * firstNames.length)];
  const lastName = lastNames[Math.floor(Math.random() * lastNames.length)];
  return `${firstName} ${lastName}`;
}

// Generate a random email
function generateEmail(name) {
  const domains = ['gmail.com', 'yahoo.com', 'hotmail.com', 'outlook.com'];
  const cleanName = name.toLowerCase().replace(/\s+/g, '.');
  const domain = domains[Math.floor(Math.random() * domains.length)];
  const randomNum = Math.floor(Math.random() * 10000);
  return `${cleanName}${randomNum}@${domain}`;
}

async function createAccount(phoneNumber) {
  const name = generateName();
  const email = generateEmail(name);

  const formData = new URLSearchParams();
  formData.append('name', name);
  formData.append('mobile', phoneNumber);
  formData.append('email', email);
  formData.append('area_id', '1');
  formData.append('location_id', '10');
  formData.append('password', 'TestPass123!');
  formData.append('lang', 'ar');

  try {
    console.log(`📝 Creating account for ${phoneNumber} (${name})...`);
    const response = await axios.post(`${API_BASE_URL}/signup`, formData, {
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
        'Accept': 'application/json',
        'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36'
      },
      maxRedirects: 5,
      validateStatus: function (status) {
        return status >= 200 && status < 400;
      }
    });

    console.log(`📡 Response status: ${response.status}`);
    console.log(`📡 Response data:`, JSON.stringify(response.data, null, 2));

    if (response.status === 302 || (response.data && response.data.status === true)) {
      console.log(`✅ Account created successfully: ${name} (${phoneNumber})`);
      return { phone: phoneNumber, name, email, status: 'success' };
    } else {
      console.log(`❌ Account creation failed: ${name} (${phoneNumber})`);
      return { phone: phoneNumber, name, email, status: 'failed' };
    }
  } catch (error) {
    console.log(`❌ Error creating account for ${phoneNumber}: ${error.message}`);
    return { phone: phoneNumber, name, email, status: 'error' };
  }
}

async function createNewDemoAccounts() {
  console.log('🏆 CREATING NEW DEMO ACCOUNTS FOR MANUAL TESTING');
  console.log('================================================\n');

  const accounts = [];
  const usedPhones = new Set();

  // Create 30 unique accounts
  while (accounts.length < 30) {
    const phone = generatePhoneNumber();
    if (!usedPhones.has(phone)) {
      usedPhones.add(phone);
      const account = await createAccount(phone);
      accounts.push(account);

      // Add delay to avoid rate limiting
      await new Promise(resolve => setTimeout(resolve, 1000));
    }
  }

  // Save to file
  const output = accounts.map(acc => `${acc.phone},${acc.name},${acc.email},${acc.status}`).join('\n');
  fs.writeFileSync('new_demo_accounts.txt', output);

  console.log(`\n✅ Created ${accounts.length} new demo accounts`);
  console.log('📄 Saved to: new_demo_accounts.txt');

  // Split into 2 teams
  const team1Accounts = accounts.slice(0, 15);
  const team2Accounts = accounts.slice(15, 30);

  console.log(`\n🏆 Team 1: ${team1Accounts.length} members`);
  console.log(`🏆 Team 2: ${team2Accounts.length} members`);

  return { team1Accounts, team2Accounts };
}

// Run the account creation
createNewDemoAccounts().catch(console.error);
