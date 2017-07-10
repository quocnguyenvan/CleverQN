//
//  InfoController.swift
//  CleverApp
//
//  Created by Quoc Nguyen on 6/8/17.
//  Copyright © 2017 Rynan. All rights reserved.
//

import UIKit

class InfoScreenController: UIViewController, UIScrollViewDelegate {

    var infoUser: [String] = ["Authentication", "Clever Management"]
    var infoLock: [String] = ["Application", "Software Version", "Firmware Version", "Firmware Date Release", "Hardware Version"]
    var detailLock: [String] = ["Clever Beta", "SPL-CL-V1.0", "SPL-SF-V1.4", "May 09, 2017", "SPL-S-V1.4"]
    
    @IBOutlet weak var tblInfo1: UITableView!
    @IBOutlet weak var tblInfo2: UITableView!
    @IBOutlet weak var cstHeightOfTbl1: NSLayoutConstraint!
    @IBOutlet weak var cstHeightOfTbl2: NSLayoutConstraint!
    
    @IBOutlet weak var cstHeightOfScrollView: NSLayoutConstraint!
    @IBOutlet weak var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tblInfo1.dataSource = self
        tblInfo1.delegate = self
        tblInfo2.dataSource = self
        tblInfo2.allowsSelection = false
//        scrollView.delegate = self
        tblInfo1.layer.cornerRadius = 10
        tblInfo2.layer.cornerRadius = 10
        
//        self.cstHeightOfScrollView.constant = CGFloat(cstHeightOfTbl1.constant + cstHeightOfTbl2.constant + 20)
//        self.scrollView.contentSize = CGSize(width: self.scrollView.contentSize.width, height: 100)
    }
    
//    override func viewDidLayoutSubviews() {
//        print("abc")
//        self.scrollView.translatesAutoresizingMaskIntoConstraints = true
//        self.scrollView.contentSize = CGSize(width: self.scrollView.frame.width, height: 60.0 + 5 * (self.scrollView.frame.width / 16.0 * 5.0))
//    }
}

extension InfoScreenController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (tableView == tblInfo1) {
            self.setHeightOfTbl(num: infoUser.count)
            return infoUser.count
        } else {
            self.cstHeightOfTbl2.constant = CGFloat(infoLock.count * 44)
            return infoLock.count
        }
    }
    
    func setHeightOfTbl(num: Int) {
        self.cstHeightOfTbl1.constant = CGFloat(num * 44)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if (tableView == tblInfo1) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
            cell.textLabel?.text = infoUser[indexPath.row]
            
            // cell.detailTextLabel?.font = UIFont.systemFont(ofSize: 20)
            cell.accessoryType = .disclosureIndicator
            
            return cell
            
        } else {
            let cell = Bundle.main.loadNibNamed("CustomCellInfo", owner: self, options: nil)?.first as! CustomCellInfo
            cell.lbInfoLock.text = infoLock[indexPath.row]
            cell.lbDetailLock.text = detailLock[indexPath.row]
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
//    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? { return "" }
//    
//    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat { return 10 }
}
