const axios = require('axios');

async function testCaptainChallengeRequests() {
    console.log('🏆 Testing Captain Challenge Requests Visibility');
    console.log('================================================\n');

    // Test Demo Team Alpha Captain
    const alphaCaptain = {
        phone: '0591010553',
        password: 'DemoPass123!',
        teamId: 42,
        teamName: 'Demo Team Alpha'
    };

    console.log(`🧪 Testing ${alphaCaptain.teamName} Captain (${alphaCaptain.phone})`);
    console.log('------------------------------------------------------------');

    try {
        // Login first (only send mobile, no password)
        const loginResponse = await axios.post('https://pre-montada.gostcode.com/public/api/login', {
            mobile: alphaCaptain.phone
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

        console.log('Login response status:', loginResponse.status);
        console.log('Login response data:', JSON.stringify(loginResponse.data, null, 2));

        if (!loginResponse.data.data?.code) {
            console.log('❌ Login failed - no verification code received');
            return;
        }

        // Now activate with OTP code to get the token
        const activateResponse = await axios.post('https://pre-montada.gostcode.com/public/api/activate', {
            mobile: alphaCaptain.phone,
            code: loginResponse.data.data.code, // Use the actual code from login
            device_token: 'test_device_token',
            device_type: 'android',
            uuid: 'test_uuid'
        }, {
            maxRedirects: 5,
            validateStatus: function (status) {
                return status < 400;
            }
        });

        console.log('Activate response status:', activateResponse.status);
        console.log('Activate response data:', JSON.stringify(activateResponse.data, null, 2));

        if (!activateResponse.data.data?.access_token) {
            console.log('❌ Activation failed - no access token received');
            return;
        }

        const token = activateResponse.data.data.access_token;
        console.log('✅ Activation successful, got access token');

        // First test: Check if we can access user profile
        console.log('\n🔍 Testing user profile access...');
        const profileResponse = await axios.get('https://pre-montada.gostcode.com/public/api/profile', {
            headers: {
                'Authorization': `Bearer ${token}`,
                'Accept': 'application/json'
            }
        });

        console.log('Profile response status:', profileResponse.status);
        console.log('Profile response data:', JSON.stringify(profileResponse.data, null, 2));

        // Get team details
        console.log('\n🔍 Testing team details access...');
        const teamResponse = await axios.get(`https://pre-montada.gostcode.com/public/api/team/show/${alphaCaptain.teamId}`, {
            headers: {
                'Authorization': `Bearer ${token}`,
                'Accept': 'application/json'
            }
        });

        console.log('Team details response status:', teamResponse.status);
        console.log('Team details response data:', JSON.stringify(teamResponse.data, null, 2));

        if (!teamResponse.data.status) {
            console.log('❌ Failed to get team details');
            return;
        }

        const teamData = teamResponse.data.data;
        const users = teamData.users || [];

        // Find current user role
        const currentUser = users.find(user => user.mobile === alphaCaptain.phone);
        const userRole = currentUser ? currentUser.role : null;

        console.log(`👤 User Role: ${userRole}`);
        console.log(`📊 Team Members: ${users.length}`);

        // Check if should see challenge requests
        const shouldSeeRequests = userRole === 'leader';
        console.log(`👁️  Should see challenge requests: ${shouldSeeRequests ? 'YES' : 'NO'}`);

        if (shouldSeeRequests) {
            // Get challenge invites
            const invitesResponse = await axios.get('https://pre-montada.gostcode.com/public/api/challenge/team-match-invites', {
                headers: {
                    'Authorization': `Bearer ${token}`,
                    'Accept': 'application/json'
                }
            });

            if (invitesResponse.data.status) {
                const allInvites = invitesResponse.data.data;
                const teamInvites = allInvites.filter(invite =>
                    invite.invited_team_id == alphaCaptain.teamId && invite.status !== 'accepted'
                );

                console.log(`📬 Pending challenge invites: ${teamInvites.length}`);

                if (teamInvites.length > 0) {
                    console.log('✅ Captain should see challenge requests section in app');
                    teamInvites.forEach((invite, index) => {
                        console.log(`   ${index + 1}. From: ${invite.requester_team.name}`);
                        console.log(`      Match: ${invite.match.date} at ${invite.match.start_time}`);
                        console.log(`      Status: ${invite.status}`);
                    });
                } else {
                    console.log('⚠️  No pending invites - captain won\'t see requests section');
                    console.log('\n💡 To test challenge requests visibility:');
                    console.log('   1. Have another team send a challenge request to this team');
                    console.log('   2. Or create a test challenge from another account');
                }
            }
        } else {
            console.log('❌ User is not a team leader - won\'t see challenge requests section');
        }

    } catch (error) {
        console.error('❌ Error:', error.response?.data?.message || error.message);
    }

    console.log('\n' + '='.repeat(60) + '\n');

    // Test Demo Team Beta Captain
    const betaCaptain = {
        phone: '0536053159',
        password: 'DemoPass123!',
        teamId: 43,
        teamName: 'Demo Team Beta'
    };

    console.log(`🧪 Testing ${betaCaptain.teamName} Captain (${betaCaptain.phone})`);
    console.log('-----------------------------------------------------------');

    try {
        // Login first (only send mobile, no password)
        const loginResponse = await axios.post('https://pre-montada.gostcode.com/public/api/login', {
            mobile: betaCaptain.phone
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

        console.log('Login response status:', loginResponse.status);
        console.log('Login response data:', JSON.stringify(loginResponse.data, null, 2));

        if (!loginResponse.data.data?.code) {
            console.log('❌ Login failed - no verification code received');
            return;
        }

        // Now activate with OTP code to get the token
        const activateResponse = await axios.post('https://pre-montada.gostcode.com/public/api/activate', {
            mobile: betaCaptain.phone,
            code: loginResponse.data.data.code, // Use the actual code from login
            device_token: 'test_device_token',
            device_type: 'android',
            uuid: 'test_uuid'
        }, {
            maxRedirects: 5,
            validateStatus: function (status) {
                return status < 400;
            }
        });

        console.log('Activate response status:', activateResponse.status);
        console.log('Activate response data:', JSON.stringify(activateResponse.data, null, 2));

        if (!activateResponse.data.data?.access_token) {
            console.log('❌ Activation failed - no access token received');
            return;
        }

        const token = activateResponse.data.data.access_token;
        console.log('✅ Activation successful, got access token');

        // Get team details
        const teamResponse = await axios.get(`https://pre-montada.gostcode.com/public/api/team/show/${betaCaptain.teamId}`, {
            headers: {
                'Authorization': `Bearer ${token}`,
                'Accept': 'application/json'
            }
        });

        console.log('Team details response status:', teamResponse.status);
        console.log('Team details response data:', JSON.stringify(teamResponse.data, null, 2));

        if (!teamResponse.data.status) {
            console.log('❌ Failed to get team details');
            return;
        }

        const teamData = teamResponse.data.data;
        const users = teamData.users || [];

        // Find current user role
        const currentUser = users.find(user => user.mobile === betaCaptain.phone);
        const userRole = currentUser ? currentUser.role : null;

        console.log(`👤 User Role: ${userRole}`);
        console.log(`📊 Team Members: ${users.length}`);

        // Check if should see challenge requests
        const shouldSeeRequests = userRole === 'leader';
        console.log(`👁️  Should see challenge requests: ${shouldSeeRequests ? 'YES' : 'NO'}`);

        if (shouldSeeRequests) {
            // Get challenge invites
            const invitesResponse = await axios.get('https://pre-montada.gostcode.com/public/api/challenge/team-match-invites', {
                headers: {
                    'Authorization': `Bearer ${token}`,
                    'Accept': 'application/json'
                }
            });

            if (invitesResponse.data.status) {
                const allInvites = invitesResponse.data.data;
                const teamInvites = allInvites.filter(invite =>
                    invite.invited_team_id == betaCaptain.teamId && invite.status !== 'accepted'
                );

                console.log(`📬 Pending challenge invites: ${teamInvites.length}`);

                if (teamInvites.length > 0) {
                    console.log('✅ Captain should see challenge requests section in app');
                } else {
                    console.log('⚠️  No pending invites - captain won\'t see requests section');
                }
            }
        } else {
            console.log('❌ User is not a team leader - won\'t see challenge requests section');
        }

    } catch (error) {
        console.error('❌ Error:', error.response?.data?.message || error.message);
    }
}

testCaptainChallengeRequests();
