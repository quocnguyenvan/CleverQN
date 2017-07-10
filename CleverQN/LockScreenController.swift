//
//  LockScreenController.swift
//  CleverApp
//
//  Created by Quoc Nguyen on 6/7/17.
//  Copyright © 2017 Rynan. All rights reserved.
//

import UIKit

class LockScreenController: UIViewController {

    let circleLayer = CAShapeLayer()
    var isStarted: Bool = false
    
    @IBOutlet weak var cstHeightBtnLock: NSLayoutConstraint!
    @IBOutlet weak var cstWidthBtnLock: NSLayoutConstraint!
    @IBOutlet weak var cstHeightView3: NSLayoutConstraint!
    @IBOutlet weak var cstWidthView3: NSLayoutConstraint!
    @IBOutlet weak var cstHeightView2: NSLayoutConstraint!
    @IBOutlet weak var cstWidthView2: NSLayoutConstraint!
    @IBOutlet weak var cstHeightView1: NSLayoutConstraint!
    @IBOutlet weak var cstWidthView1: NSLayoutConstraint!
    
    @IBOutlet weak var viewAnimated1: LockAnimationView!
    @IBOutlet weak var viewAnimated2: LockAnimationView!
    @IBOutlet weak var viewAnimated3: LockAnimationView!
    
    @IBAction func tapLockImage(_ sender: UITapGestureRecognizer) {
        if let touchPoint = sender.location(in: self.imageLockView) as CGPoint! {
            
            /* Cong thuc tinh khi nguoi dung touch inside hinh tron */
            let x = self.view.frame.origin.x
            let y = self.view.frame.origin.y
            let xTouch = touchPoint.x
            let yTouch = touchPoint.y
            let radius = self.imageLockView.frame.size.width / 2
            
            let tapAreaTotal = pow((xTouch - (x + radius)), 2) + pow((yTouch - (y + radius)), 2)
            /* (xTouch - (x + radius)) * (xTouch - (x + radius)) + (yTouch - (y + radius)) * (yTouch - (y + radius)) */
            
            if  tapAreaTotal <= pow(radius, 2) {
                print("You are tapping inside circle !! x: \(touchPoint.x); y: \(touchPoint.y)")
                self.startLockControl()
            }
        }
    }
    
    @IBOutlet weak var imageLockView: UIImageView!
    @IBOutlet weak var btnLock: UIButton!
    @IBAction func btnLockTap(_ sender: UIButton) {
        self.startLockControl()
    }
    
    func startLockControl() {
        isStarted = !isStarted
        if (isStarted) {
            start()
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2.0) {
                self.btnLock.isSelected = !self.btnLock.isSelected
                self.stop()
                self.isStarted = !self.isStarted
            }
        } else {
            stop()
        }
    }
    
    func start() {
        viewAnimated1.tintColor = UIColor(hex: "#2decf2")
        viewAnimated2.tintColor = UIColor(hex: "#32b3e5")
        viewAnimated3.tintColor = UIColor(hex: "#07b8e7")
        
        viewAnimated1.startAnimate(duration: 0.6, lineWidth: 5.0)
        viewAnimated2.startAnimate(duration: 0.8, lineWidth: 6.5)
        viewAnimated3.startAnimate(duration: 1.0, lineWidth: 8.0)
    }
    
    func stop() {
        viewAnimated1.tintColor = .clear
        viewAnimated2.tintColor = .clear
        viewAnimated3.tintColor = .clear
        
        viewAnimated1.stopAnimate(true)
        viewAnimated2.stopAnimate(true)
        viewAnimated3.stopAnimate(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageLockView.layer.cornerRadius = imageLockView.frame.size.width / 2
        imageLockView.clipsToBounds = true
        
        btnLock.setBackgroundImage(UIImage(named: "Lock_Icon"), for: .normal)
        btnLock.setBackgroundImage(UIImage(named: "Unlock_icon"), for: .selected)
        
//        let btnLockSize = UIScreen.main.bounds.width * 0.7
//        cstWidthBtnLock.constant = btnLockSize
//        cstHeightBtnLock.constant = btnLockSize
        // view 1
//        cstWidthView1.constant = cstWidthBtnLock.constant + 0.5
//        cstHeightView1.constant = cstHeightBtnLock.constant + 0.5
        // view 2
//        cstWidthView2.constant = cstWidthView1.constant + 0.5
//        cstHeightView2.constant = cstHeightView1.constant + 0.5
        // view 3
//        cstWidthView3.constant = cstWidthView2.constant + 0.5
//        cstHeightView3.constant = cstHeightView2.constant + 0.5
    }
    
    func animateButton() {
        btnLock.transform = CGAffineTransform(scaleX: 0.3, y: 0.1)
        UIView.animate(
            withDuration: 0.5,
            delay: 0,
            usingSpringWithDamping: CGFloat(0.2),
            initialSpringVelocity: CGFloat(0.6),
            options: .allowUserInteraction,
            animations: { self.btnLock.transform = .identity },
            completion: { finished in
                self.animateButton()
            }
        )
    }
    
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        let radius:CGFloat = (self.btnLockView.bounds.size.width / 2)
//        var point:CGPoint = CGPoint()
//        
//        if let touch = touches.first {
//            point = touch.location(in: self.btnLockView)
//            print("\(touch)")
//        }
//        
//        let distance: CGFloat = sqrt(CGFloat(powf((Float(self.btnLockView.center.x - point.x)), 2) + powf((Float(self.btnLockView.center.y - point.y)), 2)))
//        
//        if (distance < radius) {
//            super.touchesBegan(touches, with: event)
//        }
//    }
}
