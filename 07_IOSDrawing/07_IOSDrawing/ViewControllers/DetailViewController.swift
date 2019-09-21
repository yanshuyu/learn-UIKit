//
//  DetailViewController.swift
//  07_IOSDrawing
//
//  Created by sy on 2019/9/21.
//  Copyright © 2019 sy. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    var detailMenuItem: DetailMenuItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let menuItem = detailMenuItem {
            self.title = menuItem.detailTitle
            setupDetailView()
        }
    }
    
    private func setupDetailView() {
        switch detailMenuItem!.detailType {
        case .fetchThumbnail:
            setupThumbnailViews()
            break
        default:
            break
        }
    }
    
    private func setupThumbnailViews() {
        guard let originalImage = UIImage(named: "shanghai") else { return  }
        let originalImage400x400 = UIImageView(frame: CGRect(origin: CGPoint.zero, size: CGSize(width: 400, height: 400)))
        originalImage400x400.contentMode = .scaleAspectFit
        originalImage400x400.image = originalImage
        originalImage400x400.backgroundColor = UIColor.lightGray
        self.view.addSubview(originalImage400x400)
        
        let thumnail200x200 = UIImageView(frame: CGRect(origin: CGPoint(x: 0, y: 400), size: CGSize(width: 200, height: 200)))
        thumnail200x200.contentMode = .scaleAspectFit
        thumnail200x200.image = ImageProcessor.generateThumbnail(image: originalImage, for: CGSize(width: 200, height: 200), using: .Stretch)
        thumnail200x200.backgroundColor = UIColor.lightGray
        self.view.addSubview(thumnail200x200)
        
        let thumnail100x100 = UIImageView(frame: CGRect(origin: CGPoint(x: 0, y: 600), size: CGSize(width: 100, height: 100)))
        thumnail100x100.contentMode = .scaleAspectFit
        thumnail100x100.image = ImageProcessor.generateThumbnail(image: originalImage, for: CGSize(width: 100, height: 100), using: .AspectRatioFill)
        thumnail100x100.backgroundColor = UIColor.lightGray
        self.view.addSubview(thumnail100x100)
        
        let thumnail50x50 = UIImageView(frame: CGRect(origin: CGPoint(x: 0, y: 700), size: CGSize(width: 50, height: 50)))
        thumnail50x50.contentMode = .scaleAspectFit
        thumnail50x50.image = ImageProcessor.generateThumbnail(image: originalImage, for: CGSize(width: 50, height: 50), using: .AspectRatioFit)
        thumnail50x50.backgroundColor = UIColor.lightGray
        self.view.addSubview(thumnail50x50)

        
    }

}
