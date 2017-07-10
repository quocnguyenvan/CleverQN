//
//  ModalViewController.swift
//  SwiftCustomPresentation
//
//  Created by Quoc Nguyen on 6/19/17.
//  Copyright © 2017 Rynan. All rights reserved.
//

import UIKit

class ModalViewController: UIViewController {

    @IBAction func dismissModal(_ sender: UISwipeGestureRecognizer) {
        dismiss(animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()

    }

}
