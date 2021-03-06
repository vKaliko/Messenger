//
//  Extensions.swift
//  Messenger
//
//  Created by Vanya Kaliko on 06.04.2020.
//  Copyright © 2020 Obsessive Coders, Inc. All rights reserved.
//

import UIKit
import Foundation

class PaddingLabel: UILabel {

    let padding: UIEdgeInsets

    // Create a new PaddingLabel instance programamtically with the desired insets
    required init(padding: UIEdgeInsets = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)) {
        self.padding = padding
        super.init(frame: CGRect.zero)
    }

    // Create a new PaddingLabel instance programamtically with default insets
    override init(frame: CGRect) {
        padding = UIEdgeInsets.zero // set desired insets value according to your needs
        super.init(frame: frame)
    }

    // Create a new PaddingLabel instance from Storyboard with default insets
    required init?(coder aDecoder: NSCoder) {
        padding = UIEdgeInsets(top: 2, left: 5, bottom: 2, right: 5) // set desired insets value according to your needs
        super.init(coder: aDecoder)
    }

    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: padding))
    }

    // Override `intrinsicContentSize` property for Auto layout code
    override var intrinsicContentSize: CGSize {
        let superContentSize = super.intrinsicContentSize
        let width = superContentSize.width + padding.left + padding.right
        let heigth = superContentSize.height + padding.top + padding.bottom
        return CGSize(width: width, height: heigth)
    }

    // Override `sizeThatFits(_:)` method for Springs & Struts code
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        let superSizeThatFits = super.sizeThatFits(size)
        let width = superSizeThatFits.width + padding.left + padding.right
        let heigth = superSizeThatFits.height + padding.top + padding.bottom
        return CGSize(width: width, height: heigth)
    }

}

@IBDesignable class CircleImageView: UIImageView {
    
//    override internal var frame: CGRect {
//        set {
//            super.frame = newValue
//            self.clipsToBounds = true
//            self.layer.cornerRadius = self.bounds.size.width / 2
//        }
//        get {
//            return super.frame
//        }
//    }
}
