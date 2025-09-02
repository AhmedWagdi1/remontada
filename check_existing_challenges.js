const axios = require('axios');

async function checkExistingChallenges() {
    console.log('🔍 Checking for Existing Challenge Requests');
    console.log('==========================================\n');

    try {
        // Authenticate Demo Team Alpha captain
        console.log('🔐 Authenticating Demo Team Alpha Captain (0591010553)...');

        const loginResponse = await axios.post('https://pre-montada.gostcode.com/public/api/login', {
            mobile: '0591010553'
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
            mobile: '0591010553',
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

        // Check all matches
        console.log('\n📋 Checking all matches...');
        const matchesResponse = await axios.get('https://pre-montada.gostcode.com/public/api/matches', {
            headers: {
                'Authorization': `Bearer ${token}`,
                'Accept': 'application/json'
            }
        });

        console.log('Matches response status:', matchesResponse.status);

        if (matchesResponse.data.status && matchesResponse.data.data?.data) {
            const matches = matchesResponse.data.data.data;
            console.log(`\n📊 Total matches found: ${matches.length}`);

            const challenges = matches.filter(match => match.type === 'challenge');
            console.log(`🎯 Challenge matches: ${challenges.length}`);

            if (challenges.length > 0) {
                challenges.forEach((challenge, i) => {
                    console.log(`\n⚽ Challenge ${i + 1}:`);
                    console.log(`   Match ID: ${challenge.id}`);
                    console.log(`   Team 1: ${challenge.team1?.name || 'Unknown'} (ID: ${challenge.team1_id})`);
                    console.log(`   Team 2: ${challenge.team2?.name || 'Unknown'} (ID: ${challenge.team2_id})`);
                    console.log(`   Status: ${challenge.status}`);
                    console.log(`   Date: ${challenge.date} ${challenge.start_time}`);
                    console.log(`   Details: ${challenge.details}`);
                });
            } else {
                console.log('\n⚠️ No challenge matches found');
            }
        } else {
            console.log('❌ Failed to fetch matches or no matches data');
        }

        // Also check challenge invites again
        console.log('\n📋 Checking challenge invites endpoint...');
        const invitesResponse = await axios.get('https://pre-montada.gostcode.com/public/api/challenge/team-match-invites', {
            headers: {
                'Authorization': `Bearer ${token}`,
                'Accept': 'application/json'
            }
        });

        if (invitesResponse.data.status) {
            const invites = invitesResponse.data.data || [];
            console.log(`📬 Challenge invites: ${invites.length}`);

            invites.forEach((invite, i) => {
                console.log(`\n📨 Invite ${i + 1}:`);
                console.log(`   From: ${invite.requester_team?.name} (ID: ${invite.requester_team_id})`);
                console.log(`   To: ${invite.invited_team?.name} (ID: ${invite.invited_team_id})`);
                console.log(`   Status: ${invite.status}`);
                console.log(`   Match: ${invite.match?.date} ${invite.match?.start_time}`);
            });
        }

    } catch (error) {
        console.error('❌ Error:', error.response?.data?.message || error.message);
    }
}

checkExistingChallenges();
