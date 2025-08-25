// Automated account creation script for remontada
// Run: node create_accounts.js

const axios = require('axios');
const fs = require('fs');

const baseUrl = 'https://pre-montada.gostcode.com/api/signup';
const startNumber = 522222222;
const accounts = [];

async function createAccounts() {
  for (let i = 0; i < 100; i++) {
    const mobile = '05' + (startNumber + i).toString().padStart(8, '0');
    const payload = {
      name: `User${i + 1}`,
      mobile: mobile,
      email: `user${i + 1}@example.com`,
      area_id: 1,
      location_id: 10,
      password: 'any-password',
      lang: 'ar'
    };
    try {
      await axios.post(baseUrl, payload);
      accounts.push(mobile);
      console.log(`Created: ${mobile}`);
    } catch (err) {
      console.error(`Failed: ${mobile}`, err.response?.data);
    }
  }
  fs.writeFileSync('created_numbers.txt', accounts.join('\n'));
  console.log('All numbers saved to created_numbers.txt');
}

createAccounts();
