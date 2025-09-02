const axios = require('axios');
const fs = require('fs');

const API_BASE_URL = 'https://pre-montada.gostcode.com/public/api';

// Read the created accounts
const accountsData = fs.readFileSync('created_accounts.txt', 'utf8');
const accounts = accountsData.split('\n')
  .filter(line => line.trim())
  .map(line => {
    const [phone, name, email, status] = line.split(',');
    return { phone, name, email, status };
  });

console.log(`📋 Loaded ${accounts.length} accounts from created_accounts.txt`);

// Function to activate an account using the /activate endpoint
async function activateAccount(phoneNumber, accountName) {
  try {
    console.log(`🔓 Activating account: ${accountName} (${phoneNumber})`);

    const response = await axios.post(`${API_BASE_URL}/activate`, {
      mobile: phoneNumber,
      code: '11111', // Demo activation code
      device_token: "demo_device_token",
      device_type: "android",
      uuid: "demo-uuid-12345"
    }, {
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json'
      },
      maxRedirects: 5,
      validateStatus: function (status) {
        return status >= 200 && status < 400;
      }
    });

    console.log(`📡 Activation response status: ${response.status}`);
    console.log(`📡 Activation response data:`, JSON.stringify(response.data, null, 2));

    if (response.data && response.data.status === true) {
      console.log(`✅ Account activated successfully: ${accountName} (${phoneNumber})`);
      return true;
    } else {
      console.log(`❌ Account activation failed: ${accountName} (${phoneNumber})`);
      return false;
    }
  } catch (error) {
    console.log(`❌ Activation error for ${accountName} (${phoneNumber}): ${error.message}`);
    if (error.response) {
      console.log(`📡 Error response status: ${error.response.status}`);
      console.log(`📡 Error response data:`, JSON.stringify(error.response.data, null, 2));
    }
    return false;
  }
}

async function main() {
  console.log('🚀 Starting account activation process...\n');

  const activationResults = [];
  let successCount = 0;
  let failCount = 0;

  for (let i = 0; i < accounts.length; i++) {
    const account = accounts[i];
    console.log(`\n[${i + 1}/${accounts.length}] Processing: ${account.name}`);

    const success = await activateAccount(account.phone, account.name);

    activationResults.push({
      phone: account.phone,
      name: account.name,
      email: account.email,
      originalStatus: account.status,
      activationResult: success ? 'SUCCESS' : 'FAILED'
    });

    if (success) {
      successCount++;
    } else {
      failCount++;
    }

    // Add a small delay to avoid overwhelming the server
    await new Promise(resolve => setTimeout(resolve, 300));
  }

  // Generate activation report
  console.log('\n📊 ACTIVATION REPORT');
  console.log('='.repeat(50));
  console.log(`Total Accounts: ${accounts.length}`);
  console.log(`✅ Successfully Activated: ${successCount}`);
  console.log(`❌ Failed to Activate: ${failCount}`);
  console.log('='.repeat(50));

  // Save detailed results to file
  let report = '🔓 ACCOUNT ACTIVATION REPORT\n';
  report += '=' .repeat(50) + '\n\n';
  report += `Total Accounts Processed: ${accounts.length}\n`;
  report += `Successfully Activated: ${successCount}\n`;
  report += `Failed to Activate: ${failCount}\n\n`;

  report += 'DETAILED RESULTS:\n';
  report += '-'.repeat(50) + '\n';

  activationResults.forEach((result, index) => {
    report += `${index + 1}. ${result.name}\n`;
    report += `   Phone: ${result.phone}\n`;
    report += `   Email: ${result.email}\n`;
    report += `   Original Status: ${result.originalStatus}\n`;
    report += `   Activation Result: ${result.activationResult}\n\n`;
  });

  fs.writeFileSync('activation_report.txt', report);

  console.log('\n📝 Detailed activation report saved to activation_report.txt');

  if (successCount === accounts.length) {
    console.log('🎉 All accounts activated successfully!');
  } else if (successCount > 0) {
    console.log(`⚠️  ${successCount} accounts activated, ${failCount} failed.`);
  } else {
    console.log('❌ No accounts were activated. Please check the errors above.');
  }
}

main().catch(console.error);
