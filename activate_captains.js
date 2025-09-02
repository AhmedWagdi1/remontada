const axios = require('axios');

async function activateCaptains() {
    const captains = [
        { phone: '0591010553', name: 'Ibrahim Al-Harbi' },
        { phone: '0536053159', name: 'Youssef Al-Mansouri' }
    ];

    for (const captain of captains) {
        console.log(`🔓 Activating ${captain.name} (${captain.phone})`);

        try {
            const response = await axios.post('https://pre-montada.gostcode.com/public/api/activate', {
                mobile: captain.phone,
                code: '11111',
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

            console.log(`📡 Response status: ${response.status}`);
            console.log(`📡 Response data:`, JSON.stringify(response.data, null, 2));

            if (response.data && response.data.status === true) {
                console.log(`✅ SUCCESS: ${captain.name} activated`);
            } else {
                console.log(`❌ FAILED: ${captain.name} activation failed`);
            }
        } catch (error) {
            console.log(`❌ ERROR: ${captain.name} - ${error.message}`);
        }

        console.log('---');
    }
}

activateCaptains();
