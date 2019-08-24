//
//  CALayerExplicityAnimationViewController.swift
//  05_CoreAnimation
//
//  Created by sy on 2019/7/29.
//  Copyright © 2019 sy. All rights reserved.
//

import UIKit

class CALayerExplicityAnimationViewController: UIViewController {
    @IBOutlet weak var colorView: UIView!
    @IBOutlet weak var prograssBar: CirclePrograssBar!
    @IBOutlet weak var goButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    
    var colorLayer: CALayer! = nil;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.colorLayer = CALayer()
        self.colorLayer.frame = self.colorView.bounds
        self.colorLayer.backgroundColor = randomColor()
        self.colorView.layer.addSublayer(self.colorLayer)

        self.colorView.layer.borderColor = UIColor.black.cgColor
        self.colorView.layer.borderWidth = 1
        self.colorView.layer.backgroundColor = randomColor()
    }
    
    @IBAction func changeColor(_ sender: UIButton?) {
        let animation = CABasicAnimation()
        animation.keyPath = "backgroundColor"
        animation.toValue = randomColor()
        animation.duration = 2
        
        //animations do not modify the layer’s model, only its presentation.
        //Once the animation finishes and is removed from the layer, the layer reverts back to the
        //appearance defined by its model properties.
        animation.setValue("changeBackgroundColor", forKey: "animationId")
        animation.setValue(self.colorLayer, forKey: "animattionTarget")
        animation.delegate = self;
        self.colorLayer.add(animation, forKey: "changeBackground")
        
    }
    
    @IBAction func runBarAnim(_ sender: Any) {
        self.prograssBar.runPrograssAnimation()
    }
    
    @IBAction func stopBarAnim(_ sender: Any) {
        self.prograssBar.stopPrograssAnimation()
    }
    
    func randomColor() -> CGColor {
        let r = CGFloat(arc4random()) / CGFloat(INT_MAX)
        let g = CGFloat(arc4random()) / CGFloat(INT_MAX)
        let b = CGFloat(arc4random()) / CGFloat(INT_MAX)
        
        return UIColor(red: r, green: g, blue: b, alpha: 1).cgColor
    }
    
}


extension CALayerExplicityAnimationViewController : CAAnimationDelegate{
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        let animLayer = anim.value(forKey: "animattionTarget") as? CALayer
        let animId = anim.value(forKey: "animationId") as? String
        
        //update layer model
        if animId == "changeBackgroundColor" && flag {
            let basicAnim = anim as! CABasicAnimation
            //disable implicity animatipn
            CATransaction.begin()
            CATransaction.setDisableActions(true)
            animLayer?.backgroundColor = (basicAnim.toValue as! CGColor)
            CATransaction.commit()
        }
    }
}
