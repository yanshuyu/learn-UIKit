//
//  CATransitionViewController.swift
//  05_CoreAnimation
//
//  Created by sy on 2019/8/23.
//  Copyright © 2019 sy. All rights reserved.
//

import UIKit

class CATransitionViewController: UIViewController {
    @IBOutlet var imageViews: [UIImageView]!
    
    private lazy var images: [UIImage?] = {
        let images = [
            UIImage(named: "IMG_0448"),
            UIImage(named: "IMG_0483"),
            UIImage(named: "IMG_0606"),
            UIImage(named: "IMG_1170"),
            UIImage(named: "IMG_1174")
        ]
        return images
    }()
    
    private lazy var transitionTypes: [CATransitionType] = {
        let transitionTypes = [CATransitionType.fade,
        CATransitionType.push,
        CATransitionType.reveal]
        
        return transitionTypes
    }()
    
    override func viewDidLoad() {
        for imageView in self.imageViews {
            imageView.image = self.images[Int(arc4random())%self.images.count]
        }
    }
    
    @IBAction func changeImage(_ sender: UIButton) {
        if let imageView = getImageViewWithTag(sender.tag),
            let transition = getTransitionWithTag(sender.tag) {
            changeImage(self.images[Int(arc4random())%self.images.count]!, forImageView: imageView, withTransiton: transition)
        }
    }

    func getImageViewWithTag(_ tag: Int) -> UIImageView? {
        if (tag >= 0 && tag < self.imageViews.count) {
            return self.imageViews[tag]
        }
        return nil
    }
    
    func getTransitionWithTag(_ tag: Int) -> CATransition? {
        let transition = CATransition()
        transition.type = .fade
        if (tag >= 0 && tag < self.transitionTypes.count) {
            transition.type = self.transitionTypes[tag]
        }
        return transition
    }
    
    func changeImage(_ image: UIImage, forImageView imageView: UIImageView, withTransiton transition: CATransition) {
        imageView.layer.removeAnimation(forKey: kCATransition)
        imageView.layer.add(transition, forKey: kCATransition)
        imageView.image = image
    }
    
}
