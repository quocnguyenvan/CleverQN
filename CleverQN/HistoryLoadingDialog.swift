//
//  HistoryLoadingDialog.swift
//  CleverApp
//
//  Created by Quoc Nguyen on 6/30/17.
//  Copyright © 2017 Rynan. All rights reserved.
//

import UIKit
import Spring

class HistoryLoadingDialog: UIViewController {

    @IBOutlet weak var dialogView: SpringView!
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var lblProgress: UILabel!
    
    var timer: Timer?
    @IBAction func btnCancel(_ sender: UIButton) {
        removeLoadingDialog()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        self.dialogView.layer.cornerRadius = 5
        self.showAnimate()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
//        self.dialogView.duration = 1.0
//        self.dialogView.animation = "slideLeft"
//        self.dialogView.curve = "easeIn"
//        self.dialogView.animate()
//        timer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(loadingProgress), userInfo: nil, repeats: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) { }
    
    var counter: Int = 0 {
        didSet {
            let fractionalProgress = Float(counter * 2) / 100
            let animated = counter != 0
            print("progress: \(fractionalProgress)")
            progressView.setProgress(fractionalProgress, animated: animated)
            lblProgress.text = ("\(Int(fractionalProgress * 100))%")
            
            if (fractionalProgress == 1.0) {
                self.timer?.invalidate()
//                self.numberArr.reverse()
//                self.animateTable()
                self.removeLoadingDialog()
            }
        }
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
    
    func removeLoadingDialog() {
        //        UIView.animate(withDuration: 0.5, animations: {
        //            self.dialogView.frame.origin.x += self.view.bounds.width * 2
        //        }, completion: nil)
        self.dialogView.duration = 1.5
        self.dialogView.animation = "fadeOut"
        self.dialogView.curve = "easeOut"
        self.dialogView.animate()
    }
    
    func loadingProgress() {
//        self.numberArr.append(self.counter)
        self.counter += 1
    }
}
