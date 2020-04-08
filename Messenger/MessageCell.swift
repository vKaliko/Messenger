//
//  MessageCell.swift
//  
//
//  Created by Vanya Kaliko on 05.03.2020.
//

import UIKit

class MessageCell: UITableViewCell {
    
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        messageLabel.layer.cornerRadius = 5
        messageLabel.clipsToBounds = true
    }
}


class ImageMessageCell: MessageCell {
    @IBOutlet weak var profileImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        profileImageView.layer.cornerRadius = bounds.size.width / 2
        profileImageView.clipsToBounds = true
    }
}



