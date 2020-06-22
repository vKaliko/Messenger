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
    
    var vSpinner: UIView?
    var contacts = [CNContact]()
    var selectedArr = [String]()
    var contactsPhoneNumbers = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchContacts()
        self.tableView.isEditing = true
        self.tableView.allowsMultipleSelectionDuringEditing = true
    }
    
    
    private func fetchContacts() {
        let store = CNContactStore()
        store.requestAccess(for: .contacts) { (granted, err) in
            if let err = err {
                print("Error aquired", err)
            }
    //        if granted == true {
    //            print("Access granted")
    //
    //                let keys = [CNContactGivenNameKey, CNContactFamilyNameKey, CNContactPhoneNumbersKey, CNContactEmailAddressesKey]
    //                let predicate = CNContact.predicateForContacts(withIdentifiers: [CNContactPhoneNumbersKey])
    //                do {
    //                  let contacts = try store.unifiedContactsMatchingPredicate(
    //                    predicate, keysToFetch: keys as [CNContactDescriptor])
    //
    //                  contacts
    //
    //                }
    //                catch let err {
    //                  print(err)
    //                }
    //        store.requestAccess(for: .contacts) { (granted, err) in
    //            if let err = err {
    //                print("Error aquired", err)
    //            }
            if granted == true {
                print("Access granted")
                DispatchQueue.global().async { [weak self] in
                    guard let self = self else {
                      return
                    }
                    var filteredContacts = [CNContact]()
                    var filteredPhoneNumbers = [String]()
                    do {
                        let keys = [CNContactGivenNameKey, CNContactFamilyNameKey, CNContactPhoneNumbersKey, CNContactEmailAddressesKey]
                        let request = CNContactFetchRequest(keysToFetch: keys as [CNKeyDescriptor])
                        try store.enumerateContacts(with: request, usingBlock: { (contact, stopPointerIfYouWantToStopEnumerating) in
                            if let _ = contact.phoneNumbers.first?.value.stringValue {
                                var found = false
                                for profile in Profile.allProfiles {
                                    if let contactEmail = contact.emailAddresses.first?.value {
                                        if contactEmail as String == profile.email {
                                            found = true
                                            break
                                        }
                                    }
                                }
                                if !found {
                                    filteredContacts.append(contact)
                                    filteredPhoneNumbers.append((contact.phoneNumbers.first?.value.stringValue)!)
                                }
                            }
                            else {
                                print("No phone number found")
                            }
                            print(filteredContacts)
                        })
                    }
                    catch let err {
                        print("Faild enumerating", err)
                    }
                    DispatchQueue.main.async {
                        self.contacts = filteredContacts
                        self.contactsPhoneNumbers = filteredPhoneNumbers
                        self.tableView.reloadData()
                    }
                }
            }
            else {
                print("Access denied")
            }
        }
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
            composeVC.body = "Hey, I am really enjoying using Messenger++ for chatting. Join me! You can download it here: https://apps.apple.com/app/id1516976659"
                
            self.present(composeVC, animated: true, completion: nil)
            
        }
    }
    
//    func showSpinner(onView: UIView) {
//           let spinnerView = UIView.init(frame: onView.bounds)
//            let ai = UIActivityIndicatorView.init(style: .UIActivityIndicatorView.Style.large)
//           ai.startAnimating()
//           ai.center = spinnerView.center
//
//           DispatchQueue.main.async {
//               spinnerView.addSubview(ai)
//               onView.addSubview(spinnerView)
//           }
//
//           vSpinner = spinnerView
//       }
//
//       func removeSpinner() {
//           DispatchQueue.main.async {
//            self.vSpinner?.removeFromSuperview()
//            self.vSpinner = nil
//           }
//       }
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        controller.dismiss(animated: true, completion: nil)
    }
    
}



