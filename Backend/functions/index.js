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
	const { email, displayName, uid, photoURL } = userRecord;

	return db
		.collection('profiles')
		.doc(uid)
		.set({ 'email': email, 'displayName': displayName, 'photoUrl': photoURL, 'token': "" })
		.catch(console.error);
};


const sendNotification = (change, context) => {
	const dict = change.after.data();
	const allMessages = dict['messages'];
	const lastMessage = allMessages[allMessages.length - 1];
	const text = lastMessage['text'];
	const uid = lastMessage['uid'];
	const chatTitle = dict['title'];
	const profilesCollection = db.collection('profiles');
	const userRef = profilesCollection.doc(uid);
	const chatId = context.params.chatId;
	const particip = dict["particip"];
	const profiles = profilesCollection.where('id', 'in', particip).get();
	const registrationTokens = [];
	for (profile in profiles) {
		if (profile["id"] !== lastMessage["id"]) {
			registrationTokens.append(profile["token"])
		}
	}
	const userDoc = userRef.get()
		.then(doc => {
			if (!doc.exists) {
				console.log('No such document!');
				throw new Error('No such doc');
			}
			else {
				const profileDict = doc.data();
				const displayName = profileDict['displayName'];
				var message = {
					notification: {
						title: displayName + ' in ' + chatTitle,
						body: text
					},
					data: {
						chatId: chatId
					},
					tokens: registrationTokens,
				};
				return admin.messaging().sendMulticast(message)
					.then((response) => {
						console.log(response.successCount + ' messages were sent successfully');
						return;
					})
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
