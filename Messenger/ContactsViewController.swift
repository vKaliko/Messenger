//
//  ContactsViewController.swift
//  Messenger
//
//  Created by Vanya Kaliko on 30.06.2020.
//  Copyright © 2020 Obsessive Coders, Inc. All rights reserved.
//

import UIKit
import ContactsUI

class ContactsViewController: UITableViewController {
    var allContacts = [CNContact]()
    var contacts = [CNContact]()
    var selectedArr = [String]()
    var contactsPhoneNumbers = [String]()
    var inviteContactsPhoneNumbers = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchContacts()
    }
    
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
                            else {
                                //print("No phone number found")
                            }
                            //print(filteredContacts)
                        })
                    }
                    catch let err {
                        print("Faild enumerating", err)
                    }
                    DispatchQueue.main.async {
                        self.contacts = filteredContacts
                        self.contactsPhoneNumbers = filteredPhoneNumbers
                        self.allContacts = filteredAllContacts
                        self.inviteContactsPhoneNumbers = filteredInviteContactsPhoneNumbers
                        self.tableView.reloadData()
                    }
                }
            }
            else {
                print("Access denied")
            }
        }
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "ContactCell", for: indexPath) as! ContactCell
        cell.contactNameLabel.text = contact.givenName + " " + contact.familyName
        if cell.contactNameLabel.text == " " {
            cell.contactNameLabel.text = contact.phoneNumbers.first?.value.stringValue
        }
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let inviteVC = segue.destination as! InviteContactsViewController
        inviteVC.contacts = Array(Set(allContacts).symmetricDifference(Set(contacts)))
        inviteVC.contactsPhoneNumbers = inviteContactsPhoneNumbers
    }
}
