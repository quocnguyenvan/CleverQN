//
//  RegisterLock.swift
//  CleverApp
//
//  Created by Quoc Nguyen on 6/27/17.
//  Copyright © 2017 Rynan. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField

class RegisterLock: UIViewController {

    @IBOutlet weak var lblRequired: UILabel!
    @IBOutlet weak var btnCheckBox: UIButton!
    @IBOutlet weak var txtUserName: SkyFloatingLabelTextField!
    @IBOutlet weak var txtEmail: SkyFloatingLabelTextField!
    @IBOutlet weak var txtPhone: SkyFloatingLabelTextField!
    @IBOutlet weak var txtPasscode: SkyFloatingLabelTextField!
    @IBOutlet weak var txtConfirmPass: SkyFloatingLabelTextField!
    
    var timer: Timer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Setup Adminstrator"
        
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "arrow_back"), for: .normal)
        button.frame = CGRect(x: 0, y: 0, width: 25, height: 25)
        button.addTarget(self, action: #selector(tapBack), for: .touchUpInside)
        let back = UIBarButtonItem(customView: button)
        navigationItem.setLeftBarButton(back, animated: true)
        
        let done = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(tapDone))
        self.navigationItem.rightBarButtonItem = done
        self.navigationItem.rightBarButtonItem?.isEnabled = false
        
        btnCheckBox.setBackgroundImage(UIImage(named: "unchecked"), for: .normal)
        btnCheckBox.setBackgroundImage(UIImage(named: "checked"), for: .selected)
        startTimer()
        
        txtUserName.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: .editingChanged)
        txtEmail.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: .editingChanged)
        txtPhone.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: .editingChanged)
        txtPasscode.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: .editingChanged)
        txtConfirmPass.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: .editingChanged)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.barTintColor = UIColor.black
        self.navigationController!.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
    }
    
    func tapDone() {
        print("done!")
    }
    
    func tapBack() {
        navigationController?.popViewController(animated: true)
    }
    
    func textFieldDidChange(textField: UITextField) {
        if (txtUserName.text != "" || txtEmail.text != "" || txtPhone.text != "" || txtPasscode.text != "" || txtConfirmPass.text != "") {
            self.navigationItem.rightBarButtonItem?.isEnabled = true
        } else {
            self.navigationItem.rightBarButtonItem?.isEnabled = false
        }
    }
    
    func setActiveDone(enable: Bool) {
        if (enable) {
            self.navigationItem.rightBarButtonItem?.isEnabled = true
        } else {
            self.navigationItem.rightBarButtonItem?.isEnabled = false
        }
    }
    
    func startTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1.2, target: self, selector: #selector(fade), userInfo: nil, repeats: true)
    }
    
    func fade() {
        lblRequired.isHidden = !lblRequired.isHidden
    }
    
    @IBAction func tapCheckBox(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        
        if (sender.isSelected == true) {
            lblRequired.isHidden = true
            timer.invalidate()
        } else {
            lblRequired.isHidden = false
            startTimer()
        }
    }
}
