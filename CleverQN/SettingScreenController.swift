//
//  SettingScreenController.swift
//  CleverApp
//
//  Created by Quoc Nguyen on 6/7/17.
//  Copyright © 2017 Rynan. All rights reserved.
//

import UIKit
import UserNotifications

class SettingScreenController: UIViewController {

    let settingMenu: [String] = ["RENAME LOCK", "DATE & TIME", "CALIBRATE", "SECURITY", "FACTORY RESET"]
    @IBOutlet weak var tblSetting: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    func showDateTime() {
        
        let myDatePicker: UIDatePicker = UIDatePicker()
        myDatePicker.timeZone = NSTimeZone.local
        myDatePicker.frame = CGRect(x: 10, y: 10, width: 250, height: 200)
        
        let alertController = UIAlertController(title: "\n\n\n\n\n\n\n\n", message: nil, preferredStyle: .alert)
        alertController.view.addSubview(myDatePicker)
        
        let okAction = UIAlertAction(title: "OK", style: .default) {
            [unowned self] action in
            print(self)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion:{})
    }
    
    func showDateTimeDialog() {
        let modal = DateTimeDialogController()
        modal.modalPresentationStyle = .overCurrentContext
        modal.modalTransitionStyle = .crossDissolve
        
        present(modal, animated: true, completion: nil)
        
//        let popOverVC = DateTimeDialogController()
//        self.addChildViewController(popOverVC)
//        popOverVC.view.frame = self.view.frame
//    
//        self.view.addSubview(popOverVC.view)
//        popOverVC.didMove(toParentViewController: self)
    }
    
    func showNameDialog() {
        let modal = NameDialogController()
        modal.modalPresentationStyle = .overCurrentContext
        modal.modalTransitionStyle = .crossDissolve
        present(modal, animated: true, completion: nil)
    }
}

extension SettingScreenController: UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settingMenu.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        cell.textLabel?.text = settingMenu[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}

extension SettingScreenController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch settingMenu[indexPath.row] {
            case "DATE & TIME":
                showDateTimeDialog()
                break
            
            case "RENAME LOCK":
                showNameDialog()
            
            case "SECURITY":
                let vc = storyboard?.instantiateViewController(withIdentifier: "RegisterLock") as! RegisterLock
                navigationController?.pushViewController(vc, animated: true)
        default:
            print("^_^")
        }
    }
}
