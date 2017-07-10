//
//  CustomCellUserManger.swift
//  CleverApp
//
//  Created by Quoc Nguyen on 6/12/17.
//  Copyright © 2017 Rynan. All rights reserved.
//

import UIKit

class CustomCellUserManager: UITableViewCell {

    
    @IBOutlet weak var viewImage: UIView!
    @IBOutlet weak var imgUser: UILabel!
    @IBOutlet weak var lbName: UILabel!
    @IBOutlet weak var lbPermission: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        viewImage.layer.masksToBounds = false
        viewImage.layer.cornerRadius = viewImage.frame.size.width / 2
        viewImage.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
}
