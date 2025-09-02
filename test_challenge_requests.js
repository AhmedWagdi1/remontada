const axios = require('axios');
const fs = require('fs');

const API_BASE_URL = 'https://pre-montada.gostcode.com/public/api';

// Read the team details
const teamsData = fs.readFileSync('new_teams_details.txt', 'utf8');
const accountsData = fs.readFileSync('new_demo_accounts.txt', 'utf8');

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
    } else if (line.startsWith('🤝 SUB-LEADER:')) {
        // Skip sub-leader header
    } else if (line.startsWith('Phone:') && currentTeam && !currentTeam.subLeader) {
        const phoneMatch = line.match(/Phone: (\d+)/);
        if (phoneMatch) currentTeam.subLeader = phoneMatch[1];
    }
}

if (currentTeam) teams.push(currentTeam);

// Parse accounts data to get tokens
const accounts = [];
const accountLines = accountsData.split('\n');
for (const line of accountLines) {
    if (line.includes('|')) {
        const parts = line.split('|').map(p => p.trim());
        if (parts.length >= 4) {
            accounts.push({
                phone: parts[0],
                name: parts[1],
                email: parts[2],
                status: parts[3]
            });
        }
    }
}

console.log('🎯 TESTING CHALLENGE REQUEST FUNCTIONALITY');
console.log('==========================================\n');

// Function to login and get token
async function loginAndGetToken(phone) {
    try {
        console.log(`🔐 Logging in with ${phone}...`);

        // Login request
        const loginResponse = await axios.post(`${API_BASE_URL}/login`, {
            phone_number: phone
        });

        if (!loginResponse.data.status) {
            throw new Error('Login failed');
        }

        const verificationCode = loginResponse.data.data.code;
        console.log(`✅ Got verification code: ${verificationCode}`);

        // Activate account
        const activateResponse = await axios.post(`${API_BASE_URL}/activate`, {
            phone_number: phone,
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

// Function to check challenge requests for a team
async function checkChallengeRequests(teamId, token) {
    try {
        console.log(`🔍 Checking challenge requests for Team ${teamId}...`);

        const response = await axios.get(`${API_BASE_URL}/challenge/team-match-invites`, {
            headers: {
                'Authorization': `Bearer ${token}`,
                'Content-Type': 'application/json'
            }
        });

        console.log(`📡 Challenge requests response:`, JSON.stringify(response.data, null, 2));
        return response.data;

    } catch (error) {
        console.error(`❌ Failed to check challenge requests:`, error.response?.data || error.message);
        return null;
    }
}

// Main test function
async function testChallengeFunctionality() {
    if (teams.length < 2) {
        console.error('❌ Need at least 2 teams for testing');
        return;
    }

    const team1 = teams[0];
    const team2 = teams[1];

    console.log(`🏆 Team 1: ${team1.name} (ID: ${team1.id})`);
    console.log(`🏆 Team 2: ${team2.name} (ID: ${team2.id})\n`);

    // Get captain tokens
    const captain1Phone = team1.captain;
    const captain2Phone = team2.captain;

    console.log(`👑 Getting token for Team 1 Captain: ${captain1Phone}`);
    const token1 = await loginAndGetToken(captain1Phone);

    if (!token1) {
        console.error('❌ Failed to get token for Team 1 captain');
        return;
    }

    console.log(`👑 Getting token for Team 2 Captain: ${captain2Phone}`);
    const token2 = await loginAndGetToken(captain2Phone);

    if (!token2) {
        console.error('❌ Failed to get token for Team 2 captain');
        return;
    }

    console.log('\n' + '='.repeat(50));
    console.log('⚔️  PHASE 1: SEND CHALLENGE REQUEST');
    console.log('='.repeat(50));

    // Send challenge from Team 1 to Team 2
    const challengeResult = await sendChallengeRequest(team1.id, team2.id, token1);

    if (!challengeResult || !challengeResult.status) {
        console.error('❌ Failed to send challenge request');
        return;
    }

    console.log('\n' + '='.repeat(50));
    console.log('🔍 PHASE 2: CHECK CHALLENGE REQUESTS');
    console.log('='.repeat(50));

    // Check if Team 2 captain can see the challenge request
    console.log(`\n👀 Checking if Team 2 Captain can see the challenge request...`);
    const requestsForTeam2 = await checkChallengeRequests(team2.id, token2);

    if (requestsForTeam2 && requestsForTeam2.status && requestsForTeam2.data) {
        console.log(`✅ SUCCESS: Team 2 Captain can see ${requestsForTeam2.data.length} challenge request(s)`);

        // Check if our challenge is in the list
        const ourChallenge = requestsForTeam2.data.find(req =>
            req.from_team_id == team1.id && req.to_team_id == team2.id
        );

        if (ourChallenge) {
            console.log(`🎯 FOUND: Challenge from Team ${team1.name} to Team ${team2.name}`);
            console.log(`   Challenge ID: ${ourChallenge.id}`);
            console.log(`   Status: ${ourChallenge.status}`);
            console.log(`   Created: ${ourChallenge.created_at}`);
        } else {
            console.log(`⚠️  WARNING: Challenge request sent but not found in Team 2's requests`);
        }
    } else {
        console.log(`❌ FAILED: Team 2 Captain cannot see challenge requests`);
    }

    // Also check Team 1's sent challenges
    console.log(`\n📤 Checking Team 1's sent challenge requests...`);
    const sentRequests = await checkChallengeRequests(team1.id, token1);

    if (sentRequests && sentRequests.status && sentRequests.data) {
        console.log(`✅ Team 1 has ${sentRequests.data.length} sent challenge request(s)`);

        const ourSentChallenge = sentRequests.data.find(req =>
            req.from_team_id == team1.id && req.to_team_id == team2.id
        );

        if (ourSentChallenge) {
            console.log(`📤 CONFIRMED: Challenge sent successfully`);
        }
    }

    console.log('\n' + '='.repeat(50));
    console.log('🎉 CHALLENGE REQUEST TEST COMPLETED');
    console.log('='.repeat(50));
}

// Run the test
testChallengeFunctionality().catch(console.error);
