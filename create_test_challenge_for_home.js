const axios = require('axios');
const fs = require('fs');

const API_BASE_URL = 'https://pre-montada.gostcode.com/public/api';

// Read the team details
const teamsData = fs.readFileSync('new_teams_details.txt', 'utf8');

// Parse team data
const teams = [];
let currentTeam = null;

const lines = teamsData.split('\n');
for (let i = 0; i < lines.length; i++) {
    const line = lines[i].trim();

    if (line.startsWith('TEAM 1:') || line.startsWith('TEAM 2:')) {
        if (currentTeam) teams.push(currentTeam);
        currentTeam = {
            name: line.split(': ')[1],
            captain: null,
            subLeader: null,
            members: []
        };
    } else if (line.startsWith('Team ID:')) {
        if (currentTeam) currentTeam.id = line.split(': ')[1];
    } else if (line.startsWith('👑 CAPTAIN:')) {
        // Skip captain header
    } else if (line.startsWith('Phone:') && currentTeam && !currentTeam.captain) {
        const phoneMatch = line.match(/Phone: (\d+)/);
        if (phoneMatch) currentTeam.captain = phoneMatch[1];
    }
}

if (currentTeam) teams.push(currentTeam);

console.log('🎯 CREATING TEST CHALLENGE REQUEST');
console.log('==================================\n');

// Function to login and get token
async function loginAndGetToken(phone) {
    try {
        console.log(`🔐 Logging in with ${phone}...`);

        // Login request
        const loginResponse = await axios.post(`${API_BASE_URL}/login`, {
            mobile: phone
        });

        if (!loginResponse.data.status) {
            throw new Error('Login failed');
        }

        // Handle different response structures
        let verificationCode;
        if (loginResponse.data.data && loginResponse.data.data.code) {
            verificationCode = loginResponse.data.data.code;
        } else if (loginResponse.data.code) {
            verificationCode = loginResponse.data.code;
        } else {
            // If already logged in, try to use a default code
            verificationCode = 11111;
        }

        console.log(`✅ Got verification code: ${verificationCode}`);

        // Activate account
        const activateResponse = await axios.post(`${API_BASE_URL}/activate`, {
            mobile: phone,
            code: verificationCode
        });

        if (!activateResponse.data.status) {
            throw new Error('Activation failed');
        }

        const token = activateResponse.data.data.token;
        console.log(`✅ Login successful for ${phone}`);
        return token;

    } catch (error) {
        console.error(`❌ Login failed for ${phone}:`, error.response?.data || error.message);
        return null;
    }
}

// Function to send challenge request
async function sendChallengeRequest(fromTeamId, toTeamId, token) {
    try {
        console.log(`⚔️  Sending challenge from Team ${fromTeamId} to Team ${toTeamId}...`);

        const response = await axios.post(`${API_BASE_URL}/challenge/team-match-invites`, {
            team_id: toTeamId
        }, {
            headers: {
                'Authorization': `Bearer ${token}`,
                'Content-Type': 'application/json'
            }
        });

        console.log(`📡 Challenge response:`, response.data);
        return response.data;

    } catch (error) {
        console.error(`❌ Challenge request failed:`, error.response?.data || error.message);
        return null;
    }
}

// Main test function
async function createTestChallenge() {
    if (teams.length < 2) {
        console.error('❌ Need at least 2 teams for testing');
        return;
    }

    const team1 = teams[0];
    const team2 = teams[1];

    console.log(`🏆 Team 1: ${team1.name} (ID: ${team1.id})`);
    console.log(`🏆 Team 2: ${team2.name} (ID: ${team2.id})\n`);

    // Get captain token for Team 1
    const captain1Phone = team1.captain;

    console.log(`👑 Getting token for Team 1 Captain: ${captain1Phone}`);
    const token1 = await loginAndGetToken(captain1Phone);

    if (!token1) {
        console.error('❌ Failed to get token for Team 1 captain');
        return;
    }

    console.log('\n' + '='.repeat(50));
    console.log('⚔️  CREATING CHALLENGE REQUEST');
    console.log('='.repeat(50));

    // Send challenge from Team 1 to Team 2
    const challengeResult = await sendChallengeRequest(team1.id, team2.id, token1);

    if (challengeResult && challengeResult.status) {
        console.log(`✅ SUCCESS: Challenge request sent successfully!`);
        console.log(`   From Team: ${team1.name} (ID: ${team1.id})`);
        console.log(`   To Team: ${team2.name} (ID: ${team2.id})`);
        console.log(`   Status: ${challengeResult.message || 'Request sent'}`);
    } else {
        console.log(`❌ FAILED: Could not send challenge request`);
    }

    console.log('\n' + '='.repeat(50));
    console.log('🎉 CHALLENGE REQUEST CREATION COMPLETED');
    console.log('='.repeat(50));
    console.log('\n📱 Now you can check the home screen to see the challenge notification with badge counter!');
}

// Run the test
createTestChallenge().catch(console.error);
