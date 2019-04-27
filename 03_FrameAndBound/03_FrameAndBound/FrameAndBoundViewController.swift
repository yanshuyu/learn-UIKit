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
    @IBOutlet weak var frameXLable: UILabel!
    @IBOutlet weak var frameYLable: UILabel!
    @IBOutlet weak var boundsXLable: UILabel!
    @IBOutlet weak var boundsYLable: UILabel!
    @IBOutlet weak var frameXSlider: UISlider!
    @IBOutlet weak var frameYSlider: UISlider!
    @IBOutlet weak var boundsXSlider: UISlider!
    @IBOutlet weak var boundsYSlider: UISlider!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        frameXSlider.value = Float( containerView.frame.origin.x )
        frameYSlider.value = Float( containerView.frame.origin.y )
        boundsXSlider.value = Float( containerView.bounds.origin.x )
        boundsYSlider.value = Float( containerView.bounds.origin.y )
        updateLable()
    }

    @IBAction func onSliding(_ sender: UISlider) {
        switch sender.tag {
        case 1:
            containerView.frame.origin.x = CGFloat( sender.value )
            updateLable()
        case 2:
            containerView.frame.origin.y = CGFloat( sender.value )
            updateLable()
        case 3:
            containerView.bounds.origin.x = CGFloat( sender.value )
            updateLable()
        case 4:
            containerView.bounds.origin.y = CGFloat( sender.value )
            updateLable()
        default:
            break
        }
    }
    
    func updateLable() {
        frameXLable.text = "Frame X: \(frameXSlider.value)"
        frameYLable.text = "Frame Y: \(frameYSlider.value)"
        boundsXLable.text = "Bounds X: \(boundsXSlider.value)"
        boundsYLable.text = "Bounds Y: \(boundsYSlider.value)"
    }
    
}

