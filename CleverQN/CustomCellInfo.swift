//
//  CustomCellInfo.swift
//  CleverApp
//
//  Created by Quoc Nguyen on 6/13/17.
//  Copyright © 2017 Rynan. All rights reserved.
//

import UIKit

class CustomCellInfo: UITableViewCell {
    
    @IBOutlet weak var lbInfoLock: UILabel!
    @IBOutlet weak var lbDetailLock: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
