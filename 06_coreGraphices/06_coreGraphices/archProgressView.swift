//
//  archProgressView.swift
//  06_coreGraphices
//
//  Created by sy on 2019/7/26.
//  Copyright © 2019 sy. All rights reserved.
//

import UIKit

@IBDesignable
class archProgressView: UIView {
    @IBInspectable var archWidth: CGFloat = 10
    @IBInspectable var startAngle: CGFloat = 0
    @IBInspectable var endAngle: CGFloat = 180
    @IBInspectable var archColor: UIColor = UIColor.green
    @IBInspectable var maxArchColor: UIColor = UIColor.orange

    @IBInspectable var progress: Float = 0.5 {
        didSet {
            setNeedsDisplay()
        }
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private var radius: CGFloat {
        return min(self.bounds.width, self.bounds.height) * 0.5  - self.archWidth * 0.5
    }
    
    private func degreeToRadian(_ degree: CGFloat) -> CGFloat {
        return degree * CGFloat.pi / 180
    }
    
    private func progressEndAngle() -> CGFloat {
        var differenceAngle: CGFloat = 0
        if (self.endAngle > self.startAngle) {
            differenceAngle = CGFloat(Int(self.endAngle - self.startAngle) % 360)
        } else if (self.endAngle < self.startAngle) {
            differenceAngle = CGFloat(360 - Int(self.startAngle) % 360) + self.endAngle
        }
        var progressNormalize = min(self.progress, 1)
        progressNormalize = max(progressNormalize, 0)
        return CGFloat(Float(self.startAngle) + Float(differenceAngle) * progressNormalize)
    }
    
    override func draw(_ rect: CGRect) {
        let bgArch = UIBezierPath(arcCenter: CGPoint(x: self.bounds.width * 0.5, y: self.bounds.height * 0.5),
                                    radius: self.radius,
                                    startAngle: CGFloat(degreeToRadian(self.startAngle)),
                                    endAngle: CGFloat(degreeToRadian(self.endAngle)),
                                    clockwise: true)
        bgArch.lineWidth = self.archWidth
        maxArchColor.setStroke()
        bgArch.stroke()
        
        let progressArch = UIBezierPath(arcCenter: CGPoint(x: self.bounds.width * 0.5, y: self.bounds.height * 0.5),
                                        radius: self.radius,
                                        startAngle: degreeToRadian(self.startAngle),
                                        endAngle: degreeToRadian(progressEndAngle()),
                                        clockwise: true);
        progressArch.lineWidth = self.archWidth
        archColor.setStroke()
        progressArch.stroke()
    }

}
