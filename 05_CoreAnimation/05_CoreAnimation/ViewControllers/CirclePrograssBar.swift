//
//  CirclePrograssBar.swift
//  05_CoreAnimation
//
//  Created by sy on 2019/8/23.
//  Copyright © 2019 sy. All rights reserved.
//

import UIKit


@IBDesignable
class CirclePrograssBar: UIView {
    @IBInspectable var barWidth: CGFloat = 10
    @IBInspectable var barBeginTintColor: UIColor = #colorLiteral(red: 0.9568627477, green: 0.6588235497, blue: 0.5450980663, alpha: 1) {
        didSet {
            self.barGradientLayer.colors = [self.barBeginTintColor.cgColor, self.barEndTintColor.cgColor]
        }
    }
    @IBInspectable var barEndTintColor: UIColor = #colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 1) {
        didSet {
            self.barGradientLayer.colors = [self.barBeginTintColor.cgColor, self.barEndTintColor.cgColor]
        }
    }
    @IBInspectable var barTrackTintColor: UIColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1) {
        didSet {
            self.trackLayer.strokeColor = self.barTrackTintColor.cgColor
            
        }
    }
    
    private lazy var trackLayer: CAShapeLayer = {
        let track = CAShapeLayer()
        track.frame = self.bounds
        track.lineWidth = self.barWidth
        track.lineCap = .round
        track.strokeColor = self.barTrackTintColor.cgColor
        track.fillColor = UIColor.clear.cgColor
        track.strokeStart = 0
        track.strokeEnd = 1
        track.path = UIBezierPath(arcCenter: CGPoint(x: self.bounds.width*0.5, y: self.bounds.height*0.5),
                                  radius: min(self.bounds.width*0.5, self.bounds.height*0.5) - self.barWidth*0.5,
                                  startAngle: -.pi/2,
                                  endAngle: .pi*2 - .pi/2,
                                  clockwise: true).cgPath
        return track
    }()
    
    private lazy var barLayer: CAShapeLayer = {
        let barLayer = CAShapeLayer()
        barLayer.frame = self.bounds
        barLayer.lineWidth = self.barWidth
        barLayer.lineCap = .round
        barLayer.fillColor = UIColor.clear.cgColor
        barLayer.strokeColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0).cgColor
        barLayer.strokeStart = 0
        barLayer.strokeEnd = 0
        barLayer.path = UIBezierPath(arcCenter: CGPoint(x: self.bounds.width*0.5, y: self.bounds.height*0.5),
                                  radius: min(self.bounds.width*0.5, self.bounds.height*0.5) - self.barWidth*0.5,
                                  startAngle: -.pi/2,
                                  endAngle: .pi*2 - .pi/2,
                                  clockwise: true).cgPath
        return barLayer
    }()
    
    private lazy var barGradientLayer :CAGradientLayer = {
        let gradient = CAGradientLayer()
        gradient.frame = self.bounds
        gradient.colors = [self.barBeginTintColor.cgColor, self.barEndTintColor.cgColor]
        gradient.startPoint = CGPoint(x: 0, y: 0)
        gradient.endPoint = CGPoint(x: 1, y: 1)
        return gradient
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        self.layer.addSublayer(self.trackLayer)
        self.layer.addSublayer(self.barGradientLayer)
        self.barGradientLayer.mask = self.barLayer
    }
    
    func runPrograssAnimation() {
        self.barLayer.removeAnimation(forKey: "barAnim")
        let barAnim = CABasicAnimation()
        barAnim.keyPath = "strokeEnd"
        barAnim.fromValue = 0
        barAnim.toValue = 1
        barAnim.duration = CFTimeInterval(2)
        barAnim.fillMode = .both
        barAnim.isRemovedOnCompletion = false
        barAnim.delegate = self
        self.barLayer.add(barAnim, forKey: "barAnim")
    }

}

extension CirclePrograssBar: CAAnimationDelegate {
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
//        if (flag) {
//            let barAnim = anim as! CABasicAnimation
//            CATransaction.begin()
//            CATransaction.setDisableActions(true)
//            self.barLayer.strokeEnd = barAnim.toValue as! CGFloat
//            CATransaction.commit()
//        }
    }
}
