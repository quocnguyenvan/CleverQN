//
//  UserCell.swift
//  CleverApp
//
//  Created by Quoc Nguyen on 6/6/17.
//  Copyright © 2017 Rynan. All rights reserved.
//

import UIKit

class UserCell: UITableViewCell {

    @IBOutlet weak var imgUser: UIImageView!
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var lblPermission: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        imgUser.layer.borderWidth = 0.5
        imgUser.layer.masksToBounds = false
        imgUser.layer.borderColor = UIColor.white.cgColor
        imgUser.layer.cornerRadius = imgUser.frame.size.width/2
        imgUser.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
//        self.frame  = CGRect(x: 0, y: 0, width : 300 , height: 300);
        //option 2
        // self.bounds  = CGRectMake( 100,0, 100 , 100);//calculate centre
    }

}
