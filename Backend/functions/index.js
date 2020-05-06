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

module.exports = {
  authOnCreate: functions.auth.user().onCreate(createProfile),
};

exports.updateUser = functions.firestore
    .document('chats/{chatId}')
    .onUpdate((change, context) => {
      // Get an object representing the document
      // e.g. {'name': 'Marie', 'age': 66}
      const newValue = change.after.data();

      // ...or the previous value before this update
      const previousValue = change.before.data();

      // access a particular field as you would any JS property
      const name = newValue.name;

      // perform desired operations ...
	  //const newMessages = newValue["messages"];
	  // The topic name can be optionally prefixed with "/topics/".
	  var message = {
	    notification: {
	      title: 'New Message',
	      body: 'This is a message'
	    },
		topic: 'messages'
	  };
	  

	  // Send a message to devices subscribed to the provided topic.
	  admin.messaging().send(message)
	    .then((response) => {
	      // Response is a message ID string.
	      console.log('Successfully sent message:', response);
	    })
	    .catch((error) => {
	      console.log('Error sending message:', error);
	    });  
    });
	