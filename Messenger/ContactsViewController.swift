//
//  ContactsViewController.swift
//  Messenger
//
//  Created by Vanya Kaliko on 01.06.2020.
//  Copyright © 2020 Obsessive Coders, Inc. All rights reserved.
//

import UIKit
import ContactsUI
import MessageUI

class ContactsViewController: UITableViewController, MFMessageComposeViewControllerDelegate {
    
    
    var contacts = [CNContact]()
    var selectedArr = [String]()
    var contactsPhoneNumbers = [String]()
    
    private func fetchContacts() {
        print("Lalalalalallalala")
        let store = CNContactStore()
        store.requestAccess(for: .contacts) { (granted, err) in
            if let err = err {
                print("Error aquired", err)
            }
            if granted == true {
                print("Access granted")
                let keys = [CNContactGivenNameKey, CNContactFamilyNameKey, CNContactPhoneNumbersKey, CNContactEmailAddressesKey]
                let request = CNContactFetchRequest(keysToFetch: keys as [CNKeyDescriptor])
                do {
                    try store.enumerateContacts(with: request, usingBlock: { (contact, stopPointerIfYouWantToStopEnumerating) in
                        if let contactPhoneNumber = contact.phoneNumbers.first?.value.stringValue {
                            var counter = 0
                            for profile in Profile.allProfiles {
                                if let contactEmail = contact.emailAddresses.first?.value, contact.givenName != nil || contact.familyName != nil {
                                    if contactEmail as String == profile.email {
                                        counter += 1
                                    }
                                }
                            }
                            if counter != 1 {
                                self.contacts.append(contact)
                                self.contactsPhoneNumbers.append(contactPhoneNumber)
                                counter = 0
                            }
                        }
                        else {
                            print("No phone number found")
                        }
                        print(self.contacts)
                    })
                }
                catch let err {
                    print("Faild enumerating", err)
                }
            }
            else {
                print("Access denied")
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchContacts()
        self.tableView.isEditing = true
        self.tableView.allowsMultipleSelectionDuringEditing = true
    }
    
    //MARK: - UITableViewDelegate
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contacts.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let contact = contacts[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "ContactCell", for: indexPath) as! ContactCell
        cell.contactNameLabel.text = contact.givenName + " " + contact.familyName
        if cell.contactNameLabel.text == " " {
            cell.contactNameLabel.text = contact.phoneNumbers.first?.value.stringValue
        }
        return cell
    }
    
    @IBAction func InviteButton(_ sender: Any) {
        var selected = [String]()
        if let arr = tableView.indexPathsForSelectedRows {
            for i in arr {
                selected.append(contactsPhoneNumbers[i.row])
            }
            
            if !MFMessageComposeViewController.canSendText() {
                print("SMS services are not available")
            }
            let composeVC = MFMessageComposeViewController()
            composeVC.messageComposeDelegate = self
                
            composeVC.recipients = selected
            composeVC.body = "Hey, I am really enjoying using Messenger++ for chatting. Join me! You can download it here: https://google.com"
                
            self.present(composeVC, animated: true, completion: nil)
            
        }
    }
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        controller.dismiss(animated: true, completion: nil)
    }
    
}



