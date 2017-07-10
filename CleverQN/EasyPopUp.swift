//
//  EasyPopUp.swift
//  CleverApp
//
//  Created by Quoc Nguyen on 6/16/17.
//  Copyright © 2017 Rynan. All rights reserved.
//

import Foundation
import UIKit

class EasyPopUp: UIView {

    /// Popup view
    var popupView: UIView!
    ///  Close button
    var closeButton: UIButton!
    /// Background view
    var backgroundView: UIView!
    
    /// Set Start animate
    var startAnimate:(()->())?
    /// Set End animate
    var endAnimate:(()->())?
    
    var sizeCloseBtnPourcent:CGFloat = 13 {
        didSet {
            self.updateConstraintsPopUp()
        }
    }
    var heightPopPourcent:CGFloat = 80 {
        didSet {
            self.updateConstraintsPopUp()
        }
    }
    var widthPopPourcent:CGFloat = 80 {
        didSet {
            self.updateConstraintsPopUp()
        }
    }
    var positionYMore:CGFloat = 0 {
        didSet {
            self.updateConstraintsPopUp()
        }
    }
    
    ///###### Private ######///
    
    var positionX: CGFloat {
        get {
            return UIScreen.main.bounds.width / 2 - self.popUpWidth / 2
        }
    }
    var positionY: CGFloat {
        get {
            return sizeButtonClose + positionYMore
        }
    }
    var sizeButtonClose: CGFloat {
        get {
            return (self.frame.width * sizeCloseBtnPourcent / 100)
        }
    }
    private var popUpHeight: CGFloat {
        get {
            return (self.frame.height * heightPopPourcent / 100)
        }
    }
    private var popUpWidth: CGFloat {
        get {
            return (self.frame.width * widthPopPourcent / 100)
        }
    }
    
    required init(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    init(frame: CGRect, contentView: UIView) {
        super.init(frame: frame)
        
        self.createBackground()
        self.createPopupView()
        self.createCloseButton()

        contentView.frame =  CGRect(x: 0, y: 0, width: popUpWidth, height: popUpHeight)
        self.popupView.addSubview(contentView)
    }
    
    func start() {
        self.createStartAnimation()
    }
    
    func removeDefautlAnimate() {
        self.backgroundView.layer.removeAllAnimations()
        self.popupView.layer.removeAllAnimations()
        self.closeButton.layer.removeAllAnimations()
    }
    
    func createBackground() {
        self.backgroundView = UIView(frame: frame)
        self.backgroundView.backgroundColor = UIColor(white: 0.0, alpha: 0.5)
        self.addSubview(backgroundView)
    }
    
    /**
     Create popupView
     */
    
    func createPopupView(defaultAnimate withDefaultAnimate:Bool = true, defaultStyle withDefaultStyle:Bool = true) {
        self.popupView = UIView(frame: CGRect(x: positionX, y: self.positionY, width: popUpWidth, height: popUpHeight))
        self.popupView.backgroundColor = UIColor.white
        self.popupView.layer.cornerRadius = 8.0
        self.popupView.clipsToBounds = true
        self.addSubview(popupView)
    }
    
    func createCloseButton() {
        
        let positionX = UIScreen.main.bounds.width / 2 - popupView.frame.size.width / 2
        self.closeButton = UIButton(type: .system)
        
        self.closeButton.addTarget(self, action: #selector(EasyPopUp.createEndAnimation), for: .touchUpInside)
        self.closeButton.frame = CGRect(x: positionX - 20, y: positionY - 20, width: sizeButtonClose, height: sizeButtonClose)
        
        self.closeButton.backgroundColor = UIColor(red: 0.149, green: 0.149, blue: 0.149, alpha: 1.00)
        self.closeButton.layer.cornerRadius = closeButton.frame.size.width / 2
        self.closeButton.clipsToBounds = true
        self.closeButton.setTitleColor(UIColor.white, for: .normal)
        self.closeButton.setTitle("X", for: .normal)
        self.closeButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        self.closeButton.titleLabel?.textAlignment =  .center
        self.addSubview(closeButton)
        //  self.insertSubview(closeButton, aboveSubview: popupView)
    }
    
    func createStartAnimation() {
        if let funcAnimate = self.startAnimate {
            funcAnimate()
        } else {
            
            self.backgroundView.alpha = 0
            self.closeButton.alpha = 0
            
            self.popupView.frame.origin.y = -self.frame.height
            
            self.closeButton.frame.origin.y = -self.frame.height
            
            UIView.animate(withDuration: 0.2, delay: 0.0, options: UIViewAnimationOptions.curveEaseInOut, animations: {
                self.backgroundView.alpha = 1
                self.closeButton.alpha = 1
                
                self.popupView.frame.origin.y = self.positionY + self.positionY / 10
                self.closeButton.frame.origin.y  = self.positionY - self.sizeButtonClose / 2 + self.positionY / 10
            }, completion: { (bool) -> Void in
                UIView.animate(withDuration: 0.2, delay: 0.0, options: UIViewAnimationOptions.curveEaseInOut, animations: {
                    
                    self.popupView.frame.origin.y = self.positionY
                    self.closeButton.frame.origin.y  = self.positionY - self.sizeButtonClose / 2
                }, completion: { (bool) -> Void in
                })
            })
        }
    }
    
    func createEndAnimation() {
        if let funcAnimate = self.endAnimate {
            funcAnimate()
        } else {
            
            UIView.animate(withDuration: 0.4, delay: 0.0, options: UIViewAnimationOptions.curveEaseOut, animations: {
                self.backgroundView.alpha = 0
                self.popupView.frame.origin.y = -self.frame.height
                self.closeButton.frame.origin.y  = -self.frame.height

            }) { (Bool) -> Void in
                self.removeFromSuperview()
            }
        }
    }
    
    private func updateConstraintsPopUp() {
        self.closeButton.frame = CGRect(x: positionX - 20, y: positionY - 20, width: sizeButtonClose, height: sizeButtonClose)
        self.popupView.frame = CGRect(x: positionX, y: self.positionY, width: popUpWidth, height: popUpHeight)
    }
    
    func closeButtonPressed(sender: UIButton) { self.createEndAnimation() }
}
