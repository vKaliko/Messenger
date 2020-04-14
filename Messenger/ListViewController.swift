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

class ListViewController: UITableViewController, FUIAuthDelegate {
    
    var chats = [Chat]()
    var db: Firestore!
    var profiles: [Profile]!
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        tabBarController?.tabBar.isHidden = false
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = editButtonItem
        db = Firestore.firestore()
        guard let authUI = FUIAuth.defaultAuthUI() else {
            return
        }
        authUI.delegate = self
        authUI.providers = [FUIEmailAuth()]
        Auth.auth().addStateDidChangeListener { (auth, user) in
            print("listvc. Login change listener user = \(user)")
            if auth.currentUser == nil {
                self.present(authUI.authViewController(), animated: true, completion: nil)
            }
        }
        db.collection("profiles").addSnapshotListener { (querySnapshot, err) in
            if let err = err {
                print("Error fetching: \(err)")
            }
            else {
                var newProfiles = [Profile]()
                for document in querySnapshot!.documents {
                    let d = document.data()
                    let p = Profile(dict: d, id: document.documentID)
                    newProfiles.append(p)
                }
                self.profiles = newProfiles
            }
        }
        db.collection("chats").order(by: "title").addSnapshotListener { (querySnapshot, err) in
            if let err = err {
                print("Error fetching: \(err)")
            } else {
                var newChats = [Chat]()
                for document in querySnapshot!.documents {
                    let d = document.data()
                    let chat = Chat(dict: d, id: document.documentID)
                    newChats.append(chat)
                }
                self.chats = newChats
                self.tableView.reloadData()
            }
        }
        
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

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
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChatCell", for: indexPath)
        cell.textLabel?.text = chats[indexPath.row].title
        return cell
    }
    
    /*   // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

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
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let chatVC = segue.destination as! ChatViewController
        let cell = sender as! UITableViewCell
        guard let row = tableView.indexPath(for: cell)?.row else {
            return
        }
        chatVC.chat = chats[row]
        chatVC.profiles = profiles
        
    }
    @IBAction func addChat(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "New Chat", message: nil, preferredStyle: .alert)
        
        alert.addTextField()
        let submitAction = UIAlertAction(title: "Add", style: .default) { [unowned alert] _ in
            guard let title = alert.textFields![0].text, title.count > 0 else {
                return
            }
            
            let chat = Chat(title, id: "")
            var ref: DocumentReference? = nil
            ref = self.db.collection("chats").addDocument(data: chat.toDict()) { err in
                if let err = err {
                    print("Error adding document: \(err)")
                }
                else {
                    chat.id = ref!.documentID
                }
            }

            // do something interesting with "answer" here
        }
        alert.addAction(submitAction)

        alert.addAction(UIAlertAction(title: NSLocalizedString("Cancel", comment: "Default action"), style: .default, handler: { _ in
        NSLog("The \"OK\" alert occured.")
        }))
        
        self.present(alert, animated: true, completion: nil)
        
        
        
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let chatId = chats[indexPath.row].id
            db.collection("chats").document(chatId).delete() { err in
                if let err = err {
                    print("Error removing document: \(err)")
                } else {
                    print("Document successfully removed!")
                }
            }
        }
    }
    

}
