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
