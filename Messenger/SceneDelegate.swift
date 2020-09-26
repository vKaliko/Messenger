//
//  SceneDelegate.swift
//  Messenger
//
//  Created by Vanya Kaliko on 02.03.2020.
//  Copyright © 2020 Obsessive Coders, Inc. All rights reserved.
//

import UIKit
import Firebase

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    var db: Firestore!

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
       
//        db = Firestore.firestore()
//        let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as! String
//
//        self.window = UIWindow(frame: UIScreen.main.bounds)
//        let launchStoryboard: UIStoryboard = UIStoryboard(name: "LaunchScreen", bundle: nil)
//        let launchViewController = launchStoryboard.instantiateViewController(withIdentifier: "LaunchViewController")
//        self.window?.rootViewController = launchViewController
//        self.window?.makeKeyAndVisible()
        
//        let docRef = db.collection("info").document("version")
//        docRef.getDocument { (document, error) in
//            if let document = document, document.exists {
//                let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
//                print("Document data: \(dataDescription)")
//                if appVersion == dataDescription {
//                    print("Don't need the update")
//                }
//                else {
//                    let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
//                    let updateViewController = storyboard.instantiateViewController(withIdentifier: "Profile") as! ProfileViewController
//                    self.window?.rootViewController = launchViewController
//                    self.window?.makeKeyAndVisible()
//                    print("I need to update")
//                }
//            }
//            else {
//                print("Document does not exist")
//            }
//
//        }
//        self.window = self.window ?? UIWindow()
//       let launchStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
//       let launchViewController = launchStoryboard.instantiateViewController(withIdentifier: "Profile") as! ProfileViewController
//        self.window?.rootViewController = launchViewController

        // Create a ViewController object and_cene's window's root view controller.

        // Make this scene's window be visible.
//        self.window!.makeKeyAndVisible()

        guard scene is UIWindowScene else { return }
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not neccessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}

