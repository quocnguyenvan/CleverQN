//
//  HeaderUser.swift
//  CleverApp
//
//  Created by Quoc Nguyen on 6/12/17.
//  Copyright © 2017 Rynan. All rights reserved.
//

import UIKit

protocol AddDelegate {
    func addPress()
}
class HeaderUser: UIView {
    
    var addButtonDelegate: AddDelegate?
    @IBOutlet weak var userManager: UILabel!
    @IBOutlet weak var imgAddUser: UIImageView!
    
    @IBAction func tapAdd(_ sender: UITapGestureRecognizer) {
        if let delegate = addButtonDelegate {
            delegate.addPress()
        }
    }
}
