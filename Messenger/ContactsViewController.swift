//
//  ContactsViewController.swift
//  Messenger
//
//  Created by Vanya Kaliko on 30.06.2020.
//  Copyright © 2020 Obsessive Coders, Inc. All rights reserved.
//

import UIKit
import ContactsUI
import MessageUI

class ContactsViewController: UITableViewController {
    
    var allContacts = [CNContact]()
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = false
        self.navigationController?.navigationBar.prefersLargeTitles = true
    }
    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return ListViewController.contacts.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let contact = ListViewController.contacts[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "ContactCell", for: indexPath) as! ContactCell
        cell.contactNameLabel.text = contact.givenName + " " + contact.familyName
        if cell.contactNameLabel.text == " " {
            cell.contactNameLabel.text = contact.phoneNumbers.first?.value.stringValue
        }
        return cell
    }
    @IBAction func addContacts(_ sender: Any) {
        let contactPicker = CNContactPickerViewController()
        contactPicker.delegate = self
        contactPicker.predicateForEnablingContact = NSPredicate(
          format: "phoneNumbers.@count > 0")
        present(contactPicker, animated: true, completion: nil)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let chatVC = segue.destination as! ChatViewController
        let cell = sender as! UITableViewCell
        guard let row = tableView.indexPath(for: cell)?.row else {
            return
        }
        chatVC.chat = ListViewController.contactChats[row]
        
    }
}


extension ContactsViewController: CNContactPickerDelegate, MFMessageComposeViewControllerDelegate {
    func contactPicker(_ picker: CNContactPickerViewController,
                     didSelect contacts: [CNContact]) {
     
        var selected = [String]()
        for contact in contacts {
            selected.append((contact.phoneNumbers.first?.value.stringValue)!)
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
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        controller.dismiss(animated: true, completion: nil)
    }
}

 
