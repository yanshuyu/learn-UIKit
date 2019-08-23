//
//  ChartView.swift
//  06_coreGraphices
//
//  Created by sy on 2019/8/20.
//  Copyright © 2019 sy. All rights reserved.
//

import UIKit

@IBDesignable
class ChartView: UIView {
    
    @IBInspectable var beginColor: UIColor = UIColor.lightGray {
        didSet {
            self.setNeedsDisplay()
        }
    }
    @IBInspectable var endColor: UIColor = UIColor.darkGray {
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    init() {
        super.init(frame: CGRect.zero)
        setUpview()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpview()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUpview()
    }
    
    func setUpview() {
        self.layer.cornerRadius = 8
        self.layer.masksToBounds = true
    }
    
    
    override func draw(_ rect: CGRect) {
        // draw gradient background
        let currentContext = UIGraphicsGetCurrentContext()
        
        let colors = [self.beginColor.cgColor, self.endColor.cgColor]
        let locations = [CGFloat(0), CGFloat(1)]
        let gradient = CGGradient(colorsSpace: CGColorSpaceCreateDeviceRGB(),
                                  colors: colors as CFArray,
                                  locations: locations)!
        currentContext?.drawLinearGradient(gradient,
                                           start: CGPoint.zero,
                                           end: CGPoint(x: 0, y: self.bounds.height),
                                           options: [])
        
    }

}
