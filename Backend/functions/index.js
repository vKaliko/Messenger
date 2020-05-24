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
    .set({'email': email, 'displayName': displayName, 'photoUrl': photoURL})
    .catch(console.error);
};


const sendNotification = (change, context) => {
	const dict = change.after.data();
	const allMessages = dict['messages'];
  const lastMessage = allMessages[allMessages.length-1];
	const text = lastMessage['text'];
	const uid = lastMessage['uid'];
	const chatTitle = dict['title'];
	const userRef = db.collection('profiles').doc(uid);
	const userDoc = userRef.get()
	  .then(doc => {
	    if (!doc.exists) {
	      console.log('No such document!');
				throw new Error('No such doc');
	    } 
			else {
				const profileDict = doc.data();
	      console.log('Document data:', profileDict);
				const displayName = profileDict['displayName'];
			  console.log('Body: ', dict);
			  var message = {
			    notification: {
			      title: displayName + ' in ' + chatTitle,
			      body: text
			    },
				topic: 'all'
			  };
	
			  return admin.messaging().send(message);
	    }
	  })
	  .catch(err => {
	    console.log('Error getting document', err);
			throw new Error('Error getting doc');
	  });
};
	
module.exports = {
  authOnCreate: functions.auth.user().onCreate(createProfile),
  notifOnMessage: functions.firestore.document('chats/{chatId}').onUpdate(sendNotification),
};