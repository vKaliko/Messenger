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
    
    var contacts = ListViewController.contacts
    var db: Firestore!
    var chat: Chat!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        db = Firestore.firestore()
        self.tableView.isEditing = true
        self.tableView.allowsMultipleSelectionDuringEditing = true
        self.navigationController?.navigationBar.prefersLargeTitles = false
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
    @IBAction func CreateButton(_ sender: Any) {
        guard let user = Auth.auth().currentUser else {
            return
        }
        var selectedIds = [user.uid]
        var selectedNames = [String]()
        var title = "" 
        if let arr = tableView.indexPathsForSelectedRows {
            for i in arr {
                for profile in Profile.allProfiles {
                    if profile.email == contacts[i.row].emailAddresses.first!.value as String {
                        selectedIds.append(profile.id)
                        if profile.displayName == nil {
                            selectedNames.append(profile.email)
                        }
                        else {
                            selectedNames.append(profile.displayName!)
                        }
                    }
                }
            }
            if selectedNames.count == 2 {
                title = selectedNames[0] + " & " + selectedNames[1]
            }
            if selectedNames.count > 2 {
                title = selectedNames[0] + ", " + selectedNames[1] + " and more"
            }
            if selectedNames.count == 1 {
                title = selectedNames[0]
            }
            let chat = Chat(title, id: "", particip: selectedIds)
            var ref: DocumentReference? = nil
            ref = self.db.collection("chatswuids").addDocument(data: chat.toDict()) { err in
                if let err = err {
                    print("Error adding document: \(err)")
                }
                else {
                    chat.id = ref!.documentID
                    
                }
            }
            navigationController?.popViewController(animated: true)
        }
    }
}
