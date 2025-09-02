const axios = require('axios');

async function createTestChallenge() {
    console.log('⚽ Creating Test Challenge Request');
    console.log('==================================\n');

    // Use Demo Team Alpha Captain to send challenge to Demo Team Beta
    const challenger = {
        phone: '0591010553',
        teamId: 42,
        teamName: 'Demo Team Alpha'
    };

    const opponent = {
        teamId: 43,
        teamName: 'Demo Team Beta'
    };

    try {
        // Login and activate challenger
        console.log(`🔐 Authenticating ${challenger.teamName} Captain...`);
        const loginResponse = await axios.post('https://pre-montada.gostcode.com/public/api/login', {
            mobile: challenger.phone
        }, {
            headers: {
                'Content-Type': 'application/json',
                'Accept': 'application/json'
            },
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
            mobile: challenger.phone,
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

        // Create a challenge request
        console.log(`\n⚽ Sending challenge from ${challenger.teamName} to ${opponent.teamName}...`);

        // First, let's check what playgrounds are available
        const playgroundsResponse = await axios.get('https://pre-montada.gostcode.com/public/api/playgrounds', {
            headers: {
                'Authorization': `Bearer ${token}`,
                'Accept': 'application/json'
            }
        });

        console.log('Playgrounds response status:', playgroundsResponse.status);
        console.log('Playgrounds response data:', JSON.stringify(playgroundsResponse.data, null, 2));

        if (!playgroundsResponse.data.status || !playgroundsResponse.data.data?.playgrounds?.length) {
            console.log('❌ No playgrounds available - trying alternative endpoint');

            // Try without authorization
            const publicPlaygroundsResponse = await axios.get('https://pre-montada.gostcode.com/public/api/playgrounds');
            console.log('Public playgrounds response status:', publicPlaygroundsResponse.status);
            console.log('Public playgrounds response data:', JSON.stringify(publicPlaygroundsResponse.data, null, 2));

            if (!publicPlaygroundsResponse.data.status || !publicPlaygroundsResponse.data.data?.playgrounds?.length) {
                console.log('❌ No playgrounds available from public endpoint either');
                return;
            }

            var playground = publicPlaygroundsResponse.data.data.playgrounds[0];
            console.log(`📍 Using playground from public endpoint: ${playground.name} (ID: ${playground.id})`);
        } else {
            var playground = playgroundsResponse.data.data.playgrounds[0];
            console.log(`📍 Using playground: ${playground.name} (ID: ${playground.id})`);
        }

        // Create challenge match
        const challengeData = {
            playground_id: playground.id,
            date: '2025-10-25', // Future date
            start_time: '18:00:00',
            end_time: '19:00:00',
            durations: 60,
            amount: '50.00',
            subscribers_qty: 22,
            details: 'Test challenge match between demo teams',
            is_competitive: true,
            team1_id: challenger.teamId,
            team2_id: opponent.teamId,
            type: 'challenge'
        };

        console.log('📋 Challenge details:', challengeData);

        const challengeResponse = await axios.post('https://pre-montada.gostcode.com/public/api/matches/store', challengeData, {
            headers: {
                'Authorization': `Bearer ${token}`,
                'Content-Type': 'application/json',
                'Accept': 'application/json'
            }
        });

        console.log('Challenge creation response status:', challengeResponse.status);
        console.log('Challenge creation response:', JSON.stringify(challengeResponse.data, null, 2));

        if (challengeResponse.data.status) {
            console.log('✅ Challenge request created successfully!');
            console.log('\n🎯 Now the Demo Team Beta captain should see this challenge request in their app.');
            console.log('📱 Check the team details page for Demo Team Beta - the challenge requests section should now be visible.');
        } else {
            console.log('❌ Failed to create challenge request');
        }

    } catch (error) {
        console.error('❌ Error:', error.response?.data?.message || error.message);
    }
}

createTestChallenge();
