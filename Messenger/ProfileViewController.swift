//
//  ProfileViewController.swift
//  Messenger
//
//  Created by Vanya Kaliko on 31.03.2020.
//  Copyright © 2020 Obsessive Coders, Inc. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore

class ProfileViewController: UITableViewController {
    
    @IBOutlet weak var textField: UITextField!
    
    
    let db = Firestore.firestore()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
}
