//
//  ChatViewController.swift
//  Messenger
//
//  Created by Vanya Kaliko on 05.03.2020.
//  Copyright © 2020 Obsessive Coders, Inc. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore



class ChatViewController: UITableViewController {
    
    var messages = [[String: Any]]()
        
    
    override func viewDidLoad() {
        super.viewDidLoad()
        FirebaseApp.configure()
        let db = Firestore.firestore()
        db.collection("message").order(by: "time").addSnapshotListener { (querySnapshot, err) in
            if let err = err {
                print("Error fetching: \(err)")
            } else {
                var dicts = [[String: Any]]()
                for document in querySnapshot!.documents {
                    let d = document.data()
                    dicts.append(d)
                }
                self.messages = dicts
                self.tableView.reloadData()
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
        return messages.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let d = messages[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "MessageCell", for: indexPath) as! MessageCell
        
        cell.messageLabel.text = d["text"] as! String
        let timestamp = d["time"] as! Timestamp
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        let convertedDate = dateFormatter.string(from: timestamp.dateValue())
        cell.timestampLabel.text = convertedDate
        
        return cell
    }
   

    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
