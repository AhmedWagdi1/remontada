const axios = require('axios');
const fs = require('fs');

// Configuration
const API_BASE_URL = 'https://api.remontada.com/api';

// Read created accounts
let accounts = [];
try {
    const data = fs.readFileSync('created_accounts.txt', 'utf8');
    accounts = data.split('\n').filter(line => line.trim()).map(line => {
        const [phone, password] = line.split(':');
        return { phone, password };
    });
} catch (error) {
    console.error('❌ Error reading created_accounts.txt:', error.message);
    process.exit(1);
}

// Test team details and challenge requests visibility
async function testCaptainChallengeRequests() {
    console.log('🏆 Testing Captain Challenge Requests Visibility');
    console.log('================================================\n');

    // Test Demo Team Alpha Captain (0591010553)
    const alphaCaptain = accounts.find(acc => acc.phone === '0591010553');
    if (alphaCaptain) {
        console.log('🧪 Testing Demo Team Alpha Captain (0591010553)');
        console.log('------------------------------------------------');

        try {
            // Login
            const loginResponse = await axios.post(`${API_BASE_URL}/login`, {
                mobile: alphaCaptain.phone,
                password: alphaCaptain.password,
                device_token: 'test_device_token',
                device_type: 'android',
                uuid: 'test_uuid'
            });

            if (loginResponse.data.status) {
                const token = loginResponse.data.data.token;
                console.log('✅ Login successful');

                // Get team details for team ID 42 (Demo Team Alpha)
                const teamResponse = await axios.get(`${API_BASE_URL}/team/show/42`, {
                    headers: {
                        'Authorization': `Bearer ${token}`,
                        'Accept': 'application/json'
                    }
                });

                if (teamResponse.data.status) {
                    const teamData = teamResponse.data.data;
                    const users = teamData.users || [];

                    // Find current user role
                    const currentUser = users.find(user => user.mobile === alphaCaptain.phone);
                    const userRole = currentUser ? currentUser.role : null;

                    console.log(`👤 User Role: ${userRole}`);
                    console.log(`📊 Team Members: ${users.length}`);

                    // Check if user should see challenge requests section
                    const shouldSeeRequests = userRole === 'leader';
                    console.log(`👁️  Should see challenge requests: ${shouldSeeRequests ? 'YES' : 'NO'}`);

                    if (shouldSeeRequests) {
                        // Get challenge invites
                        const invitesResponse = await axios.get(`${API_BASE_URL}/challenge/team-match-invites`, {
                            headers: {
                                'Authorization': `Bearer ${token}`,
                                'Accept': 'application/json'
                            }
                        });

                        if (invitesResponse.data.status) {
                            const allInvites = invitesResponse.data.data;
                            const teamInvites = allInvites.filter(invite =>
                                invite.invited_team_id == 42 && invite.status !== 'accepted'
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
                            }
                        }
                    }
                }
            }
        } catch (error) {
            console.error('❌ Error:', error.response?.data?.message || error.message);
        }

        console.log('\n');
    }

    // Test Demo Team Beta Captain (0536053159)
    const betaCaptain = accounts.find(acc => acc.phone === '0536053159');
    if (betaCaptain) {
        console.log('🧪 Testing Demo Team Beta Captain (0536053159)');
        console.log('-------------------------------------------------');

        try {
            // Login
            const loginResponse = await axios.post(`${API_BASE_URL}/login`, {
                mobile: betaCaptain.phone,
                password: betaCaptain.password,
                device_token: 'test_device_token',
                device_type: 'android',
                uuid: 'test_uuid'
            });

            if (loginResponse.data.status) {
                const token = loginResponse.data.data.token;
                console.log('✅ Login successful');

                // Get team details for team ID 43 (Demo Team Beta)
                const teamResponse = await axios.get(`${API_BASE_URL}/team/show/43`, {
                    headers: {
                        'Authorization': `Bearer ${token}`,
                        'Accept': 'application/json'
                    }
                });

                if (teamResponse.data.status) {
                    const teamData = teamResponse.data.data;
                    const users = teamData.users || [];

                    // Find current user role
                    const currentUser = users.find(user => user.mobile === betaCaptain.phone);
                    const userRole = currentUser ? currentUser.role : null;

                    console.log(`👤 User Role: ${userRole}`);
                    console.log(`📊 Team Members: ${users.length}`);

                    // Check if user should see challenge requests section
                    const shouldSeeRequests = userRole === 'leader';
                    console.log(`👁️  Should see challenge requests: ${shouldSeeRequests ? 'YES' : 'NO'}`);

                    if (shouldSeeRequests) {
                        // Get challenge invites
                        const invitesResponse = await axios.get(`${API_BASE_URL}/challenge/team-match-invites`, {
                            headers: {
                                'Authorization': `Bearer ${token}`,
                                'Accept': 'application/json'
                            }
                        });

                        if (invitesResponse.data.status) {
                            const allInvites = invitesResponse.data.data;
                            const teamInvites = allInvites.filter(invite =>
                                invite.invited_team_id == 43 && invite.status !== 'accepted'
                            );

                            console.log(`📬 Pending challenge invites: ${teamInvites.length}`);

                            if (teamInvites.length > 0) {
                                console.log('✅ Captain should see challenge requests section in app');
                            } else {
                                console.log('⚠️  No pending invites - captain won\'t see requests section');
                            }
                        }
                    }
                }
            }
        } catch (error) {
            console.error('❌ Error:', error.response?.data?.message || error.message);
        }
    }
}

// Run the test
testCaptainChallengeRequests().catch(console.error);
