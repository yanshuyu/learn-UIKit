//
//  UIColor+MathAddition.swift
//  06_coreGraphices
//
//  Created by sy on 2019/7/26.
//  Copyright © 2019 sy. All rights reserved.
//

import UIKit

extension UIColor {
    class func colorAdd(color1 lhs: UIColor, color2 rhs: UIColor) -> UIColor {
        var lhsRed: CGFloat = 0
        var lhsGreen: CGFloat = 0
        var lhsBlue: CGFloat = 0
        var lhsAlpha : CGFloat = 0
        var rhsRed: CGFloat = 0
        var rhsGreen: CGFloat = 0
        var rhsBlue: CGFloat = 0
        var rhsAlpha : CGFloat = 0
        lhs.getRed(&lhsRed, green: &lhsGreen, blue: &lhsBlue, alpha: &lhsAlpha)
        rhs.getRed(&rhsRed, green: &rhsGreen, blue: &rhsBlue, alpha: &rhsAlpha)
        return UIColor(red: lhsRed*0.5 + rhsRed*0.5,
                       green: lhsGreen*0.5 + rhsGreen*0.5,
                       blue: lhsBlue*0.5 + rhsBlue*0.5,
                       alpha: lhsAlpha*0.5 + rhsAlpha*0.5)
    }
    
    
    func colorMultiplyScale(scale: CGFloat) -> UIColor {
        var (r, g, b, a) = (CGFloat(0), CGFloat(0), CGFloat(0), CGFloat(0))
        self.getRed(&r, green: &g, blue: &b, alpha: &a)
        r *= scale
        g *= scale
        b *= scale
        return UIColor(red: r, green: g, blue: b, alpha: a);
    }
    
    func colorMutiplyColor(color: UIColor) -> UIColor {
        var (lr, lg, lb, la) = (CGFloat(0), CGFloat(0), CGFloat(0), CGFloat(0));
        var (rr, rg, rb, ra) = (CGFloat(0), CGFloat(0), CGFloat(0), CGFloat(0))
        self.getRed(&lr, green: &lg, blue: &lb, alpha: &la)
        color.getRed(&rr, green: &rg, blue: &rb, alpha: &ra)
        return UIColor(red: lr*rr, green: lg*rg, blue: lb*rb, alpha: la*ra)
    }
    
}
