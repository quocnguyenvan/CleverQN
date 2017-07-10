//
//  SelectLockCell.swift
//  CleverApp
//
//  Created by Quoc Nguyen on 6/5/17.
//  Copyright © 2017 Rynan. All rights reserved.
//

import UIKit

protocol CellDelegate {
    func connectPressed(cell: SelectLockCell)
}

class SelectLockCell: UITableViewCell {

    @IBOutlet weak var imgWifi: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblIP: UILabel!
    
    var btnConnectDelegate: CellDelegate?
    
    @IBOutlet weak var btnConnect: UIButton!
    @IBAction func pressConnect(_ sender: UIButton) {
        if let delegate = btnConnectDelegate {
            delegate.connectPressed(cell: self)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        btnConnect.layer.cornerRadius = 5
        btnConnect.layer.borderWidth = 1
        btnConnect.layer.borderColor = appDelegate.uiColorFromHex(rgbValue: 0x78ccdd).cgColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
