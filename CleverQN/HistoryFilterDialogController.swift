//
//  HistoryFilterController.swift
//  CleverApp
//
//  Created by Quoc Nguyen on 6/28/17.
//  Copyright © 2017 Rynan. All rights reserved.
//

import UIKit

class HistoryFilterDialogController: UIViewController {

    @IBOutlet weak var dateStart: UIDatePicker!
    @IBOutlet weak var dateEnd: UIDatePicker!
    
    @IBOutlet weak var dialogView: UIView!
    @IBAction func close(_ sender: UIButton) {
        self.removeAnimate()
    }
    
    @IBAction func btnSave(_ sender: UIButton) {
        self.removeAnimate()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        self.dialogView.layer.cornerRadius = 5
        self.showAnimate()
        self.view.isOpaque = false
        self.dialogView.layer.cornerRadius = 5

//        dateStart.minimumDate = Calendar.current.date(byAdding: .year, value: 15, to: Date())
//        dateStart.maximumDate = Calendar.current.date(byAdding: .year, value: -15, to: Date())
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
                // self.view.removeFromSuperview()
            }
        })
    }
}
