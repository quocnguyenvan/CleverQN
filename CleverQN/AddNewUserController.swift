//
//  AddNewUserController.swift
//  CleverApp
//
//  Created by Quoc Nguyen on 6/15/17.
//  Copyright © 2017 Rynan. All rights reserved.
//

import UIKit

protocol AddNewUserDelegate {
    func addNewUser(user: String, pass: String, rePass: String)
//    func disMissView()
}

class AddNewUserController: UIViewController {
    
    var addNewUserDelegate: AddNewUserDelegate?
    
    @IBOutlet weak var txtUserName: CustomTextField!
    @IBOutlet weak var txtPassCode: CustomTextField!
    @IBOutlet weak var txtConfirmPassCode: CustomTextField!
    
    @IBAction func disMiss(_ sender: UIButton) {
        presentingViewController?.dismiss(animated: true)
    }
    
    @IBAction func createAccount(_ sender: UIButton) {
        if let delegate = addNewUserDelegate {
            guard let userName = txtUserName.text else { return }
            guard let passCode = txtPassCode.text else { return }
            guard let confirmPassCode = txtConfirmPassCode.text else { return }
            delegate.addNewUser(user: userName, pass: passCode, rePass: confirmPassCode)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
//    override func viewWillAppear(_ animated: Bool) {
//        self.view.bounds.origin.y -= self.view.bounds.height
//    }
//    
//    override func viewDidAppear(_ animated: Bool) {
//        UIView.animate(
//            withDuration: 0.5,
//            animations: {
//                self.view.bounds.origin.y += self.view.bounds.height
//            },
//            completion: nil
//        )
//    }
    
//    func showAnimate() {
//        self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
//        self.view.alpha = 0.0
//        UIView.animate(withDuration: 0.25, animations: {
//            self.view.alpha = 1.0
//            self.view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
//        })
//    }
    
//    func removeAnimate() {
//        UIView.animate(withDuration: 0.25, animations: {
//            self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
//            self.view.alpha = 0.0
//        }, completion: {(finished : Bool) in
//            if(finished) {
//                self.willMove(toParentViewController: nil)
//                self.view.removeFromSuperview()
//                self.removeFromParentViewController()
//            }
//        })
//    }
}
