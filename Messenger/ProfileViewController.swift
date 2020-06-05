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

class ProfileViewController: UITableViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var doneButton: UIBarButtonItem!
    @IBOutlet weak var profilePhotoImageView: UIImageView!
    
    let db = Firestore.firestore()
    var imagePicker = UIImagePickerController()
    var profile:Profile!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        updateDoneButton()
        //navigationItem.rightBarButtonItem = nil
        Auth.auth().addStateDidChangeListener { (auth, user) in
            if let user = user {
                print("profilevc. Login change listener user = \(user)")
                self.requestProfile(user.uid)
            }
        }
        profilePhotoImageView.layer.cornerRadius = profilePhotoImageView.frame.width / 2
        profilePhotoImageView.clipsToBounds = true
        
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        dismiss(animated: true, completion: nil)
        guard let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else {
            return
        }
        profilePhotoImageView.image = image
        profile.photo = image
        let storage = Storage.storage()
        let storageRef = storage.reference()
        let profilePhotos = storageRef.child("images/\(profile.id).png")
        guard let data = image.pngData() else {
            return
        }
        profilePhotos.putData(data, metadata: nil) { (metadata, error) in
            if let error = error {
                print("Error: \(error)")
                return
            }
            profilePhotos.downloadURL { (url, error) in
                guard let downloadURL = url else {
                  return
                }
                self.profile.photoUrl = downloadURL.absoluteString
                self.db.collection("profiles").document(self.profile.id).updateData([
                    "photoUrl": self.profile.photoUrl
                ]) { err in
                    if let err = err {
                        print("Error updating document: \(err)")
                    }
                }
            }
        }
    }

    @IBAction func done() {
        if textField.text?.count != 0 {
            guard let uid = Auth.auth().currentUser?.uid else {
                return
            }
            profile.displayName = textField.text
            db.collection("profiles").document(uid).updateData(["displayName": profile.displayName]){ err in
                if let err = err {
                    print("Error writing document: \(err)")
                }
            }
        }
    }
    
    @IBAction func editButtonAction() {
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func textDidChange(_ sender: UITextField) {
        //navigationItem.rightBarButtonItem
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
                if let dict = document.data() {
                    self.profile = Profile(dict: dict, id: uid)
                    self.textField.text = self.profile.displayName
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
