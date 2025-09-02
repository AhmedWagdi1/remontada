const axios = require('axios');
const fs = require('fs');
const FormData = require('form-data');

const API_BASE_URL = 'https://pre-montada.gostcode.com/public/api';

// Read the new demo accounts
const accountsData = fs.readFileSync('new_demo_accounts.txt', 'utf8');
const allAccounts = accountsData.split('\n')
  .filter(line => line.trim())
  .map(line => {
    const [phone, name, email, status] = line.split(',');
    return { phone, name, email, status };
  });

// Filter successful accounts
const successfulAccounts = allAccounts.filter(acc => acc.status === 'success');
console.log(`📋 Found ${successfulAccounts.length} successful accounts out of ${allAccounts.length} total`);

// Split into 2 teams (12-13 members each)
const team1Accounts = successfulAccounts.slice(0, 13);
const team2Accounts = successfulAccounts.slice(13, 25);

console.log(`\n🏆 Team 1: ${team1Accounts.length} members`);
console.log(`🏆 Team 2: ${team2Accounts.length} members`);

// Function to login and get token
async function login(phoneNumber) {
  try {
    console.log(`🔐 Logging in with ${phoneNumber}...`);

    const loginResponse = await axios.post(`${API_BASE_URL}/login`, {
      mobile: phoneNumber
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

    if (loginResponse.data && loginResponse.data.data && loginResponse.data.data.code) {
      const verificationCode = loginResponse.data.data.code;
      console.log(`✅ Got verification code: ${verificationCode}`);

      const verifyResponse = await axios.post(`${API_BASE_URL}/activate`, {
        mobile: phoneNumber,
        code: verificationCode,
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

      if (verifyResponse.data && verifyResponse.data.data && verifyResponse.data.data.access_token) {
        console.log(`✅ Login successful for ${phoneNumber}`);
        return verifyResponse.data.data.access_token;
      } else {
        console.log(`❌ Verification failed for ${phoneNumber}`);
        return null;
      }
    } else {
      console.log(`❌ Login failed for ${phoneNumber}`);
      return null;
    }
  } catch (error) {
    console.log(`❌ Login error for ${phoneNumber}: ${error.message}`);
    return null;
  }
}

// Function to create a team
async function createTeam(teamName, captainAccount, teamAccounts) {
  console.log(`\n🏆 Creating team: ${teamName}`);
  console.log('=====================================');

  // Login as captain
  const captainToken = await login(captainAccount.phone);
  if (!captainToken) {
    console.log(`❌ Cannot create team - captain login failed`);
    return null;
  }

  // Create team
  const form = new FormData();
  form.append('name', teamName);
  form.append('area_id', '1');
  form.append('bio', `New demo team: ${teamName}`);

  try {
    console.log(`📝 Creating team "${teamName}"...`);
    const createResponse = await axios.post(`${API_BASE_URL}/team/store`, form, {
      headers: {
        'Authorization': `Bearer ${captainToken}`,
        'Accept': 'application/json',
        ...form.getHeaders()
      },
      maxRedirects: 5,
      validateStatus: function (status) {
        return status >= 200 && status < 400;
      }
    });

    console.log(`📡 Team creation response:`, JSON.stringify(createResponse.data, null, 2));

    if (createResponse.data && createResponse.data.status === true) {
      const teamId = createResponse.data.data.id;
      console.log(`✅ Team "${teamName}" created with ID: ${teamId}`);

      // Add members to team
      await addMembersToTeam(teamId, captainToken, teamAccounts, captainAccount);

      return teamId;
    } else {
      console.log(`❌ Team creation failed: ${createResponse.data?.message}`);
      return null;
    }
  } catch (error) {
    console.log(`❌ Team creation error: ${error.message}`);
    return null;
  }
}

// Function to add members to team
async function addMembersToTeam(teamId, captainToken, teamAccounts, captainAccount) {
  console.log(`👥 Adding members to team ${teamId}...`);

  for (let i = 0; i < teamAccounts.length; i++) {
    const member = teamAccounts[i];
    if (member.phone === captainAccount.phone) continue; // Skip captain

    try {
      console.log(`➕ Adding ${member.name} (${member.phone})...`);

      const addResponse = await axios.post(`${API_BASE_URL}/team/add-member`, {
        team_id: teamId,
        phone_number: member.phone
      }, {
        headers: {
          'Authorization': `Bearer ${captainToken}`,
          'Content-Type': 'application/json',
          'Accept': 'application/json'
        },
        maxRedirects: 5,
        validateStatus: function (status) {
          return status >= 200 && status < 400;
        }
      });

      console.log(`📡 Add member response:`, JSON.stringify(addResponse.data, null, 2));

      if (addResponse.data && addResponse.data.status === true) {
        console.log(`✅ Added ${member.name} to team`);

        // Set role (sub-leader for first member, member for others)
        const role = i === 0 ? 'subLeader' : 'member';
        await setMemberRole(teamId, captainToken, member.phone, role);
      } else {
        console.log(`❌ Failed to add ${member.name}: ${addResponse.data?.message}`);
      }

      // Delay to avoid rate limiting
      await new Promise(resolve => setTimeout(resolve, 1000));

    } catch (error) {
      console.log(`❌ Error adding ${member.name}: ${error.message}`);
    }
  }
}

// Function to set member role
async function setMemberRole(teamId, captainToken, memberPhone, role) {
  try {
    console.log(`👑 Setting role "${role}" for ${memberPhone}...`);

    const roleResponse = await axios.post(`${API_BASE_URL}/team/member-role`, {
      team_id: teamId,
      phone_number: memberPhone,
      role: role
    }, {
      headers: {
        'Authorization': `Bearer ${captainToken}`,
        'Content-Type': 'application/json',
        'Accept': 'application/json'
      },
      maxRedirects: 5,
      validateStatus: function (status) {
        return status >= 200 && status < 400;
      }
    });

    console.log(`📡 Role response:`, JSON.stringify(roleResponse.data, null, 2));

    if (roleResponse.data && roleResponse.data.status === true) {
      console.log(`✅ Role "${role}" set successfully`);
    } else {
      console.log(`❌ Failed to set role: ${roleResponse.data?.message}`);
    }
  } catch (error) {
    console.log(`❌ Error setting role: ${error.message}`);
  }
}

// Create teams
async function createNewTeams() {
  console.log('🏆 CREATING NEW DEMO TEAMS');
  console.log('==========================\n');

  const teams = [
    {
      name: `Test Team Alpha ${Date.now()}`,
      accounts: team1Accounts,
      captain: team1Accounts[0],
      subLeader: team1Accounts[1],
      members: team1Accounts.slice(2)
    },
    {
      name: `Test Team Beta ${Date.now() + 1}`,
      accounts: team2Accounts,
      captain: team2Accounts[0],
      subLeader: team2Accounts[1],
      members: team2Accounts.slice(2)
    }
  ];

  const createdTeams = [];

  for (const team of teams) {
    const teamId = await createTeam(team.name, team.captain, team.accounts);
    if (teamId) {
      createdTeams.push({
        id: teamId,
        name: team.name,
        captain: team.captain,
        subLeader: team.subLeader,
        members: team.members
      });
    }

    // Delay between team creation
    await new Promise(resolve => setTimeout(resolve, 2000));
  }

  // Generate documentation
  generateTeamDocumentation(createdTeams);

  return createdTeams;
}

// Generate team documentation
function generateTeamDocumentation(teams) {
  let doc = '🏆 NEW DEMO TEAMS CREATION REPORT\n';
  doc += '==================================\n\n';

  teams.forEach((team, index) => {
    doc += `TEAM ${index + 1}: ${team.name}\n`;
    doc += `Team ID: ${team.id}\n`;
    doc += `Total Members: ${team.members.length + 2}\n\n`; // +2 for captain and sub-leader

    doc += `👑 CAPTAIN:\n`;
    doc += `   Phone: ${team.captain.phone}\n`;
    doc += `   Name: ${team.captain.name}\n`;
    doc += `   Email: ${team.captain.email}\n\n`;

    doc += `🤝 SUB-LEADER:\n`;
    doc += `   Phone: ${team.subLeader.phone}\n`;
    doc += `   Name: ${team.subLeader.name}\n`;
    doc += `   Email: ${team.subLeader.email}\n\n`;

    doc += `👥 MEMBERS (${team.members.length}):\n`;
    team.members.forEach((member, i) => {
      doc += `   ${i + 1}. Phone: ${member.phone} | Name: ${member.name} | Email: ${member.email}\n`;
    });

    doc += '\n--------------------------------------------------\n\n';
  });

  fs.writeFileSync('new_teams_details.txt', doc);
  console.log('\n📄 Team documentation saved to: new_teams_details.txt');
}

// Run team creation
createNewTeams().catch(console.error);
