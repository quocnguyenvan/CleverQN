//
//  DateTimeDialogController.swift
//  CleverApp
//
//  Created by Quoc Nguyen on 6/26/17.
//  Copyright © 2017 Rynan. All rights reserved.
//

import UIKit

class DateTimeDialogController: UIViewController {

    @IBAction func close(_ sender: UIButton) {
        self.removeAnimate()
    }
    
    @IBOutlet weak var dialogView: UIView!
    @IBOutlet weak var lbDateTime: UILabel!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBAction func btnSave(_ sender: UIButton) {
        self.removeAnimate()
    }
    
    @IBAction func btnRefresh(_ sender: UIButton) {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: Date())
        let finalDate = calendar.date(from: components)
        
        datePicker.setDate(finalDate!, animated: true)
        self.setDateTime()
    }
    
    @IBAction func datePickerChanged(_ sender: UIDatePicker) {
        setDateTime()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        view.backgroundColor = UIColor.clear
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        self.dialogView.layer.cornerRadius = 5
        
        self.showAnimate()
        self.view.isOpaque = false
        self.setDateTime()
    }
    
//    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
//        let label = view as? UILabel == nil ? UILabel() : view as! UILabel
//        
//        label.font = UIFont(name: "Times New Roman", size: 15.0)
//        label.textColor = UIColor.blue
////        label.text = pickerData[row]
//        return label
//    }
    
    func setDateTime() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.medium
        dateFormatter.dateFormat = "MMM dd, yyyy HH:mm:ss"
//        dateFormatter.timeStyle = DateFormatter.Style.medium
        
        let strDate = dateFormatter.string(from: datePicker.date)
        lbDateTime.text = strDate
    }
    
    func showAnimate() {
        self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        self.view.alpha = 0
        UIView.animate(withDuration: 0.25, animations: {
            self.view.alpha = 1.0
            self.view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        })
    }
    
    func removeAnimate() {
        UIView.animate(withDuration: 0.25, animations: {
            self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            self.view.alpha = 0
        }, completion:{(finished : Bool)  in
            if (finished) {
                self.dismiss(animated: false, completion: nil)
//                self.view.removeFromSuperview()
            }
        })
    }
}

extension UIDatePicker {
    func stylizeView(view: UIView? = nil) {
        let view = view ?? self
        for subview in view.subviews {
            if let label = subview as? UILabel {
                if let text = label.text {
                    print("UIDatePicker :: sylizeLabel :: \(text)\n")
                    label.font = UIFont(name: "Times New Roman", size: 13.0)
                    label.textColor = UIColor.blue
                }
            } else { stylizeView(view: subview) }
        }
    }
}
