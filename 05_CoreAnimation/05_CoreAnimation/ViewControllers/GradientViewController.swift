//
//  GradientViewController.swift
//  05_CoreAnimation
//
//  Created by sy on 2019/7/27.
//  Copyright © 2019 sy. All rights reserved.
//

import UIKit

class GradientViewController: UIViewController {
    @IBOutlet weak var gradientView_1: UIView!
    @IBOutlet weak var gradientView_2: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupGradientView1()
        setupGradientView2()
    }
    
    func setupGradientView1() -> Void {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.gradientView_1.bounds
        self.gradientView_1.layer.addSublayer(gradientLayer)
        gradientLayer.colors = [UIColor.red.cgColor, UIColor.yellow.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
        
    }
    
    func setupGradientView2() -> Void {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.gradientView_2.bounds
        self.gradientView_2.layer.addSublayer(gradientLayer)
        gradientLayer.colors = [UIColor.red.cgColor,
                                UIColor.orange.cgColor,
                                UIColor.yellow.cgColor,
                                UIColor.green.cgColor,
                                UIColor.blue.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
        gradientLayer.locations = [0, 0.125, 0.25, 0.5, 1]
    }

}
