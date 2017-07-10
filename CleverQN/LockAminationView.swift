//
//  SpinningView.swift
//  CleverApp
//
//  Created by Quoc Nguyen on 6/6/17.
//  Copyright © 2017 Rynan. All rights reserved.
//

import UIKit

@IBDesignable
class LockAnimationView: UIView {
    
    private var animating: Bool
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    
    let circleLayer = CAShapeLayer()
    
    override init(frame: CGRect) {
        animating = true
        super.init(frame: frame)
    }
    
    required init(coder aDecoder: NSCoder) {
        animating = true
        super.init(coder: aDecoder)!
    }
    
    func updateAnimation(duration: CFTimeInterval) {
        let strokeEndAnimation: CAAnimation = {
            let animation = CABasicAnimation(keyPath: "strokeEnd")
            animation.fromValue = 0
            animation.toValue = 1
            animation.duration = duration // 2
            animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
            
            let group = CAAnimationGroup()
            group.duration = duration + 0.5 // 2.5
            group.repeatCount = MAXFLOAT
            group.animations = [animation]
            
            return group
        }()
        
        let strokeStartAnimation: CAAnimation = {
            let animation = CABasicAnimation(keyPath: "strokeStart")
            animation.beginTime = 0.5
            animation.fromValue = 0
            animation.toValue = 1
            animation.duration = duration // 2
            animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
            
            let group = CAAnimationGroup()
            group.duration = duration + 0.5 // 2.5
            group.repeatCount = MAXFLOAT
            group.animations = [animation]
            
            return group
        }()
        
        let rotationAnimation: CAAnimation = {
            let animation = CABasicAnimation(keyPath: "transform.rotation.z")
            animation.fromValue = 0
            animation.toValue = Double.pi * 2
            animation.duration = duration * 2 // 4
            animation.repeatCount = MAXFLOAT
            return animation
        }()

        circleLayer.add(strokeEndAnimation, forKey: "strokeEnd")
        circleLayer.add(strokeStartAnimation, forKey: "strokeStart")
        circleLayer.add(rotationAnimation, forKey: "rotation")
    }
    
    func startAnimate(duration: CFTimeInterval, lineWidth: CGFloat) {
//        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        circleLayer.lineWidth = lineWidth
        circleLayer.fillColor = nil
        
//        circleLayer.strokeColor = appDelegate.uiColorFromHex(rgbValue: color).cgColor
        layer.addSublayer(circleLayer)
        tintColorDidChange()
        updateAnimation(duration: duration)
    }
    
    func stopAnimate(_ stop: Bool) {
        if stop == true {
            circleLayer.removeAnimation(forKey: "strokeEnd")
            circleLayer.removeAnimation(forKey: "strokeStart")
            circleLayer.removeAnimation(forKey: "rotation")
        }
    }
    
    override func tintColorDidChange() {
        super.tintColorDidChange()
        circleLayer.strokeColor = tintColor.cgColor
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let center = CGPoint(x: bounds.midX, y: bounds.midY)
        let radius = min(bounds.width, bounds.height) / 2 - circleLayer.lineWidth/2
        
        let startAngle = CGFloat(-Double.pi/2)
        let endAngle = startAngle + CGFloat(Double.pi * 2)
        
        let path = UIBezierPath(arcCenter: CGPoint.zero, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
        
        circleLayer.position = center
        circleLayer.path = path.cgPath
    }
}
