const functions = require('firebase-functions');
const admin = require('firebase-admin');

admin.initializeApp();

const db = admin.firestore();

/**
 * Creates a document with ID -> uid in the `Users` collection.
 *
 * @param {Object} userRecord Contains the auth, uid and displayName info.
 * @param {Object} context Details about the event.
 */
const createProfile = (userRecord, context) => {
  const {email, displayName, uid, photoURL } = userRecord;

  return db
    .collection('profiles')
    .doc(uid)
    .set({"email": email, "displayName": displayName, "photoUrl": photoURL})
    .catch(console.error);
};


const sendNotification = (change, context) => {
	const dict = change.after.data();
	const allMessages = dict['messages'];
  const lastMessage = allMessages[allMessages.length-1];
	const body = lastMessage['text'];
  //let nameOfChat = dict["title"] as! String
  console.log('Body: ', dict);
  var message = {
    notification: {
      title: 'New Message',
      body: body
    },
	topic: 'all'
  };


  // Send a message to devices subscribed to the provided topic.
  return admin.messaging().send(message);
};
	
module.exports = {
  authOnCreate: functions.auth.user().onCreate(createProfile),
  notifOnMessage: functions.firestore.document('chats/{chatId}').onUpdate(sendNotification),
};