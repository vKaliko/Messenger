//
//  Chat.swift
//  Messenger
//
//  Created by Ilia Kaliko on 3/8/20.
//  Copyright © 2020 Obsessive Coders, Inc. All rights reserved.
//

import Foundation
import Firebase
import FirebaseFirestore

class Chat: Codable {
    
    var id: String
    var title: String
    var messages: [Message]
    
    init(dict: [String : Any], id: String) {
        self.id = id
        self.title = dict["title"] as! String
        let dicts = dict["messages"] as! [[String : Any]]
        self.messages = [Message]()
        for d in dicts {
            let message = Message(dict: d)
            self.messages.append(message)
        }
        self.messages.sort { (m1, m2) -> Bool in
            return m1.time < m2.time
        }
    }
    
    init(_ title: String, id: String) {
        self.title = title
        self.id = id
        self.messages = [Message]()
    }
    
    func toDict() -> [String : Any] {
        var dicts = [[String : Any]]()
        for message in self.messages {
            dicts.append(message.toDict())
        }
        let dict = ["title" : self.title, "messages" : dicts] as [String : Any]
        return dict
    }
    
    
    
}

class Message: Codable {
    
    var text: String
    var time: Date
    var uid: String
    
    init(dict: [String : Any]) {
        self.text = dict["text"] as! String
        let timestamp = dict["time"] as! Timestamp
        self.time = timestamp.dateValue()
        self.uid = dict["uid"] as! String
    }
    
    init(text: String, time: Date, uid: String) {
        self.text = text
        self.time = time
        self.uid = uid
    }
    
    func toDict() -> [String : Any] {
        let timestamp = Timestamp(date: self.time)
        let dict = ["text" : self.text, "time" : timestamp, "uid" : self.uid] as [String : Any]
        return dict
    }
}

class Profile {
    static var allProfiles: [Profile]!
    var id: String
    var email: String
    var displayName: String?
    var photoUrl: String?
    var photo: UIImage?

    
    init(dict: [String : Any], id: String) {
        self.id = id
        self.displayName = dict["displayName"] as? String
        self.email = dict["email"] as! String
        self.photoUrl = dict["photoUrl"] as? String
    }
}

