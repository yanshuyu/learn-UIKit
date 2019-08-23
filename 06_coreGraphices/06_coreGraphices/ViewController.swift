//
//  ViewController.swift
//  06_coreGraphices
//
//  Created by sy on 2019/7/26.
//  Copyright © 2019 sy. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var upperContainerView: UIView!
    @IBOutlet weak var archProgress: archProgressView!
    @IBOutlet weak var chartView: ChartView!
    @IBOutlet weak var counterLable: UILabel!
    
    let glassWaterCount = 8
    var currentWaterCount = 0
    private var isChartViewShowing: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.archProgress.progress = Float(self.currentWaterCount)/Float(self.glassWaterCount)
        self.counterLable.text = "\(self.currentWaterCount)/\(self.glassWaterCount)"
        
        self.chartView.isHidden = true
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(ViewController.handleTapGestureInUpperContainerView(_:)))
        self.upperContainerView.addGestureRecognizer(tapGesture);
    }

    @IBAction func handlePlushButtonTap(_ sender: PlusButton) {
        if (self.isChartViewShowing) {
            self.handleTapGestureInUpperContainerView(nil)
            return
        }
        if ( self.currentWaterCount < self.glassWaterCount ) {
            self.currentWaterCount += 1
            self.archProgress.progress = Float(self.currentWaterCount)/Float(self.glassWaterCount)
            self.counterLable.text = "\(self.currentWaterCount)/\(self.glassWaterCount)"
        }
    }
    
    @IBAction func handleMinusButtonTap(_ sender: MinusButton) {
        if (self.isChartViewShowing) {
            self.handleTapGestureInUpperContainerView(nil)
            return
        }
        if (self.currentWaterCount > 0) {
            self.currentWaterCount -= 1
            self.archProgress.progress = Float(self.currentWaterCount)/Float(self.glassWaterCount)
            self.counterLable.text = "\(self.currentWaterCount)/\(self.glassWaterCount)"
        }
    }
    
    @objc func handleTapGestureInUpperContainerView(_ gesture: UITapGestureRecognizer?) {
        if (self.isChartViewShowing) {
            UIView.transition(from: self.chartView,
                              to: self.archProgress,
                              duration: 0.5,
                              options: [.transitionFlipFromLeft , .showHideTransitionViews],
                              completion: nil)
        } else {
            UIView.transition(from: self.archProgress,
                              to: self.chartView,
                              duration: 0.5,
                              options: [.transitionFlipFromRight, .showHideTransitionViews],
                              completion: nil);
        }
        self.isChartViewShowing = !self.isChartViewShowing
    }
    
}

