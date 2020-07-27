//
//  ChatsCell.swift
//  Messenger
//
//  Created by Ilia Kaliko on 7/24/20.
//  Copyright © 2020 Obsessive Coders, Inc. All rights reserved.
//

import UIKit

class ChatsCell: UITableViewCell {
    
    @IBOutlet weak var chatImageView: UIImageView?
    @IBOutlet weak var chatTwoLettersLabel: UILabel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        if chatImageView != nil {
            chatImageView!.layer.cornerRadius = chatImageView!.bounds.size.width / 2
            chatImageView!.clipsToBounds = true
        }
        if chatTwoLettersLabel != nil {
            chatTwoLettersLabel!.layer.cornerRadius = chatTwoLettersLabel!.bounds.size.width / 2
            chatTwoLettersLabel!.layer.masksToBounds = true
        }    }

}
