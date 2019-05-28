//
//  ViewController.swift
//  04_scrollView
//
//  Created by sy on 2019/5/27.
//  Copyright © 2019 sy. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var scrollImageView: ScrollImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.scrollImageView = ScrollImageView(frame: self.view.bounds)
        self.view.addSubview(self.scrollImageView)
        
        let top = NSLayoutConstraint(item: self.scrollImageView!, attribute: .top, relatedBy: .equal, toItem: self.view, attribute: .top, multiplier: 1, constant: 0)
        let left = NSLayoutConstraint(item: self.scrollImageView!, attribute: .left, relatedBy: .equal, toItem: self.view, attribute: .left, multiplier: 1, constant: 0)
        let bottom = NSLayoutConstraint(item: self.scrollImageView!, attribute: .bottom, relatedBy: .equal, toItem: self.view, attribute: .bottom, multiplier: 1, constant: 0)
        let right = NSLayoutConstraint(item: self.scrollImageView!, attribute: .right, relatedBy: .equal, toItem: self.view, attribute: .right, multiplier: 1, constant: 0)
        self.scrollImageView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addConstraints([top, left, bottom, right])
       
        self.scrollImageView.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        let butterflyPath = Bundle.main.path(forResource: "butterfly", ofType: "jpg");
        self.scrollImageView.show(path: butterflyPath!)
    }
    
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        self.scrollImageView.frameWillTransition(to: size, with: coordinator)
    }

    
}

