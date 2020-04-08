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

class ChatViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    var chat: Chat!
    var profiles: [Profile]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = chat.title
        textView.layer.cornerRadius = 7
        textView.clipsToBounds = true
        textView.layer.borderColor = UIColor.lightGray.cgColor
        textView.layer.borderWidth = 0.5
    }
    // MARK: - Table view data source

    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chat.messages.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message = chat.messages[indexPath.row]
        let reuseId = Auth.auth().currentUser?.uid == message.uid ? "MessageCell" : "ImageMessageCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseId, for: indexPath) as! MessageCell
        cell.messageLabel.text = message.text
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        let convertedDate = dateFormatter.string(from: message.time)
        for profile in profiles {
            if profile.id == message.uid {
               cell.usernameLabel.text = profile.name + " - " + convertedDate
               break
            }
        }
        return cell
    }
   
    @IBAction func send() {
        guard let text = textView.text else {
            return
        }
        guard let user = Auth.auth().currentUser else {
            return
        }
        let message = Message(text: text, time: Date(), uid: user.uid)
        chat.messages.append(message)
        let db = Firestore.firestore()
        db.collection("chats").document(chat.id).setData(chat.toDict())
        tableView.reloadData()
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

