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
    var subImageView: UIImageView?
    
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
        case .fetchSubImage:
            setupSubImageViews()
            break
        default:
            break
        }
    }
    
    private func setupThumbnailViews() {
        guard let originalImage = UIImage(named: "shanghai") else { return  }
        let originalImage400x400 = UIImageView(frame: CGRect(origin: CGPoint(x: 0, y: 80), size: CGSize(width: 400, height: 400)))
        originalImage400x400.contentMode = .scaleAspectFit
        originalImage400x400.image = originalImage
        originalImage400x400.backgroundColor = UIColor.lightGray
        self.view.addSubview(originalImage400x400)
        
        let thumnail200x200 = UIImageView(frame: CGRect(origin: CGPoint(x: 0, y: 400 + 80) , size: CGSize(width: 200, height: 200)))
        thumnail200x200.contentMode = .scaleAspectFit
        thumnail200x200.image = ImageProcessor.generateThumbnail(image: originalImage, for: CGSize(width: 200, height: 200), using: .Stretch)
        thumnail200x200.backgroundColor = UIColor.lightGray
        self.view.addSubview(thumnail200x200)
        
        let thumnail100x100 = UIImageView(frame: CGRect(origin: CGPoint(x: 0, y: 600 + 80), size: CGSize(width: 100, height: 100)))
        thumnail100x100.contentMode = .scaleAspectFit
        thumnail100x100.image = ImageProcessor.generateThumbnail(image: originalImage, for: CGSize(width: 100, height: 100), using: .AspectRatioFill)
        thumnail100x100.backgroundColor = UIColor.lightGray
        self.view.addSubview(thumnail100x100)
        
        let thumnail50x50 = UIImageView(frame: CGRect(origin: CGPoint(x: 0, y: 700 + 80), size: CGSize(width: 50, height: 50)))
        thumnail50x50.contentMode = .scaleAspectFit
        thumnail50x50.image = ImageProcessor.generateThumbnail(image: originalImage, for: CGSize(width: 50, height: 50), using: .AspectRatioFit)
        thumnail50x50.backgroundColor = UIColor.lightGray
        self.view.addSubview(thumnail50x50)
        
    }
    
    private func setupSubImageViews() {
        guard let originalImage = UIImage(named: "shanghai") else { return  }
      
        let originalImage400x400 = UIImageView(frame: CGRect(origin: CGPoint.zero, size: CGSize(width: 400, height: 400)))
        originalImage400x400.contentMode = .scaleAspectFit
        originalImage400x400.image = ImageProcessor.generateThumbnail(image: originalImage, for: CGSize(width: 400, height: 400), using: .AspectRatioFill)
        originalImage400x400.backgroundColor = UIColor.lightGray
        originalImage400x400.center = CGPoint(x: self.view.center.x, y: 80 + originalImage400x400.bounds.height * 0.5)
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapToGenerateSubImage(_:)))
        originalImage400x400.isUserInteractionEnabled = true
        originalImage400x400.addGestureRecognizer(tapRecognizer)
        self.view.addSubview(originalImage400x400)
        
        let subImageViewSize = CGSize(width: 150, height: 150)
        let subImageView = UIImageView(frame: CGRect(origin: CGPoint.zero, size: subImageViewSize))
        subImageView.contentMode = .scaleAspectFill
        subImageView.backgroundColor = UIColor.lightGray
        subImageView.center = CGPoint(x: originalImage400x400.center.x, y: originalImage400x400.frame.maxY + 40 + subImageViewSize.height * 0.5)
        self.view.addSubview(subImageView)
        self.subImageView = subImageView
    }
    
    @objc func tapToGenerateSubImage(_ recognizer: UITapGestureRecognizer) {
        guard let srcImageView = recognizer.view as? UIImageView else { return }
        let location = recognizer.location(in: srcImageView)
        print("tap location: \(location)")
        let subImageSize = CGSize(width: 50, height: 50)
        let subRect = CGRect(origin: CGPoint(x: location.x - subImageSize.width * 0.5, y: location.y - subImageSize.height * 0.5), size: subImageSize)
        self.subImageView?.image = ImageProcessor.generateSubImage(image: srcImageView.image!, in: subRect)
    }

}
