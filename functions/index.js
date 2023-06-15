const functions = require('firebase-functions');
const admin = require('firebase-admin');

const serviceAccount = require('D:/deu_2023/capstone/APP/andApp/android/app/google-services.json');

admin.initializeApp({
    credential: admin.credential.cert(serviceAccount)
});

exports.sendNotification = functions.firestore
    .document('pet/{petId}')
    .onUpdate((change, context) => {
        const newValue = change.after.data();
        const previousValue = change.before.data();

        if (newValue.animal_check === '1' && previousValue.animal_check !== '1') {
            const payload = {
                notification: {
                    title: 'Animal check changed to 1',
                    body: 'The animal_check value has been changed to 1.',
                    // 여기에 다른 옵션들을 추가할 수 있습니다. 예를 들어 'click_action', 'icon' 등입니다.
                }
            };

            // 특정 주제에 대해 메시지를 보냅니다. 이 경우 'your_topic'을 변경해야합니다.
            return admin.messaging().sendToTopic('animal_check', payload)
                .then((response) => {
                    console.log('Successfully sent message:', response);
                })
                .catch((error) => {
                    console.log('Error sending message:', error);
                });
        } else {
            console.log('animal_check value has not changed to 1');
            return null;
        }
    });
