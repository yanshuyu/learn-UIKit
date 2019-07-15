//
//  ViewController.swift
//  03_FrameAndBound
//
//  Created by sy on 2019/4/28.
//  Copyright © 2019 sy. All rights reserved.
//

import UIKit

class FrameAndBoundViewController: UIViewController {
    @IBOutlet weak var containerView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
//        if let frameXSlider = self.view.viewWithTag(1) as? UISlider {
//            frameXSlider.value = Float( containerView.frame.origin.x )
//        }
//        if let frameYSlider = self.view.viewWithTag(2) as? UISlider {
//            frameYSlider.value = Float( containerView.frame.origin.y )
//        }
//        if let boundsXSlider = self.view.viewWithTag(3) as? UISlider {
//            boundsXSlider.value = Float( containerView.bounds.origin.x )
//        }
//        if let boundsYSlider = self.view.viewWithTag(4) as? UISlider {
//            boundsYSlider.value = Float( containerView.bounds.origin.y )
//        }
    }

    @IBAction func onSliding(_ sender: UISlider) {
        switch sender.tag {
        case 1:
            containerView.frame.origin.x = CGFloat( sender.value )
        case 2:
            containerView.frame.origin.y = CGFloat( sender.value )
        case 3:
            containerView.bounds.origin.x = CGFloat( sender.value )
        case 4:
            containerView.bounds.origin.y = CGFloat( sender.value )
        default:
            break
        }
    }
    
}

