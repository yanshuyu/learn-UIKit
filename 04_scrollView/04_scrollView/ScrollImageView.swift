//
//  ScrollImageView.swift
//  04_scrollView
//
//  Created by sy on 2019/5/27.
//  Copyright © 2019 sy. All rights reserved.
//

import UIKit

class ScrollImageView: UIScrollView {
    private var imageView: UIImageView? = nil
    private var unzoomImageSize = CGSize.zero
    var index: Int = -1
    
    var doubleTappingEnable = true
    lazy var tappingGesture: UITapGestureRecognizer = {
        var gesture = UITapGestureRecognizer(target: self, action: #selector(handleTappingGesture(_:)))
        gesture.numberOfTapsRequired = 2
        return gesture
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        customInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        customInit()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        centerImage()
       // print(" from layoutSubviews()")
    }
    
    
    private func customInit()
    {
        self.showsHorizontalScrollIndicator = false
        self.showsVerticalScrollIndicator = false
        self.decelerationRate = UIScrollView.DecelerationRate.fast
        self.delegate = self
    }
    

    func show(image: UIImage?, at index: Int) -> Void {
        self.imageView?.removeFromSuperview()
        self.imageView = nil;
        self.index = -1
        
        if let targetImage = image {
            self.imageView = UIImageView(image: targetImage)
            guard let imageView = self.imageView else {
                return
            }
            
            self.index = index
            imageView.sizeToFit()
            addSubview(imageView)
            self.unzoomImageSize = targetImage.size
            configForImage(size: targetImage.size)
        }
    }
    
    
    func show(path: String, at index: Int) -> Void {
        let image = UIImage(contentsOfFile: path)
        show(image: image, at: index)
    }
    
    
    func notifyFrameWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) -> Void {
        self.setMinMaxScaleForImage()
        var scale = self.zoomScale
        scale = max(scale, self.minimumZoomScale)
        scale = min(scale, self.maximumZoomScale)
        self.zoomScale = scale
        self.centerImage()
        
//        coordinator.animate(alongsideTransition: nil, completion: {  _ in
//            self.setMinMaxScaleForImage()
//            var scale = self.zoomScale
//            scale = max(scale, self.minimumZoomScale)
//            scale = min(scale, self.maximumZoomScale)
//            self.zoomScale = scale
//            self.centerImage()
//            //print(" from frameWillTransition()")
//        })
    }
    
    
    func configForImage(size: CGSize) -> Void {
        self.contentSize = size
        setMinMaxScaleForImage()
        self.imageView?.addGestureRecognizer(self.tappingGesture)
        self.imageView?.isUserInteractionEnabled = true
        self.zoomScale = self.minimumZoomScale
    }
    
    
    func setMinMaxScaleForImage() -> Void {
        guard let _ = self.imageView else {
            return
        }
        
        let scrollViewSize = self.frame.size
        let imageViewSize = self.unzoomImageSize
        let xScale = scrollViewSize.width / imageViewSize.width
        let yScale = scrollViewSize.height / imageViewSize.height
        
        let minScale = min(xScale, yScale)
        var maxScale = 1.0
        if minScale < 0.1 {
            maxScale = 0.3
        }else if maxScale < 0.5 {
            maxScale = 0.7
        }else{
            maxScale = (Double)(max(1.0, minScale))
        }
        
        self.minimumZoomScale = CGFloat(minScale)
        self.maximumZoomScale = CGFloat(maxScale)
        //print("setMinMaxScaleForImage() called: nminScale: \(minScale), maxScale: \(maxScale)")
    }
    

    func centerImage() -> Void {
        guard let imageView = self.imageView else {
            return
        }
        
        var imageViewFrame = imageView.frame
        let scrollViewSize = self.bounds.size
        let imageViewSize = imageViewFrame.size
        //print("centerImage() called: imageFrame: \(imageViewFrame), scrollViewContentZoom: \(self.zoomScale)")
        // center horizontally
        if imageViewSize.width < scrollViewSize.width {
            imageViewFrame.origin.x = (scrollViewSize.width - imageViewSize.width)*0.5
        } else {
            imageViewFrame.origin.x = 0
        }
        
        // center vertically
        if imageViewSize.height < scrollViewSize.height {
            imageViewFrame.origin.y = (scrollViewSize.height - imageViewSize.height)*0.5
        } else {
            imageViewFrame.origin.y = 0
        }
        
        imageView.frame = imageViewFrame
    }
    
    
    func zoomTo(location point: CGPoint, with scale: CGFloat) -> Void {
        if self.minimumZoomScale == self.maximumZoomScale && self.minimumZoomScale > 1 {
            return
        }
        
        var zoomRect = CGRect.zero
        zoomRect.size.width = self.bounds.size.width / scale
        zoomRect.size.height = self.bounds.size.height / scale
        zoomRect.origin.x = point.x - zoomRect.size.width * 0.5
        zoomRect.origin.y = point.y - zoomRect.size.height * 0.5
        self.zoom(to: zoomRect, animated: true)
    }
    

    // tapping gesture handler
    @objc func handleTappingGesture(_ gesture: UITapGestureRecognizer) -> Void {
        let location = gesture.location(in: gesture.view)
        var scale = self.maximumZoomScale
        if self.zoomScale == self.maximumZoomScale {
            scale = self.minimumZoomScale
        }
        
        zoomTo(location: location, with: scale)
    }
}



extension ScrollImageView: UIScrollViewDelegate {
    // return a view that will be scaled. if delegate returns nil, nothing happens
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.imageView
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        centerImage()
        //print(" from scrollViewDidZoom()")
    }
}
