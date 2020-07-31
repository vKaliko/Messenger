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
import FirebaseMessaging

class ChatViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    var chat: Chat!
    let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBarController?.tabBar.isHidden = true
        self.navigationController?.navigationBar.prefersLargeTitles = false
        textView.delegate = self
        
        title = chat.displayTitle //?? names
        textView.layer.cornerRadius = 7
        textView.clipsToBounds = true
        textView.layer.borderColor = UIColor.lightGray.cgColor
        textView.layer.borderWidth = 0.5
        let config = UIImage.SymbolConfiguration(textStyle: .title1)
        let arrowUp = UIImage(systemName: "arrow.up.circle.fill", withConfiguration: config)
        sendButton.setImage(arrowUp, for: .normal)
    
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        if chat.messages.count >= 1 {
            let indexPath = IndexPath(row: chat.messages.count-1, section: 0)
            tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
        }
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
        let isMessageFromCurrentUser = Auth.auth().currentUser?.uid == message.uid
        let reuseId = isMessageFromCurrentUser ? "MessageCell" : "ImageMessageCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseId, for: indexPath) as! MessageCell
        cell.messageLabel.text = message.text
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        let convertedDate = dateFormatter.string(from: message.time)
        if isMessageFromCurrentUser {
            cell.usernameLabel.text = convertedDate
        }
        else {
            for profile in Profile.allProfiles {
                if profile.id == message.uid {
                    let name = profile.displayName ?? profile.email
                    if let photo = profile.photo {
                        cell.profileImageView?.isHidden = false
                        cell.twoLettersLabel?.isHidden = true
                        cell.profileImageView?.image = photo
                    }
                    else {
                        cell.profileImageView?.isHidden = true
                        cell.twoLettersLabel?.isHidden = false
                        let wordArray = name.split(separator: " ")
                        if wordArray.count >= 2 {
                         cell.twoLettersLabel?.text = String(wordArray[0][wordArray[0].startIndex]) + String(wordArray[1][wordArray[1].startIndex])
                        }
                        else {
                         cell.twoLettersLabel?.text = String(name[name.startIndex])
                        }
                    }
                    cell.usernameLabel.text = name + " - " + convertedDate
                    break
                }
            }
        }
        return cell
    }
   
    @IBAction func send() {
        guard let text = textView.text, text.count > 0 else {
            return
        }
        guard let user = Auth.auth().currentUser else {
            return
        }
        let message = Message(text: text, time: Date(), uid: user.uid)
        chat.messages.append(message)
        textView.text = ""
        tableView.reloadData()
        let indexPath = IndexPath(row: chat.messages.count-1, section: 0)
        tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
        let db = Firestore.firestore()
        db.collection("chatswuids").document(chat.id).setData(chat.toDict())
    }
    
    func textViewDidChange(_ textView: UITextView) {
        updateSendButton()
    }
        
    func updateSendButton() {
        sendButton.isEnabled = !textView.text.isEmpty
    }
    
    @IBAction func ChatInfoButton(_ sender: Any) {
        let alert = UIAlertController(title: "Edit Chat Title", message: nil, preferredStyle: .alert)
        
        alert.addTextField()
        alert.textFields![0].text = chat.title
        let submitAction = UIAlertAction(title: "Add", style: .default) { [unowned alert] _ in
            guard let title = alert.textFields![0].text, title.count > 0 else {
                return
            }
            self.db.collection("chatswuids").document(self.chat.id).updateData(["title": title]){ err in
                if let err = err {
                    print("Error writing document: \(err)")
                }
            }
            

            // do something interesting with "answer" here
        }
        chat.title = title!
        alert.addAction(UIAlertAction(title: NSLocalizedString("Cancel", comment: "Default action"), style: .default, handler: { _ in
        NSLog("The \"OK\" alert occured.")
        }))
        alert.addAction(submitAction)
        self.present(alert, animated: true, completion: nil)
        
    }
    
    
    @objc func keyboardWillChange(notification: Notification) {
        print("Keyboard will show: \(notification.name.rawValue)")
        guard let keyboardRect = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
            return
        }
        
        if notification.name == UIResponder.keyboardWillHideNotification {
            bottomConstraint.constant = 15
        }
        else {
            bottomConstraint.constant = keyboardRect.height - view.safeAreaInsets.bottom + 15
        }
        
        UIView.animate(withDuration: 0, delay: 0, options: .curveEaseOut, animations: {
            self.view.layoutIfNeeded()
        }) { (completed) in
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        textView.endEditing(true)
    }
}
