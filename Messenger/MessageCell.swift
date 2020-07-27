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
    @IBOutlet weak var profileImageView: UIImageView?
    @IBOutlet weak var twoLettersLabel: UILabel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        messageLabel.layer.cornerRadius = 5
        messageLabel.clipsToBounds = true
        if profileImageView != nil {
            profileImageView!.layer.cornerRadius = profileImageView!.bounds.size.width / 2
            profileImageView!.clipsToBounds = true
        }
        if twoLettersLabel != nil {
            twoLettersLabel!.layer.cornerRadius = twoLettersLabel!.bounds.size.width / 2
            twoLettersLabel!.layer.masksToBounds = true
        }
    }
}
