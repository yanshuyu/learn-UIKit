//
//  TransformViewController.swift
//  05_CoreAnimation
//
//  Created by sy on 2019/7/15.
//  Copyright © 2019 sy. All rights reserved.
//

import UIKit

class TransformViewController: UIViewController {
    @IBOutlet weak var imageView1: UIImageView!
    @IBOutlet weak var imageView2: UIImageView!
    @IBOutlet weak var imageView3: UIImageView!
    @IBOutlet weak var angleSlider: UISlider!
    @IBOutlet weak var distanceSlider: UISlider!
    @IBOutlet weak var angleLable: UILabel!
    @IBOutlet weak var distanceLable: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.imageView1.layer.borderWidth = 2
        self.imageView1.layer.borderColor = UIColor.blue.cgColor
        
        self.imageView2.layer.borderWidth = self.imageView1.layer.borderWidth
        self.imageView2.layer.borderColor = self.imageView1.layer.borderColor
        
        self.imageView3.layer.borderWidth = self.imageView1.layer.borderWidth
        self.imageView3.layer.borderColor = self.imageView1.layer.borderColor
        // disable back facing
        self.imageView3.layer.isDoubleSided = false;
        
        self.angleSlider.value = 0.25
        
        perform2DTransform(angleSlider.value)
        perform3DTransform(distanceSlider.value)
    }
    
    
    @IBAction func handleAngleSliding(_ sender: Any) {
        if let slider = sender as? UISlider {
            perform2DTransform(slider.value)
            perform3DTransform(self.distanceSlider.value)
        }
    }
    
    
    @IBAction func handleDistanceSliding(_ sender: UISlider) {
        perform3DTransform(sender.value)
    }
}



extension TransformViewController {
    func perform2DTransform(_ percent: Float) {
        // 2d transform
        let angle = .pi * 2 * percent
        let scale = CGAffineTransform(scaleX: 0.7, y: 0.7)
        let rotate = CGAffineTransform(rotationAngle: CGFloat(angle))
        let scale_rotate = scale.concatenating(rotate)
        self.imageView1.transform = scale_rotate
    }
    
    
    func perform3DTransform(_ percent: Float) {
        let minDistance :Float = 500
        let maxDistance :Float = 1000
        let distance = minDistance + (maxDistance - minDistance) * percent
        // 3d transform
        //enable perspective projection
        var perspective_z = CATransform3DIdentity
        perspective_z.m34 = CGFloat(-1 / distance)
        //        var diff_perpective_z = CATransform3DIdentity
        //        diff_perpective_z.m34 = -1 / 1000
        let scale_xy = CATransform3DScale(perspective_z, 0.7, 0.7, 0.7)
        
        //ensure all subviews share the same camera perspetive in order to share the same vanish point
        self.view.layer.sublayerTransform = perspective_z
        
        let maxAngle = CGFloat.pi
        let angle = CGFloat(self.angleSlider.value) * maxAngle;
        
        self.imageView2.layer.transform = CATransform3DRotate(scale_xy, angle, 0, 1, 0)
        //self.imageView3.layer.transform = CATransform3DRotate(diff_perpective_z, -.pi/4, 0, 1, 0)
        self.imageView3.layer.transform = CATransform3DRotate(scale_xy , -angle, 0, 1, 0)
    }
    
}
