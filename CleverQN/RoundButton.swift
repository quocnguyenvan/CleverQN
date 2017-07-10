//
//  RoundButton.swift
//  CleverApp
//
//  Created by Quoc Nguyen on 6/13/17.
//  Copyright © 2017 Rynan. All rights reserved.
//

import UIKit

@IBDesignable
class RoundButton: UIButton {

    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            self.layer.cornerRadius = cornerRadius
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 0 {
        didSet {
            self.layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable var borderColor: UIColor? = UIColor.clear {
        didSet {
            self.layer.borderColor = borderColor?.cgColor
        }
    }
}
