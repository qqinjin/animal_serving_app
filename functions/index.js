<<<<<<< HEAD
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
=======
/**
 * Import function triggers from their respective submodules:
 *
 * const {onCall} = require("firebase-functions/v2/https");
 * const {onDocumentWritten} = require("firebase-functions/v2/firestore");
 *
 * See a full list of supported triggers at https://firebase.google.com/docs/functions
 */

const {onRequest} = require("firebase-functions/v2/https");
const logger = require("firebase-functions/logger");

// Create and deploy your first functions
// https://firebase.google.com/docs/functions/get-started

// exports.helloWorld = onRequest((request, response) => {
//   logger.info("Hello logs!", {structuredData: true});
//   response.send("Hello from Firebase!");
// });

const functions = require("firebase-functions");
const admin = require("firebase-admin");
admin.initializeApp();

exports.sendNotificationOnAnimalCheck = functions.firestore
  .document("pet/{petId}")
  .onUpdate(async (change, context) => {
    const newValue = change.after.data();
    const previousValue = change.before.data();

    if (newValue && previousValue && newValue.animal_check !== previousValue.animal_check && newValue.animal_check === '1') {
      const fcmToken = newValue.fcm_token; // 사용자의 FCM 토큰 가져오기
      const payload = {
        notification: {
          title: "Animal Check",
          body: "Animal check status has been updated!",
        },
      };

      return admin.messaging().sendToDevice(fcmToken, payload);
    }

    return null;
  });
>>>>>>> 73218a0b5d384e735ee82fcc889d8e3ec7afe72b
