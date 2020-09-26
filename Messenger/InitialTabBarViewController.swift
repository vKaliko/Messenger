//
//  InitialTabBarViewController.swift
//  Messenger
//
//  Created by Ilia Kaliko on 8/6/20.
//  Copyright © 2020 Obsessive Coders, Inc. All rights reserved.
//

import UIKit
import Firebase

class InitialTabBarViewController: UITabBarController {
    var db: Firestore!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToUpdateAlertVC" {
            db = Firestore.firestore() 
            let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as! String
            let docRef = db.collection("info").document("version")
            docRef.getDocument { (document, error) in
                if let document = document, document.exists {
                    let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
                    print("Document data: \(dataDescription)")
                    if appVersion == dataDescription {
                        print("Your app is up to date")
                    }
                    else {
                        print("Please update the app")
                    }
                }
                else {
                    print("Document does not exist")
                }
            }
        }
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
