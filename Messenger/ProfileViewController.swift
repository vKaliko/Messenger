//
//  ProfileViewController.swift
//  Messenger
//
//  Created by Vanya Kaliko on 31.03.2020.
//  Copyright © 2020 Obsessive Coders, Inc. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseUI
import FirebaseFirestore

class ProfileViewController: UITableViewController {
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var doneButton: UIBarButtonItem!
    
    let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateDoneButton()
        let handle = Auth.auth().addStateDidChangeListener { (auth, user) in
            if let user = user {
                print("profilevc. Login change listener user = \(user)")
                self.requestProfile(user.uid)
            }
        }
    }

    @IBAction func done() {
        if textField.text?.count != 0 {
            guard let uid = Auth.auth().currentUser?.uid else {
                return
            }
            let dict = ["name" : textField.text]
            db.collection("profiles").document(uid).setData(dict) { err in
                if let err = err {
                    print("Error writing document: \(err)")
                }
                else {
                    print("Document successfully written!")
                }
            }
        }
        else {
            
        }
    }
    
    @IBAction func textDidChange(_ sender: UITextField) {
        updateDoneButton()
    }
    
    func updateDoneButton() {
        if let text = textField.text, !text.isEmpty {
            doneButton.isEnabled = true
        }
        else {
            doneButton.isEnabled = false
        }
    }
    
    func requestProfile(_ uid: String) {
        let docRef = db.collection("profiles").document(uid)

        docRef.getDocument { (document, error) in
            if let document = document {
                if let dict = document.data(), let name = dict["name"] {
                    self.textField.text = name as! String
                }
            }
            else {
                print("Document does not exist: \(error)")
            }
        }
    }
    
    @IBAction func logOut() {
        guard let authUI = FUIAuth.defaultAuthUI() else {
            return
        }
        try! authUI.signOut()
    }

}
