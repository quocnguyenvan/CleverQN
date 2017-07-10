//
//  CustomCellUser.swift
//  CleverApp
//
//  Created by Quoc Nguyen on 6/9/17.
//  Copyright © 2017 Rynan. All rights reserved.
//

import UIKit

protocol AvatarImageDelegate {
    func tapAvatar()
}

class CustomCellUser: UITableViewCell {
    
    var avatarImageDelegate: AvatarImageDelegate?
    @IBOutlet weak var imgAvatar: UIImageView!
    @IBOutlet weak var lbCurrentUser: UILabel!
    @IBOutlet weak var lbUserName: UILabel!
    @IBOutlet weak var lbPermission: UILabel!
    
    @IBAction func tapImgAvatar(_ sender: UITapGestureRecognizer) {
        if let delegate = avatarImageDelegate {
            delegate.tapAvatar()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        imgAvatar.layer.borderWidth = 0.5
        imgAvatar.layer.masksToBounds = false
        imgAvatar.layer.borderColor = UIColor.white.cgColor
        imgAvatar.layer.cornerRadius = imgAvatar.frame.size.width / 2
        imgAvatar.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
}
