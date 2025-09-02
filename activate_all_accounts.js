const axios = require('axios');
const fs = require('fs');

const API_BASE_URL = 'https://pre-montada.gostcode.com/public/api';

// Read the accounts data
const accountsData = fs.readFileSync('new_demo_accounts.txt', 'utf8');
const accounts = [];

// Parse accounts
const lines = accountsData.split('\n');
for (const line of lines) {
    if (line.trim() && line.includes(',')) {
        const parts = line.split(',');
        if (parts.length >= 4) {
            accounts.push({
                phone: parts[0].trim(),
                name: parts[1].trim(),
                email: parts[2].trim(),
                status: parts[3].trim()
            });
        }
    }
}

console.log('🔄 ACTIVATING ALL NEW DEMO ACCOUNTS');
console.log('====================================\n');

console.log(`📋 Found ${accounts.length} accounts to process\n`);

// Function to activate an account
async function activateAccount(account) {
    try {
        console.log(`🔐 Processing ${account.phone} (${account.name}) - Status: ${account.status}`);

        // Login request
        const loginResponse = await axios.post(`${API_BASE_URL}/login`, {
            mobile: account.phone
        });

        if (!loginResponse.data.status) {
            console.log(`❌ Login failed for ${account.phone}: ${loginResponse.data.message || 'Unknown error'}`);
            return false;
        }

        // Check if we got a token directly (already activated)
        if (loginResponse.data.data && loginResponse.data.data.token) {
            console.log(`✅ Account ${account.phone} is already activated!`);
            console.log(`   Token: ${loginResponse.data.data.token.substring(0, 20)}...`);
            return true;
        }

        const verificationCode = loginResponse.data.data.code;
        console.log(`✅ Got verification code: ${verificationCode} for ${account.phone}`);

        // Activate account
        const activateResponse = await axios.post(`${API_BASE_URL}/activate`, {
            mobile: account.phone,
            code: verificationCode
        });

        if (!activateResponse.data.status) {
            console.log(`❌ Activation failed for ${account.phone}: ${activateResponse.data.message || 'Unknown error'}`);
            return false;
        }

        const token = activateResponse.data.data.token;
        console.log(`✅ SUCCESS: ${account.phone} activated successfully`);
        console.log(`   Token: ${token.substring(0, 20)}...`);
        return true;

    } catch (error) {
        // Check if the error message indicates success
        if (error.response?.data?.message === 'تم التحميل بنجاح' ||
            error.message?.includes('تم التحميل بنجاح')) {
            console.log(`✅ Account ${account.phone} is already activated!`);
            return true;
        }

        console.error(`❌ Error processing ${account.phone}:`, error.response?.data?.message || error.message);
        return false;
    }
}

// Process all accounts
async function activateAllAccounts() {
    const results = {
        successful: [],
        failed: []
    };

    for (const account of accounts) {
        console.log('\n' + '-'.repeat(50));

        const success = await activateAccount(account);

        if (success) {
            results.successful.push(account);
        } else {
            results.failed.push(account);
        }

        // Small delay to avoid overwhelming the server
        await new Promise(resolve => setTimeout(resolve, 1000));
    }

    console.log('\n' + '='.repeat(60));
    console.log('📊 ACTIVATION RESULTS SUMMARY');
    console.log('='.repeat(60));

    console.log(`✅ Successfully activated: ${results.successful.length} accounts`);
    console.log(`❌ Failed to activate: ${results.failed.length} accounts`);

    if (results.successful.length > 0) {
        console.log('\n🎉 SUCCESSFULLY ACTIVATED ACCOUNTS:');
        results.successful.forEach((acc, index) => {
            console.log(`   ${index + 1}. ${acc.phone} - ${acc.name}`);
        });
    }

    if (results.failed.length > 0) {
        console.log('\n❌ FAILED ACCOUNTS:');
        results.failed.forEach((acc, index) => {
            console.log(`   ${index + 1}. ${acc.phone} - ${acc.name} (${acc.status})`);
        });
    }

    console.log('\n' + '='.repeat(60));
    console.log('🏆 ACTIVATION PROCESS COMPLETED');
    console.log('='.repeat(60));

    // Save updated account status
    const updatedAccounts = accounts.map(acc => {
        const wasSuccessful = results.successful.some(s => s.phone === acc.phone);
        return {
            ...acc,
            status: wasSuccessful ? 'activated' : acc.status
        };
    });

    const output = updatedAccounts.map(acc =>
        `${acc.phone},${acc.name},${acc.email},${acc.status}`
    ).join('\n');

    fs.writeFileSync('new_demo_accounts_activated.txt', output);
    console.log('📄 Updated account status saved to: new_demo_accounts_activated.txt');
}

// Run the activation process
activateAllAccounts().catch(console.error);
