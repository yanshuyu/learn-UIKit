//
//  UIFrameAndBoundsView.swift
//  03_FrameAndBound
//
//  Created by sy on 2019/4/28.
//  Copyright © 2019 sy. All rights reserved.
//

import UIKit

class UIFrameAndBoundsView: UIView {

    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        let frame = UIBezierPath(roundedRect: self.frame, cornerRadius: 1)
        frame.lineWidth = 2
        UIColor.blue.setStroke()
        frame.stroke()
        
        let bounds = UIBezierPath(roundedRect: CGRect(x: self.bounds.origin.x + 4,
                                                      y: self.bounds.origin.y + 4,
                                                      width: self.bounds.width,
                                                      height: self.bounds.height) , cornerRadius: 1)
        bounds.lineWidth = 2
        UIColor.green.setStroke()
        bounds.stroke()
    }


}
