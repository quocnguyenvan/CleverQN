//
//  AnimationExample.swift
//  CleverApp
//
//  Created by Quoc Nguyen on 7/7/17.
//  Copyright © 2017 Rynan. All rights reserved.
//

import UIKit

class AnimationExample: UIViewController {

    @IBOutlet weak var btnCricle: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let layer: CAShapeLayer = {
            let layer = CAShapeLayer()
            layer.path = UIBezierPath(rect: CGRect(x: 0, y: 0, width: 100, height: 100)).cgPath
            layer.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
            layer.position = self.view.center
            layer.fillColor = UIColor.red.cgColor
            return layer
        }()

        let anim = CABasicAnimation(keyPath: "fillColor")
        anim.fromValue = UIColor.darkGray.cgColor
        anim.toValue = UIColor.purple.cgColor
        anim.repeatCount = 10
        anim.duration = 1.5
        anim.autoreverses = true
        layer.add(anim, forKey: "colorAnimation")
        layer.fillColor = (anim.fromValue as! CGColor)
        
        startAnimation()
    }
    
    @IBAction func btnTap(_ sender: UIButton) {
        btnCricle.fadeTransition(duration: 2.0)
    }
    
    
    func startAnimation() {
        let animation = CABasicAnimation(keyPath: "transform.rotation.z")
        animation.fromValue = 10
        animation.toValue = 350
        animation.duration = 6
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        animation.beginTime = CACurrentMediaTime() + 2.0
        btnCricle.layer.add(animation, forKey: "basic")
        btnCricle.layer.position = CGPoint(x: 455, y: 61) //CGPointMake(455, 61)
    }
}
