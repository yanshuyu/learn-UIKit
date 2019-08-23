//
//  PlusButton.swift
//  06_coreGraphices
//
//  Created by sy on 2019/7/26.
//  Copyright © 2019 sy. All rights reserved.
//

import UIKit

@IBDesignable
class PlusButton: UIButton {
    @IBInspectable var signLineWidth: CGFloat = 10
    @IBInspectable var plushColor: UIColor = UIColor.white
    @IBInspectable var circleColor: UIColor = UIColor.lightGray
    
    private let signScale: CGFloat = 0.6
    
    override var isHighlighted: Bool {
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    override func draw(_ rect: CGRect) {
        var fillColor = circleColor;
        var strokColor = plushColor;
        if self.state == .highlighted {
            fillColor = fillColor.colorMultiplyScale(scale: 0.8)
            strokColor = strokColor.colorMultiplyScale(scale: 0.8)
        }
        let circlePath = UIBezierPath(ovalIn: self.bounds)
        //circleColor.setFill()
        fillColor.setFill()
        circlePath.fill()
        
        let halfSignWidth = self.bounds.width * 0.5 * signScale
        let halfSingHeight = self.bounds.height * 0.5 * signScale
        var signPath = UIBezierPath()
        signPath.move(to: CGPoint(x: self.bounds.width*0.5 - halfSignWidth, y: self.bounds.height*0.5))
        signPath.addLine(to: CGPoint(x: self.bounds.width*0.5 + halfSignWidth, y: self.bounds.height*0.5))
        signPath.lineWidth = self.signLineWidth
        //plushColor.setStroke()
        strokColor.setStroke()
        signPath.stroke()
        
        signPath = UIBezierPath()
        signPath.move(to: CGPoint(x: self.bounds.width*0.5, y: self.bounds.height*0.5 - halfSingHeight))
        signPath.addLine(to: CGPoint(x: self.bounds.width*0.5, y: self.bounds.height*0.5 + halfSingHeight))
        signPath.lineWidth = self.signLineWidth
        //plushColor.setStroke()
        signPath.stroke()
    }
    
}
