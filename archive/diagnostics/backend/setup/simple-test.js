const https = require('https');

// Simple fetch test
https.get('https://servicios-prados-de-nos.onrender.com/health', (res) => {
    console.log('Status:', res.statusCode);
    let data = '';
    res.on('data', chunk => data += chunk);
    res.on('end', () => {
        console.log('Health check response:', data);
        
        // Test /api/plazas
        https.get('https://servicios-prados-de-nos.onrender.com/api/plazas', (res2) => {
            console.log('\n/api/plazas Status:', res2.statusCode);
            let data2 = '';
            res2.on('data', chunk => data2 += chunk);
            res2.on('end', () => {
                console.log('Plazas response:', data2);
                
                // Test /api/checkins/public
                https.get('https://servicios-prados-de-nos.onrender.com/api/checkins/public?periodo=hoy', (res3) => {
                    console.log('\n/api/checkins/public Status:', res3.statusCode);
                    let data3 = '';
                    res3.on('data', chunk => data3 += chunk);
                    res3.on('end', () => {
                        console.log('Checkins public response:', data3);
                    });
                });
            });
        });
    });
}).on('error', err => {
    console.error('Error:', err.message);
});
