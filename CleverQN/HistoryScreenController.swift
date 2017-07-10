//
//  HistoryController.swift
//  CleverApp
//
//  Created by Quoc Nguyen on 6/8/17.
//  Copyright © 2017 Rynan. All rights reserved.
//

import UIKit

class HistoryScreenController: UIViewController {

    var historyArr: [String] = ["History", "Filter History By Date"]
    var syncArr: [String] = ["Last Sync", "Sync With Cloud"]
    var syncButton: UIButton?
    var timeLabel: UILabel?
    var iSyncing: Bool = false
    @IBOutlet weak var lbSync: UILabel!
    @IBOutlet weak var tblHistory: UITableView!
    @IBOutlet weak var tblSync: UITableView!
    @IBOutlet weak var cstHeightOfTblHistory: NSLayoutConstraint!
    @IBOutlet weak var cstHeightOfTblSync: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tblHistory.dataSource = self
        tblHistory.delegate = self
        tblSync.dataSource = self
        tblSync.delegate = self
        
        tblHistory.layer.cornerRadius = 10
        tblSync.layer.cornerRadius = 10
        lbSync.text = "○ Please wait during synchronization. \n○ Synchronization will be interrupted if you switch to another interface."
    }
}

extension HistoryScreenController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (tableView == tblHistory) {
            self.cstHeightOfTblHistory.constant = CGFloat(historyArr.count * 44)
            return historyArr.count
        } else {
            self.cstHeightOfTblSync.constant = CGFloat(syncArr.count * 44)
            return syncArr.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        if (tableView == tblHistory) {
            cell.textLabel?.text = historyArr[indexPath.row]
            
            // cell.detailTextLabel?.font = UIFont.systemFont(ofSize: 20)
            cell.accessoryType = .disclosureIndicator
            return cell
            
        } else {
//            cell.accessoryType = .none
            if (syncArr[indexPath.row] == "Last Sync") {
                timeLabel = UILabel()
                timeLabel?.frame = CGRect(x: 0, y: 0, width: 175, height: 25)
                timeLabel?.text = "Jun 09, 2017 14:23:32"
                timeLabel?.textColor = .red
                cell.accessoryView = timeLabel!
            }

            if (syncArr[indexPath.row] == "Sync With Cloud") {
                syncButton = UIButton(type: .custom)
                syncButton?.frame = CGRect(x: 10, y: 0, width: 30, height: 30)
                syncButton?.addTarget(self, action: #selector(HistoryScreenController.syncTap), for: .touchUpInside)
                syncButton?.setImage(UIImage(named: "ic_sync"), for: .normal)
                cell.accessoryView = syncButton!
            }
            cell.textLabel?.text = syncArr[indexPath.row]
            return cell
        }
    }
    
    func startSync() {
        iSyncing = !iSyncing
        if (iSyncing) {
            self.syncButton?.startRotation(duration: 2)
        } else {
            self.syncButton?.stopRotation()
            
            let dateFormatter = DateFormatter()
            let calendar = Calendar.current
            let components = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: Date())
            let finalDate = calendar.date(from: components)
            dateFormatter.dateFormat = "MMM dd, yyyy HH:mm:ss"
            
            let syncDate = dateFormatter.string(from: finalDate!)
            print(syncDate)
            
            timeLabel?.text = "tessst"
            tblSync.reloadData()
        }
    }
    
    func syncTap() { startSync() }
}

extension HistoryScreenController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if (tableView == tblHistory) {
            // chọn row xong mờ selected đi
            tableView.deselectRow(at: indexPath, animated: true)
            if (historyArr[indexPath.row] == "History") {
                
                let history = storyboard?.instantiateViewController(withIdentifier: "TableHistory")
                navigationController?.pushViewController(history!, animated: true)
            }
        } else {
            tableView.deselectRow(at: indexPath, animated: true)
            if (syncArr[indexPath.row] == "Sync With Cloud") {
                
//                self.syncButton!.transform = (self.syncButton?.transform.rotated(by: CGFloat(Double.pi*2)))!
                startSync()
            }
        }
    }
}
