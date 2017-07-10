//
//  HistoryCell.swift
//  CleverApp
//
//  Created by Quoc Nguyen on 6/28/17.
//  Copyright © 2017 Rynan. All rights reserved.
//

import UIKit

class HistoryCell: UITableViewCell {

    @IBOutlet weak var lblNumber: UILabel!
    @IBOutlet weak var lblDateTime: UILabel!
    @IBOutlet weak var lblUser: UILabel!
    @IBOutlet weak var lblAction: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
