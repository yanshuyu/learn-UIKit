//
//  CALayerImplicitAnimationViewController.swift
//  05_CoreAnimation
//
//  Created by sy on 2019/7/28.
//  Copyright © 2019 sy. All rights reserved.
//

import UIKit

class CALayerImplicitAnimationViewController: UIViewController {

    @IBOutlet weak var colorView: UIView!
    
    var colorLayer: CALayer? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.colorView.layer.borderColor = UIColor.black.cgColor
        self.colorView.layer.borderWidth = 1
        
        //CALayers that are associated with a UIView (as in, they're accessed via view.layer)
        //do not participate in implicit animations
        self.colorLayer = CALayer()
        self.colorLayer?.frame = self.colorView.bounds
        self.colorView.layer.addSublayer(self.colorLayer!)
    }
    
    func randomColor() -> CGColor {
        let r = CGFloat(arc4random()) / CGFloat(INT_MAX)
        let g = CGFloat(arc4random()) / CGFloat(INT_MAX)
        let b = CGFloat(arc4random()) / CGFloat(INT_MAX)
        
        return UIColor(red: r, green: g, blue: b, alpha: 1).cgColor
    }
    
    @IBAction func changeColorNormal(_ sender: UIButton) {
        self.colorLayer?.backgroundColor = randomColor();
    }
    

    @IBAction func changeColorFast(_ sender: UIButton) {
        CATransaction.begin()
        CATransaction.setAnimationDuration(2)
        CATransaction.setCompletionBlock {
            var transform = CGAffineTransform(rotationAngle: .pi * 0.25)
            transform = self.colorView.transform.concatenating(transform)
            self.colorView.transform = transform
        }
        self.colorLayer?.backgroundColor = randomColor();
        CATransaction.commit()
    }
}
