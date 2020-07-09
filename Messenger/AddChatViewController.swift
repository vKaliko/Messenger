//
//  AddChatViewController.swift
//  Messenger
//
//  Created by Vanya Kaliko on 06.07.2020.
//  Copyright © 2020 Obsessive Coders, Inc. All rights reserved.
//

import UIKit
import ContactsUI
import FirebaseFirestore
import Firebase
import FirebaseUI

class AddChatViewController: UITableViewController {
    
    var contacts = ContactsViewController.contacts
    var db: Firestore!
    var chat: Chat!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        db = Firestore.firestore()
        self.tableView.isEditing = true
        self.tableView.allowsMultipleSelectionDuringEditing = true
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return contacts.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let contact = contacts[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "AddChatCell", for: indexPath) as! AddChatCell
        cell.addChatNameLabel.text = contact.givenName + " " + contact.familyName
        if cell.addChatNameLabel.text == " " {
            cell.addChatNameLabel.text = contact.phoneNumbers.first?.value.stringValue
        }
        return cell
    }
    func tappedBackButton() {
        self.navigationController!.popViewController(animated: true)
    }
    @IBAction func CreateChatButton(_ sender: Any) {
        var selected = [String]()
        if let arr = tableView.indexPathsForSelectedRows {
            for i in arr {
                selected.append((contacts[i.row].emailAddresses.first?.value)! as String)
            }
//            let chat = Chat(title, id: "")
//            var ref: DocumentReference? = nil
//            ref = self.db.collection("chats").addDocument(data: chat.toDict()) { err in
//                if let err = err {
//                    print("Error adding document: \(err)")
//                }
//                else {
//                    chat.id = ref!.documentID
//                }
            let chat = Chat("TEST", id: "", particip: selected)
            var ref: DocumentReference?
            ref = db.collection("chatswuids").addDocument(data: chat.toDict()) { err in
                if let err = err {
                    print("Error adding document: \(err)")
                }
                else {
                    chat.id = ref!.documentID
                }
            }
            tappedBackButton()
        }
    }
}
