//
//  LoginScreenController.swift
//  CleverApp
//
//  Created by Quoc Nguyen on 6/6/17.
//  Copyright © 2017 Rynan. All rights reserved.
//

import UIKit
import Spring

class LoginScreenController: UIViewController {

    var userName: String = ""
    @IBOutlet weak var txtUsername: CustomTextField!
    @IBOutlet weak var txtPassword: CustomTextField!
    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var iconChange: SpringImageView!
    @IBOutlet weak var centerAlignUsername: NSLayoutConstraint!
    @IBOutlet weak var centerAlignPassword: NSLayoutConstraint!
    
    var tap: Bool = false
    
    @IBAction func btnChangePassTap(_ sender: UIButton) {
        tap = !tap
        if(tap) {
//            self.iconChange.startRotation(toValue: Double.pi, duration: 1.5, repeatCount: 0, clockwise: false)
            UIView.animate(
                withDuration: 0.5,
                animations: {
                    self.iconChange.transform = self.iconChange.transform.rotated(by: CGFloat(Double.pi/2))
            },
            completion: nil)
            
        } else {
            UIView.animate(
                withDuration: 0.5,
                animations: {
                    self.iconChange.transform = self.iconChange.transform.rotated(by: CGFloat(-Double.pi/2))
            },
            completion: nil)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        btnLogin.layer.cornerRadius = 3
        btnCancel.layer.cornerRadius = 3
        txtUsername.text = userName
        
        NotificationCenter.default.addObserver(self, selector: #selector(LoginScreenController.keyboardWillShow), name:NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(LoginScreenController.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
        
//        self.txtUsername.center.y -= self.view.bounds.width
//        self.txtPassword.center.x -= self.view.bounds.width
//        centerAlignUsername.constant -= view.bounds.width
//        centerAlignPassword.constant -= view.bounds.width
        
        btnLogin.alpha = 0.0
        btnCancel.alpha = 0.0
    }
    // slideUp
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        
//        UIView.animate(withDuration: 2, delay: 0.5, options: .curveEaseOut, animations: {
//            self.centerAlignUsername.constant += self.view.bounds.width
//            self.view.layoutIfNeeded()
//        }, completion: nil)
//        
//        UIView.animate(withDuration: 3, delay: 0.7, options: .curveEaseOut, animations: {
//            self.centerAlignPassword.constant += self.view.bounds.width
//            self.view.layoutIfNeeded()
//        }, completion: nil)
        
        UIView.animate(
            withDuration: 0.5,
            animations: {
                self.btnLogin.alpha = 1.0
            },
        completion: nil)
        
        UIView.animate(
            withDuration: 0.65,
            animations: {
                self.btnCancel.alpha = 1.0
        },
        completion: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    @IBAction func btnLoginTap(_ sender: UIButton) {
        Login()
    }
    
    @IBAction func btnCancelTap(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func Login() {
//        guard let username = txtUsername.text, userName != "" else { return }
        let message = UserScreenController()
        guard let passcode = txtPassword.text else { return }
        
        if(passcode == "") {
            message.showMessage(content: "Vui lòng nhập mật khẩu!", theme: .error, duration: 0.8)
        } else if (passcode == "123") {
            let panel = storyboard?.instantiateViewController(withIdentifier: "Panel") as! PanelController
            navigationController?.pushViewController(panel, animated: true)
        } else {
            message.showMessage(content: "Mật khẩu không chính xác!", theme: .error, duration: 0.8)
        }
    }
    
    func keyboardWillShow(notification: NSNotification) {
        if (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue != nil{
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= 120
            }
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue != nil{
            self.view.frame.origin.y = 0
        }
    }
}
