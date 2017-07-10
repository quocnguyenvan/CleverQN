//
//  SplashScreenController.swift
//  CleverApp
//
//  Created by Quoc Nguyen on 6/20/17.
//  Copyright © 2017 Rynan. All rights reserved.
//

import UIKit
import LTMorphingLabel

class SplashScreenController: UIViewController, HolderViewDelegate, LTMorphingLabelDelegate {

    @IBOutlet weak var lbAppName: LTMorphingLabel!
    var holderView = HolderView(frame: CGRect.zero)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        lbAppName.delegate = self
        perform(#selector(SplashScreenController.showNavController), with: nil, afterDelay: 1.5)
    }
    
    func showNavController() {
        performSegue(withIdentifier: "showSplashScreen", sender: self)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
//        addHolderView()
        lbAppName.text = "Clever Smart Lock"
        lbAppName.morphingEffect = LTMorphingEffect.sparkle //sparkle, burn
    }
    
    func addHolderView() {
        let boxSize: CGFloat = 100.0
        holderView.frame = CGRect(x: view.bounds.width / 2 - boxSize / 2, y: view.bounds.height / 2 - boxSize / 2, width: boxSize, height: boxSize)
        holderView.parentFrame = view.frame
        holderView.delegate = self
        view.addSubview(holderView)
        
        //
        holderView.addOval()
    }

    func animateLabel(){
        print("A<=>B")
    }
}
