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

class Chat {
    
    var title: String
    var messages: [Message]
    
    init(dict: [String : Any]) {
        self.title = dict["title"] as! String
        let dicts = dict["messages"] as! [[String : Any]]
        self.messages = [Message]()
        for d in dicts {
            let message = Message(dict: d)
            self.messages.append(message)
        }
    }
    
    init(_ title: String) {
        self.title = title
        self.messages = [Message]()
    }
}

class Message {
    
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
    
}
