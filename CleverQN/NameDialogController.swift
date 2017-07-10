//
//  NameDialogController.swift
//  CleverApp
//
//  Created by Quoc Nguyen on 6/26/17.
//  Copyright © 2017 Rynan. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField

class NameDialogController: UIViewController, UITextFieldDelegate {

    
    @IBOutlet weak var dialogView: UIView!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var textFieldName: UITextField!
    
    var timer: Timer!
    var characterTotal: Int = 16
    @IBAction func btnClose(_ sender: UIButton) {
        self.removeAnimate()
    }
    
    @IBAction func btnDone(_ sender: UIButton) {
        self.removeAnimate()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.textFieldName.delegate = self
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        self.dialogView.layer.cornerRadius = 5
        self.showAnimate()
        textFieldName.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: .editingChanged)
    }
    
    override func viewWillAppear(_ animated: Bool) {
//        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(decreaseTime), userInfo: nil, repeats: true)
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
            }
        })
    }
    
//    func decreaseTime() {
//        timeTotal -= 1
//        self.lblTime.text = "[\(timeTotal)]"
//        if (timeTotal == 0) {
//            timer.invalidate()
//        }
//    }
    
    func textFieldDidChange(textField: UITextField){
        if (textField.count < 17) {
            lblTime.text = "[\(characterTotal - textField.count)]"
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentCharacterCount = textField.text?.characters.count ?? 0
        if (range.length + range.location > currentCharacterCount) {
            return false
        }
        let newLength = currentCharacterCount + string.characters.count - range.length
        return newLength < 17
    }
}

extension UITextField {
    var count:Int {
        get{
            return self.text?.characters.count ?? 0
        }
    }
}
