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
    @IBInspectable var barWidth: CGFloat = 10 {
        didSet {
            self.setNeedsLayout()
        }
    }
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
    
    private var barAnimIsRunning = false;
    
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
        barLayer.strokeEnd = 1
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
        self.layer.masksToBounds = true
        self.layer.addSublayer(self.trackLayer)
        self.layer.addSublayer(self.barGradientLayer)
        self.layer.addSublayer(self.barLayer)
        //self.barGradientLayer.mask = self.barLayer
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.barLayer.lineWidth = self.barWidth
        self.trackLayer.lineWidth = self.barWidth
        let path = UIBezierPath(arcCenter: CGPoint(x: self.bounds.width*0.5, y: self.bounds.height*0.5),
                                     radius: min(self.bounds.width*0.5, self.bounds.height*0.5) - self.barWidth*0.5,
                                     startAngle: -.pi/2,
                                     endAngle: .pi*2 - .pi/2,
                                     clockwise: true).cgPath
        self.barLayer.path = path
        self.trackLayer.path = path
        
        
    }
    
    func runPrograssAnimation() {
        if let _ = self.barLayer.animation(forKey: "barAnim") {
            if !self.barAnimIsRunning {
                //resume bar progress animation
                self.barLayer.speed = 1
            }
        } else {
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
    
    func stopPrograssAnimation() {
        if let _ = self.barLayer.animation(forKey: "barAnim") {
            if let presentLayer = self.barLayer.presentation() {
                // pause bar progress animation
                CATransaction.begin()
                CATransaction.setDisableActions(true)
                self.barLayer.strokeEnd = presentLayer.strokeEnd
                CATransaction.commit()
                //self.barLayer.speed = 0.1
                self.barLayer.speed = 0
                self.barAnimIsRunning = false
            }
        }
    }

}

extension CirclePrograssBar: CAAnimationDelegate {
    func animationDidStart(_ anim: CAAnimation) {
        if anim == self.barLayer.animation(forKey: "barAnim") {
            self.barAnimIsRunning = true
        }
    }
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
//        if (flag) {
//            let barAnim = anim as! CABasicAnimation
//            CATransaction.begin()
//            CATransaction.setDisableActions(true)
//            self.barLayer.strokeEnd = barAnim.toValue as! CGFloat
//            CATransaction.commit()
//        }
        if anim == self.barLayer.animation(forKey: "barAnim") {
            self.barAnimIsRunning = false
        }
        if flag {
            if let presentLayer = self.barLayer.presentation() {
                CATransaction.begin()
                CATransaction.setDisableActions(true)
                self.barLayer.strokeEnd = presentLayer.strokeEnd
                CATransaction.commit()
            }
            self.barLayer.removeAllAnimations()
        }
    }
}
