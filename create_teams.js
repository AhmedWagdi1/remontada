const axios = require('axios');
const fs = require('fs');
const FormData = require('form-data');

const API_BASE_URL = 'https://pre-montada.gostcode.com/public/api';

// Read the created accounts
const accountsData = fs.readFileSync('created_accounts.txt', 'utf8');
const accounts = accountsData.split('\n')
  .filter(line => line.trim())
  .map(line => {
    const [phone, name, email, status] = line.split(',');
    return { phone, name, email, status };
  });

console.log(`📋 Loaded ${accounts.length} accounts from created_accounts.txt`);

// Split accounts into 2 teams (13 members each)
const team1Accounts = accounts.slice(0, 13);
const team2Accounts = accounts.slice(13, 26);

console.log(`\n🏆 Team 1: ${team1Accounts.length} members`);
console.log(`🏆 Team 2: ${team2Accounts.length} members`);

const teams = [
  {
    name: 'Demo Team Alpha',
    accounts: team1Accounts,
    captain: team1Accounts[0],
    subLeader: team1Accounts[1],
    members: team1Accounts.slice(2)
  },
  {
    name: 'Demo Team Beta',
    accounts: team2Accounts,
    captain: team2Accounts[0],
    subLeader: team2Accounts[1],
    members: team2Accounts.slice(2)
  }
];

// Function to login and get token (using the correct app endpoints)
async function login(phoneNumber) {
  try {
    console.log(`🔐 Logging in with ${phoneNumber}...`);

    // Step 1: Send login request to get verification code
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

    console.log(`📡 Login response status: ${loginResponse.status}`);
    console.log(`📡 Login response data:`, JSON.stringify(loginResponse.data, null, 2));

    if (loginResponse.data && loginResponse.data.data && loginResponse.data.data.code) {
      const verificationCode = loginResponse.data.data.code;
      console.log(`✅ Got verification code: ${verificationCode}`);

      // Step 2: Send verification code to get access token
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

      console.log(`📡 Verify response status: ${verifyResponse.status}`);
      console.log(`📡 Verify response data:`, JSON.stringify(verifyResponse.data, null, 2));

      if (verifyResponse.data && verifyResponse.data.data && verifyResponse.data.data.access_token) {
        console.log(`✅ Login successful for ${phoneNumber}`);
        return verifyResponse.data.data.access_token;
      } else {
        console.log(`❌ Verification failed for ${phoneNumber} - no token received`);
        return null;
      }
    } else {
      console.log(`❌ Login failed for ${phoneNumber} - no code received`);
      return null;
    }
  } catch (error) {
    console.log(`❌ Login error for ${phoneNumber}: ${error.message}`);
    if (error.response) {
      console.log(`📡 Error response status: ${error.response.status}`);
      console.log(`📡 Error response data:`, JSON.stringify(error.response.data, null, 2));
    }
    return null;
  }
}

// Function to create a team (using the correct app format)
async function createTeam(teamName, token) {
  try {
    console.log(`🏆 Creating team: ${teamName}`);

    const formData = new FormData();
    formData.append('name', teamName);
    formData.append('area_id', '1'); // Default area ID
    formData.append('bio', `Demo team: ${teamName}`);

    const response = await axios.post(`${API_BASE_URL}/team/store`, formData, {
      headers: {
        'Authorization': `Bearer ${token}`,
        'Accept': 'application/json',
        ...formData.getHeaders()
      },
      maxRedirects: 5,
      validateStatus: function (status) {
        return status >= 200 && status < 400;
      }
    });

    console.log(`📡 Team creation response status: ${response.status}`);
    console.log(`📡 Team creation response data:`, JSON.stringify(response.data, null, 2));

    if (response.data && response.data.data && response.data.data.id) {
      console.log(`✅ Team created: ${teamName} (ID: ${response.data.data.id})`);
      return response.data.data.id;
    } else {
      console.log(`❌ Team creation failed for ${teamName}`);
      return null;
    }
  } catch (error) {
    console.log(`❌ Team creation error for ${teamName}: ${error.message}`);
    if (error.response) {
      console.log(`📡 Error response status: ${error.response.status}`);
      console.log(`📡 Error response data:`, JSON.stringify(error.response.data, null, 2));
    }
    return null;
  }
}

// Function to add member to team
async function addMemberToTeam(teamId, phoneNumber, token) {
  try {
    console.log(`👤 Adding member ${phoneNumber} to team ${teamId}`);

    const response = await axios.post(`${API_BASE_URL}/team/add-member`, {
      phone_number: phoneNumber,
      team_id: teamId
    }, {
      headers: {
        'Authorization': `Bearer ${token}`,
        'Content-Type': 'application/json',
        'Accept': 'application/json'
      },
      maxRedirects: 5,
      validateStatus: function (status) {
        return status >= 200 && status < 400;
      }
    });

    if (response.data && response.data.status === true) {
      console.log(`✅ Member ${phoneNumber} added to team ${teamId}`);
      return true;
    } else {
      console.log(`❌ Failed to add member ${phoneNumber} to team ${teamId}`);
      return false;
    }
  } catch (error) {
    console.log(`❌ Add member error for ${phoneNumber}: ${error.message}`);
    return false;
  }
}

// Function to set member role
async function setMemberRole(teamId, phoneNumber, role, token) {
  try {
    console.log(`👑 Setting role ${role} for ${phoneNumber} in team ${teamId}`);

    const response = await axios.post(`${API_BASE_URL}/team/member-role`, {
      phone_number: phoneNumber,
      team_id: teamId,
      role: role
    }, {
      headers: {
        'Authorization': `Bearer ${token}`,
        'Content-Type': 'application/json',
        'Accept': 'application/json'
      },
      maxRedirects: 5,
      validateStatus: function (status) {
        return status >= 200 && status < 400;
      }
    });

    if (response.data && response.data.status === true) {
      console.log(`✅ Role ${role} set for ${phoneNumber}`);
      return true;
    } else {
      console.log(`❌ Failed to set role ${role} for ${phoneNumber}`);
      return false;
    }
  } catch (error) {
    console.log(`❌ Set role error for ${phoneNumber}: ${error.message}`);
    return false;
  }
}

async function main() {
  const teamDetails = [];

  for (let i = 0; i < teams.length; i++) {
    const team = teams[i];
    console.log(`\n🚀 Processing ${team.name}...`);

    // Use the first account (captain) to create the team
    const captainToken = await login(team.captain.phone);

    if (!captainToken) {
      console.log(`❌ Cannot proceed with ${team.name} - captain login failed`);
      continue;
    }

    // Create the team
    const teamId = await createTeam(team.name, captainToken);

    if (!teamId) {
      console.log(`❌ Cannot proceed with ${team.name} - team creation failed`);
      continue;
    }

    // Add all members to the team
    for (const member of team.accounts) {
      await addMemberToTeam(teamId, member.phone, captainToken);
      await new Promise(resolve => setTimeout(resolve, 500)); // Rate limiting
    }

    // Set roles
    console.log(`\n👑 Setting roles for ${team.name}...`);

    // Set captain role (leader)
    await setMemberRole(teamId, team.captain.phone, 'leader', captainToken);
    await new Promise(resolve => setTimeout(resolve, 500));

    // Set sub-leader role (subleader)
    await setMemberRole(teamId, team.subLeader.phone, 'subleader', captainToken);
    await new Promise(resolve => setTimeout(resolve, 500));

    // Set member roles for the rest
    for (const member of team.members) {
      await setMemberRole(teamId, member.phone, 'member', captainToken);
      await new Promise(resolve => setTimeout(resolve, 500));
    }

    // Store team details
    teamDetails.push({
      teamId: teamId,
      teamName: team.name,
      captain: {
        phone: team.captain.phone,
        name: team.captain.name,
        email: team.captain.email
      },
      subLeader: {
        phone: team.subLeader.phone,
        name: team.subLeader.name,
        email: team.subLeader.email
      },
      members: team.members.map(m => ({
        phone: m.phone,
        name: m.name,
        email: m.email
      }))
    });

    console.log(`✅ ${team.name} setup completed!`);
  }

  // Generate the output file
  let output = '🏆 DEMO TEAMS CREATION REPORT\n';
  output += '=' .repeat(50) + '\n\n';

  teamDetails.forEach((team, index) => {
    output += `TEAM ${index + 1}: ${team.teamName}\n`;
    output += `Team ID: ${team.teamId}\n`;
    output += `Total Members: ${team.members.length + 2}\n\n`;

    output += `👑 CAPTAIN:\n`;
    output += `   Phone: ${team.captain.phone}\n`;
    output += `   Name: ${team.captain.name}\n`;
    output += `   Email: ${team.captain.email}\n\n`;

    output += `🤝 SUB-LEADER:\n`;
    output += `   Phone: ${team.subLeader.phone}\n`;
    output += `   Name: ${team.subLeader.name}\n`;
    output += `   Email: ${team.subLeader.email}\n\n`;

    output += `👥 MEMBERS (${team.members.length}):\n`;
    team.members.forEach((member, idx) => {
      output += `   ${idx + 1}. Phone: ${member.phone} | Name: ${member.name} | Email: ${member.email}\n`;
    });

    output += '\n' + '-'.repeat(50) + '\n\n';
  });

  fs.writeFileSync('teams_details.txt', output);

  console.log('\n📝 Team details saved to teams_details.txt');
  console.log(`✅ Successfully created ${teamDetails.length} teams with complete member structure!`);
}

main().catch(console.error);
