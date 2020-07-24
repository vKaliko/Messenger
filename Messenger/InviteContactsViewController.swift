//
//  ContactsViewController.swift
//  Messenger
//
//  Created by Vanya Kaliko on 01.06.2020.
//  Copyright © 2020 Obsessive Coders, Inc. All rights reserved.
//

//import UIKit
//import ContactsUI
//import MessageUI
//
//class InviteContactsViewController: UITableViewController, MFMessageComposeViewControllerDelegate {
//    
//    var contacts = [CNContact]()
//    var selectedArr = [String]()
//    var contactsPhoneNumbers = [String]()
//    var searchedContacts = [CNContact]()
//    let searchController = UISearchController(searchResultsController: nil)
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        searchController.searchResultsUpdater = self
//        searchController.obscuresBackgroundDuringPresentation = false
//        searchController.searchBar.placeholder = "Search Contacts"
//        navigationItem.searchController = searchController
//        definesPresentationContext = true
//        self.tableView.isEditing = true
//        self.tableView.allowsMultipleSelectionDuringEditing = true
//    }
//    
//    var isSearchBarEmpty: Bool {
//      return searchController.searchBar.text?.isEmpty ?? true
//    }
//    var isFiltering: Bool {
//      return searchController.isActive && !isSearchBarEmpty
//    }
//    
//    //MARK: - UITableViewDelegate
////    override func numberOfSections(in tableView: UITableView) -> Int {
////        // #warning Incomplete implementation, return the number of sections
////        return 1
////    }
////
////    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
////        if isFiltering {
////            return searchedContacts.count
////          }
////        else {
////            return contacts.count
////        }
////    }
////
////    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
////        let contact: CNContact
////        if isFiltering {
////            contact = searchedContacts[indexPath.row]
////        }
////        else {
////            contact = contacts[indexPath.row]
////        }
////        let cell = tableView.dequeueReusableCell(withIdentifier: "InviteContactCell", for: indexPath) as! InviteContactCell
////        cell.inviteContactNameLabel.text = contact.givenName + " " + contact.familyName
////        if cell.inviteContactNameLabel.text == " " {
////            cell.inviteContactNameLabel.text = contact.phoneNumbers.first?.value.stringValue
////        }
////        return cell
////    }
//    
//    @IBAction func InviteButton(_ sender: Any) {
//        var selected = [String]()
//        if let arr = tableView.indexPathsForSelectedRows {
//            for i in arr {
//                selected.append(contactsPhoneNumbers[i.row])
//            }
//            
//            if !MFMessageComposeViewController.canSendText() {
//                print("SMS services are not available")
//            }
//            let composeVC = MFMessageComposeViewController()
//            composeVC.messageComposeDelegate = self
//                
//            composeVC.recipients = selected
//            composeVC.body = "Hey, I am really enjoying using Messenger++ for chatting. Join me! You can download it here: https://apps.apple.com/app/id1516976659"
//                
//            self.present(composeVC, animated: true, completion: nil)
//            
//        }
//    }
//    
//    
//    
//    func filterContentForSearchText(_ searchText: String) {
//      searchedContacts = contacts.filter { (contact: CNContact) -> Bool in
//        if contact.familyName.lowercased().contains(searchText.lowercased()) || contact.givenName.lowercased().contains(searchText.lowercased()) {
//            return true
//        }
//        else {
//            return false
//        }
//        
//      }
//      tableView.reloadData()
//    }
//}
//extension InviteContactsViewController: UISearchResultsUpdating {
//    func updateSearchResults(for searchController: UISearchController) {
//      let searchBar = searchController.searchBar
//      filterContentForSearchText(searchBar.text!)
//    }
//}



