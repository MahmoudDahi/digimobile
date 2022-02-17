var admin = require("firebase-admin");

var serviceAccount = require("E:/flutterProjects/digimobile/services.json");


admin.initializeApp({
    credential: admin.credential.cert(serviceAccount)
});


var registrationToken = 'fV366_lHSIC8nI0qESJz5h:APA91bE3mQHqysPW3Xp1Q86SeNFaQqiABOx2cBa0-LGDQmUKwO_tyn-vMCvWWhBmV_1IwRmvDNPKgQkue8BRPBZri29InQMoNKXWbjI1U1GrgtKBcK6MPdca7zr8xl9rpahiU0VSthgy';

var message = {

    data: {
        title: 'from Node Js',
        body: 'test',
        code: 'this code 1',
    },
    token: registrationToken
};

admin.messaging().send(message).then((resonse) => {
    console.log('Successfully sent message', resonse);
}).catch((error) => {
    console.log('error  sending message:', error);
});