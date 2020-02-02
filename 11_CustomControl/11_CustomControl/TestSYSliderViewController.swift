//
//  ViewController.swift
//  11_CustomControl
//
//  Created by sy on 2020/1/31.
//  Copyright © 2020 sy. All rights reserved.
//

import UIKit

class TestSYSliderViewController: UIViewController {
    @IBOutlet weak var rangeSlider: SYRangeSlider!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.rangeSlider.addTarget(self, action: #selector(handleRangeSliderTouchDown(_:)), for: .touchDown)
        self.rangeSlider.addTarget(self, action: #selector(handleRangSliderValueChange(_:)), for: .valueChanged)
        self.rangeSlider.addTarget(self, action: #selector(handleRangeSliderTouchUp(_:)), for: .touchUpInside)
        self.rangeSlider.addTarget(self, action: #selector(handleRangeSliderTouchUp(_:)), for: .touchUpOutside)
    }
    
    @objc func handleRangeSliderTouchDown(_ sender: SYRangeSlider) {
        print("touch down")
    }
    
    @objc func handleRangSliderValueChange(_ sender: SYRangeSlider) {
        print("range value: [\(sender.lowerValue), \(sender.upperValue)]")
    }
    
    @objc func handleRangeSliderTouchUp(_ sender: SYRangeSlider) {
        print("touch up")
    }
}

