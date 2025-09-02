const axios = require('axios');
const fs = require('fs');

const API_URL = 'https://pre-montada.gostcode.com/api/signup';

// Generate a random phone number starting with 05 followed by 8 digits
function generatePhoneNumber() {
  const randomDigits = Math.floor(Math.random() * 100000000).toString().padStart(8, '0');
  return `05${randomDigits}`;
}

// Generate a random name
function generateName() {
  const firstNames = ['Ahmed', 'Mohammed', 'Ali', 'Hassan', 'Omar', 'Khaled', 'Sultan', 'Abdullah', 'Youssef', 'Ibrahim'];
  const lastNames = ['Al-Saud', 'Al-Rashid', 'Al-Harbi', 'Al-Zahrani', 'Al-Fahad', 'Al-Mansouri', 'Al-Qasimi', 'Al-Naimi', 'Al-Thani', 'Al-Mahmoud'];
  const firstName = firstNames[Math.floor(Math.random() * firstNames.length)];
  const lastName = lastNames[Math.floor(Math.random() * lastNames.length)];
  return `${firstName} ${lastName}`;
}

// Generate a random email
function generateEmail(name) {
  const domains = ['gmail.com', 'yahoo.com', 'hotmail.com', 'outlook.com'];
  const cleanName = name.toLowerCase().replace(/\s+/g, '.');
  const domain = domains[Math.floor(Math.random() * domains.length)];
  const randomNum = Math.floor(Math.random() * 1000);
  return `${cleanName}${randomNum}@${domain}`;
}

async function createAccount(phoneNumber) {
  const name = generateName();
  const email = generateEmail(name);

  // Try with form data first
  const formData = new URLSearchParams();
  formData.append('name', name);
  formData.append('mobile', phoneNumber);
  formData.append('email', email);
  formData.append('area_id', '1');
  formData.append('location_id', '10');
  formData.append('password', 'DemoPass123!');
  formData.append('lang', 'ar');

  try {
    console.log(`Creating account for ${phoneNumber} (trying form data)...`);
    const response = await axios.post(API_URL, formData, {
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

    if (response.status === 302 || response.status === 301) {
      console.log(`🔄 Redirect response for ${phoneNumber} - following redirect...`);
      const finalUrl = response.headers.location || response.request.res.responseUrl;
      console.log(`📍 Redirected to: ${finalUrl}`);
      return {
        phoneNumber,
        name,
        email,
        status: 'redirect',
        response: `Redirected to: ${finalUrl}`
      };
    }

    console.log(`✅ Account created successfully for ${phoneNumber} (Status: ${response.status})`);
    return {
      phoneNumber,
      name,
      email,
      status: 'success',
      response: response.data
    };
  } catch (error) {
    // If form data fails, try with JSON
    console.log(`Form data failed for ${phoneNumber}, trying JSON...`);
    
    const accountData = {
      name: name,
      mobile: phoneNumber,
      email: email,
      area_id: 1,
      location_id: 10,
      password: 'DemoPass123!',
      lang: 'ar'
    };

    try {
      const response = await axios.post(API_URL, accountData, {
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36'
        },
        maxRedirects: 5,
        validateStatus: function (status) {
          return status >= 200 && status < 400;
        }
      });

      if (response.status === 302 || response.status === 301) {
        console.log(`🔄 Redirect response for ${phoneNumber} - following redirect...`);
        const finalUrl = response.headers.location || response.request.res.responseUrl;
        console.log(`📍 Redirected to: ${finalUrl}`);
        return {
          phoneNumber,
          name,
          email,
          status: 'redirect',
          response: `Redirected to: ${finalUrl}`
        };
      }

      console.log(`✅ Account created successfully for ${phoneNumber} (Status: ${response.status})`);
      return {
        phoneNumber,
        name,
        email,
        status: 'success',
        response: response.data
      };
    } catch (jsonError) {
      if (jsonError.response) {
        if (jsonError.response.status === 302 || jsonError.response.status === 301) {
          console.log(`🔄 Redirect response for ${phoneNumber} - following redirect...`);
          const finalUrl = jsonError.response.headers.location;
          console.log(`📍 Redirected to: ${finalUrl}`);
          return {
            phoneNumber,
            name,
            email,
            status: 'redirect',
            response: `Redirected to: ${finalUrl}`
          };
        }

        console.log(`❌ Failed to create account for ${phoneNumber}: Status ${jsonError.response.status} - ${jsonError.response.statusText}`);
        return {
          phoneNumber,
          name,
          email,
          status: 'failed',
          error: `Status ${jsonError.response.status}: ${jsonError.response.statusText}`
        };
      }

      console.log(`❌ Failed to create account for ${phoneNumber}: ${jsonError.message}`);
      return {
        phoneNumber,
        name,
        email,
        status: 'failed',
        error: jsonError.message
      };
    }
  }
}

async function main() {
  const accounts = [];
  const usedNumbers = new Set();

  console.log('🚀 Starting to create 30 demo accounts...\n');

  for (let i = 0; i < 30; i++) {
    let phoneNumber;
    do {
      phoneNumber = generatePhoneNumber();
    } while (usedNumbers.has(phoneNumber));

    usedNumbers.add(phoneNumber);

    const account = await createAccount(phoneNumber);
    accounts.push(account);

    // Add a small delay to avoid overwhelming the API
    await new Promise(resolve => setTimeout(resolve, 200));
  }

  // Save results to file
  const output = accounts.map(account =>
    `${account.phoneNumber},${account.name},${account.email},${account.status}`
  ).join('\n');

  fs.writeFileSync('created_accounts.txt', output);

  console.log('\n📝 Results saved to created_accounts.txt');
  console.log(`✅ Successfully created: ${accounts.filter(a => a.status === 'success' || a.status === 'redirect').length} accounts`);
  console.log(`❌ Failed: ${accounts.filter(a => a.status === 'failed').length} accounts`);

  // Show summary
  console.log('\n📋 Summary:');
  accounts.forEach(account => {
    if (account.status === 'success' || account.status === 'redirect') {
      console.log(`✅ ${account.phoneNumber} - ${account.name}`);
    } else {
      console.log(`❌ ${account.phoneNumber} - ${account.error}`);
    }
  });
}

main().catch(console.error);
