const axios = require('axios');
const fs = require('fs');

const API_BASE_URL = 'https://pre-montada.gostcode.com/public/api';

// Test the challenge invites endpoint
async function testChallengeInvites(captainPhone, captainName) {
  console.log(`🧪 Testing /challenge/team-match-invites for ${captainName} (${captainPhone})...\n`);

  try {
    // Step 1: Login
    const loginResponse = await axios.post(`${API_BASE_URL}/login`, {
      mobile: captainPhone
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

    if (!loginResponse.data.data?.code) {
      console.log('❌ Login failed - no verification code received');
      return;
    }

    // Step 2: Activate account
    const verifyResponse = await axios.post(`${API_BASE_URL}/activate`, {
      mobile: captainPhone,
      code: '11111',
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

    if (!verifyResponse.data.data?.access_token) {
      console.log('❌ Activation failed - no access token received');
      return;
    }

    const token = verifyResponse.data.data.access_token;
    console.log('✅ Login successful, got access token');

    // Step 3: Test the challenge invites endpoint
    console.log('\n📋 Testing /challenge/team-match-invites endpoint...');

    const invitesResponse = await axios.get(`${API_BASE_URL}/challenge/team-match-invites`, {
      headers: {
        'Accept': 'application/json',
        'Authorization': `Bearer ${token}`
      },
      maxRedirects: 5,
      validateStatus: function (status) {
        return status >= 200 && status < 400;
      }
    });

    console.log(`📡 Response status: ${invitesResponse.status}`);
    console.log(`📡 Response data:`, JSON.stringify(invitesResponse.data, null, 2));

    if (invitesResponse.data.status === true) {
      const invites = invitesResponse.data.data || [];
      console.log(`\n✅ Successfully fetched ${invites.length} challenge invites`);

      if (invites.length > 0) {
        console.log('\n📋 Challenge Invites Details:');
        invites.forEach((invite, index) => {
          console.log(`\n${index + 1}. Invite ID: ${invite.id}`);
          console.log(`   Match ID: ${invite.match_id}`);
          console.log(`   Requester Team: ${invite.requester_team?.name} (ID: ${invite.requester_team_id})`);
          console.log(`   Invited Team: ${invite.invited_team?.name} (ID: ${invite.invited_team_id})`);
          console.log(`   Status: ${invite.status}`);
          console.log(`   Initiated By: ${invite.initiated_by}`);
          console.log(`   Match Date: ${invite.match?.date}`);
          console.log(`   Match Time: ${invite.match?.start_time}`);
          console.log(`   Match Details: ${invite.match?.details}`);
        });
      } else {
        console.log('\n📭 No challenge invites found');
        console.log('\n💡 This could mean:');
        console.log('   - No teams have sent challenge requests to this team yet');
        console.log('   - All existing requests have been accepted/rejected');
        console.log('   - The team might not be properly set up');
      }
    } else {
      console.log('❌ Failed to fetch challenge invites');
      console.log(`   Error: ${invitesResponse.data.message}`);
    }

  } catch (error) {
    console.log(`❌ Error testing challenge invites: ${error.message}`);
    if (error.response) {
      console.log(`📡 Error response status: ${error.response.status}`);
      console.log(`📡 Error response data:`, JSON.stringify(error.response.data, null, 2));
    }
  }
}

// Test with both captains
async function main() {
  const captains = [
    { name: 'Demo Team Alpha Captain', phone: '0591010553' },
    { name: 'Demo Team Beta Captain', phone: '0536053159' }
  ];

  for (const captain of captains) {
    console.log(`\n🏆 Testing ${captain.name} (${captain.phone})`);
    console.log('='.repeat(60));

    await testChallengeInvites(captain.phone, captain.name);
  }
}

main().catch(console.error);
