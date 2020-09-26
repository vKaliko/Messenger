//
//  ListViewController.swift
//  Messenger
//
//  Created by Ilia Kaliko on 3/8/20.
//  Copyright © 2020 Obsessive Coders, Inc. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase
import FirebaseFirestore
import FirebaseUI
import ContactsUI

class ListViewController: UITableViewController, FUIAuthDelegate {
    
    var chats = [Chat]()
    var db: Firestore!
    static var contactChats = [Chat]()
    static var contacts = [CNContact]()
    static var allContacts = [CNContact]()
    static var selectedArr = [String]()
    static var contactsPhoneNumbers = [String]()
    static var inviteContactsPhoneNumbers = [String]()
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        tabBarController?.tabBar.isHidden = false
        self.navigationController?.navigationBar.prefersLargeTitles = true
        guard let user = Auth.auth().currentUser else {
            return
        }
        db.collection("chatswuids").whereField("particip", arrayContains: user.uid).addSnapshotListener { (querySnapshot, err) in
            if let err = err {
                print("Error fetching: \(err)")
            }
            else {
                var newChats = [Chat]()
                for document in querySnapshot!.documents {
                    let d = document.data()
                    let chat = Chat(dict: d, id: document.documentID)
                    newChats.append(chat)
                }
                self.chats = newChats
                if self.chats.count == 0 {
                    self.navigationItem.leftBarButtonItem?.isEnabled = false
                }
                else {
                    self.navigationItem.leftBarButtonItem?.isEnabled = true
                }
                self.tableView.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        let storage = Storage.storage()
//        let storageReference = storage.reference().child("files/uid")
//        storageReference.listAll { (result, error) in
//          if let error = error {
//            print(error)
//          }
//            for item in result.items {
//                item.getMetadata { metadata, error in
//                  if let error = error {
//                    print(error)
//                  } else {
//                    print(metadata?.size)
//                  }
//                }
//            }
//        }
        db = Firestore.firestore()
        db.collection("profiles").addSnapshotListener { (querySnapshot, err) in
            if let err = err {
                print(err)
            }
            else {
                var newProfiles = [Profile]()
                var newDictProfiles = [String: Profile]()
                for document in querySnapshot!.documents {
                    let d = document.data()
                    let p = Profile(dict: d, id: document.documentID)
                    if let photoUrl = p.photoUrl, let url = URL(string: photoUrl) {
                       URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
                           if let error = error {
                               print(error)
                               return
                           }
                           DispatchQueue.main.async {
                                p.photo = UIImage(data: data!)
                           }
                       }).resume()
                    }
                    newProfiles.append(p)
                    newDictProfiles[p.id] = p
                }
                Profile.allProfiles = newProfiles
                Profile.dictAllProfiles = newDictProfiles
                self.fetchContacts()
                self.tableView.reloadData()
            }
            
        }
        navigationItem.leftBarButtonItem = editButtonItem
        guard let authUI = FUIAuth.defaultAuthUI() else {
            return
        }
        authUI.delegate = self
        authUI.providers = [FUIEmailAuth(), FUIGoogleAuth(), FUIOAuth.appleAuthProvider()]
        Auth.auth().addStateDidChangeListener { (auth, user) in
            print("listvc. Login change listener user = \(user)")
            if auth.currentUser == nil {
                self.present(authUI.authViewController(), animated: true, completion: nil)
                FUIAuth.defaultAuthUI()?.shouldHideCancelButton = true
                
            }
            else {
                UIApplication.shared.registerForRemoteNotifications()
            }
        }
        
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = falsevc

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chats.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChatsCell", for: indexPath) as! ChatsCell
        cell.chatName.text = chats[indexPath.row].title
        if Profile.dictAllProfiles != nil {
            let profile = Profile.dictAllProfiles[chats[indexPath.row].particip[1]]
            let name = profile?.displayName ?? profile!.email
            if let photo = profile?.photo {
                cell.chatImageView?.isHidden = false
                cell.chatTwoLettersLabel?.isHidden = true
                cell.chatImageView?.image = photo
            }
            else {
                 cell.chatImageView?.isHidden = true
                 cell.chatTwoLettersLabel?.isHidden = false
                 let wordArray = name.split(separator: " ")
                 if wordArray.count >= 2 {
                     cell.chatTwoLettersLabel?.text = String(wordArray[0][wordArray[0].startIndex]) + String(wordArray[1][wordArray[1].startIndex])
                 }
                 else {
                     cell.chatTwoLettersLabel?.text = String(name[name.startIndex])
                 }
             }
             return cell
        }
        else {
            return tableView.dequeueReusableCell(withIdentifier: "", for: indexPath)
        }
    }
        
        override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let chatId = chats[indexPath.row].id
            db.collection("chatswuids").document(chatId).delete() { err in
                if let err = err {
                    print("Error removing document: \(err)")
                }
                else {
                    print("Document successfully removed!")
                }
            }
        }
    }
    
    /*   // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */


//
//    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
//        if editingStyle == .delete {
//            // Delete the row from the data source
//
//        } else if editingStyle == .insert {
//            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
//        }
//    }


    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    
    private func fetchContacts() {
        let store = CNContactStore()
        store.requestAccess(for: .contacts) { (granted, err) in
            if let err = err {
                print("Error aquired", err)
            }
            if granted == true {
                print("Access granted")
                DispatchQueue.global().async { [weak self] in
                    guard let self = self else {
                      return
                    }
                    var contactChats = [Chat]()
                    var filteredContacts = [CNContact]()
                    var filteredPhoneNumbers = [String]()
                    var filteredAllContacts = [CNContact]()
                    var filteredInviteContactsPhoneNumbers = [String]()
                    do {
                        let keys = [CNContactGivenNameKey, CNContactFamilyNameKey, CNContactPhoneNumbersKey, CNContactEmailAddressesKey]
                        let request = CNContactFetchRequest(keysToFetch: keys as [CNKeyDescriptor])
                        request.sortOrder = CNContactSortOrder.userDefault
                        try store.enumerateContacts(with: request, usingBlock: { (contact, stopPointerIfYouWantToStopEnumerating) in
                            if let _ = contact.phoneNumbers.first?.value.stringValue {
                                var found = false
                                for profile in Profile.allProfiles {
                                    filteredAllContacts.append(contact)
                                    if let contactEmail = contact.emailAddresses.first?.value {
                                        if contactEmail as String == profile.email {
                                            found = true
                                            contactChats.append(Chat(profile.displayName ?? profile.email, id: profile.id, particip: [profile.id]))
                                            break
                                        }
                                    }
                                }
                                if found {
                                    filteredContacts.append(contact)
                                    filteredPhoneNumbers.append((contact.phoneNumbers.first?.value.stringValue)!)
                                }
                                else {
                                    filteredInviteContactsPhoneNumbers.append((contact.phoneNumbers.first?.value.stringValue)!)
                                }
                            }
                        })
                    }
                    catch let err {
                        print("Faild enumerating", err)
                    }
                    DispatchQueue.main.async {
                        ListViewController.self.contacts = filteredContacts
                        ListViewController.self.contactsPhoneNumbers = filteredPhoneNumbers
                        ListViewController.self.allContacts = filteredAllContacts
                        ListViewController.self.inviteContactsPhoneNumbers = filteredInviteContactsPhoneNumbers
                        ListViewController.self.contactChats = contactChats
                        self.tableView.reloadData()
                    }
                }
            }
            else {
                print("Access denied")
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowChatSegue" {
            let chatVC = segue.destination as! ChatViewController
            let cell = sender as! UITableViewCell
            guard let row = tableView.indexPath(for: cell)?.row else {
                return
            }
            chatVC.chat = chats[row]
        }
    }
    
    
}
