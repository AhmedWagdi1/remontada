const axios = require('axios');

async function sendChallengeFromBetaToAlpha() {
    console.log('⚽ Sending Challenge from Demo Team Beta to Demo Team Alpha');
    console.log('==========================================================\n');

    try {
        // Authenticate Demo Team Beta captain
        console.log('🔐 Authenticating Demo Team Beta Captain (0536053159)...');

        const loginResponse = await axios.post('https://pre-montada.gostcode.com/public/api/login', {
            mobile: '0536053159'
        }, {
            maxRedirects: 5,
            validateStatus: function (status) {
                return status < 400;
            }
        });

        if (!loginResponse.data.data?.code) {
            console.log('❌ Login failed');
            return;
        }

        const activateResponse = await axios.post('https://pre-montada.gostcode.com/public/api/activate', {
            mobile: '0536053159',
            code: loginResponse.data.data.code,
            device_token: 'test_device_token',
            device_type: 'android',
            uuid: 'test_uuid'
        }, {
            maxRedirects: 5,
            validateStatus: function (status) {
                return status < 400;
            }
        });

        if (!activateResponse.data.data?.access_token) {
            console.log('❌ Activation failed');
            return;
        }

        const token = activateResponse.data.data.access_token;
        console.log('✅ Authentication successful');

        // Get playgrounds
        const playgroundsResponse = await axios.get('https://pre-montada.gostcode.com/public/api/playgrounds', {
            headers: {
                'Authorization': `Bearer ${token}`,
                'Accept': 'application/json'
            }
        });

        if (!playgroundsResponse.data.data?.playgrounds?.length) {
            console.log('❌ No playgrounds available');
            return;
        }

        const playground = playgroundsResponse.data.data.playgrounds[0];
        console.log(`📍 Using playground: ${playground.name} (ID: ${playground.id})`);

        // Send challenge from Demo Team Beta (ID: 43) to Demo Team Alpha (ID: 42)
        const challengeData = {
            playground_id: playground.id,
            date: '2025-09-15', // Future date
            start_time: '19:00:00',
            end_time: '20:00:00',
            durations: 60,
            amount: '100.00',
            subscribers_qty: 22,
            details: 'Friendly challenge match between demo teams',
            is_competitive: true,
            team1_id: 43, // Demo Team Beta (requester)
            team2_id: 42  // Demo Team Alpha (invited)
        };

        console.log('📋 Challenge details:');
        console.log(`   From: Demo Team Beta (ID: 43)`);
        console.log(`   To: Demo Team Alpha (ID: 42)`);
        console.log(`   Date: ${challengeData.date}`);
        console.log(`   Time: ${challengeData.start_time} - ${challengeData.end_time}`);
        console.log(`   Details: ${challengeData.details}`);

        const challengeResponse = await axios.post('https://pre-montada.gostcode.com/public/api/challenge/store', challengeData, {
            headers: {
                'Authorization': `Bearer ${token}`,
                'Content-Type': 'application/json',
                'Accept': 'application/json'
            }
        });

        console.log('\n📡 Challenge creation response:');
        console.log('Status:', challengeResponse.status);
        console.log('Data:', JSON.stringify(challengeResponse.data, null, 2));

        if (challengeResponse.data.status) {
            console.log('\n✅ SUCCESS: Challenge request sent!');
            console.log('🎯 Demo Team Alpha captain (0591010553) should now see this challenge request');
            console.log('📱 Test the /challenge/team-match-invites endpoint for the captain');
        } else {
            console.log('\n❌ FAILED: Could not send challenge request');
            console.log('Error:', challengeResponse.data.message);
        }

    } catch (error) {
        console.error('❌ Error:', error.response?.data?.message || error.message);
    }
}

sendChallengeFromBetaToAlpha();
