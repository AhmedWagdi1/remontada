const axios = require('axios');
const fs = require('fs');

async function testCaptain() {
    try {
        // Read accounts
        const data = fs.readFileSync('created_accounts.txt', 'utf8');
        const accounts = data.split('\n').filter(line => line.trim()).map(line => {
            const [phone, password] = line.split(':');
            return { phone, password };
        });

        const captain = accounts.find(acc => acc.phone === '0591010553');
        if (!captain) {
            console.log('Captain account not found');
            return;
        }

        console.log('Testing Demo Team Alpha Captain:', captain.phone);

        // Login
        const loginResponse = await axios.post('https://api.remontada.com/api/login', {
            mobile: captain.phone,
            password: captain.password,
            device_token: 'test_device_token',
            device_type: 'android',
            uuid: 'test_uuid'
        });

        if (!loginResponse.data.status) {
            console.log('Login failed');
            return;
        }

        const token = loginResponse.data.data.token;
        console.log('✅ Login successful');

        // Get team details
        const teamResponse = await axios.get('https://api.remontada.com/api/team/show/42', {
            headers: {
                'Authorization': `Bearer ${token}`,
                'Accept': 'application/json'
            }
        });

        if (!teamResponse.data.status) {
            console.log('Failed to get team details');
            return;
        }

        const teamData = teamResponse.data.data;
        const users = teamData.users || [];

        // Find current user role
        const currentUser = users.find(user => user.mobile === captain.phone);
        const userRole = currentUser ? currentUser.role : null;

        console.log(`👤 User Role: ${userRole}`);
        console.log(`📊 Team Members: ${users.length}`);

        // Check if should see challenge requests
        const shouldSeeRequests = userRole === 'leader';
        console.log(`👁️ Should see challenge requests: ${shouldSeeRequests ? 'YES' : 'NO'}`);

        if (shouldSeeRequests) {
            // Get challenge invites
            const invitesResponse = await axios.get('https://api.remontada.com/api/challenge/team-match-invites', {
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
                } else {
                    console.log('⚠️ No pending invites - captain won\'t see requests section');
                }
            }
        }

    } catch (error) {
        console.error('❌ Error:', error.response?.data?.message || error.message);
    }
}

testCaptain();
