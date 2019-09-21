//
//  ImageProcessor.swift
//  07_IOSDrawing
//
//  Created by sy on 2019/9/21.
//  Copyright © 2019 sy. All rights reserved.
//

import Foundation
import UIKit

enum ThumbnailContentMode {
    case AspectRatioFit
    case AspectRatioFill
    case Stretch
}

class ImageProcessor {
    class func generateThumbnail(image: UIImage, for size: CGSize, using mode: ThumbnailContentMode) -> UIImage? {
        let srcRect = CGRect(origin: CGPoint.zero, size: image.size)
        let targetRect = CGRect(origin: CGPoint.zero, size: size)

        var drawRect = CGRect.zero
        switch mode {
        case .Stretch:
            drawRect = CGRect(origin: CGPoint.zero, size: size)
            break
        case .AspectRatioFit:
            drawRect = rectByFitRect(srcRect: srcRect, targetRect: targetRect)
            break
        case .AspectRatioFill:
            drawRect = rectByFillRect(srcRect: srcRect, targetRect: targetRect)
            break
        }
        
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        image.draw(in: drawRect)
        let thumbnailImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return thumbnailImage
    }
    
    class func sizeByScale(size: CGSize, scale: CGFloat) -> CGSize {
        return CGSize(width: size.width * scale, height: size.height * scale);
    }
    
    
    class func rectByFitRect(srcRect: CGRect, targetRect: CGRect) -> CGRect {
        let scaleW = targetRect.width / srcRect.width
        let scaleH = targetRect.height / srcRect.height
        let scale = min(scaleW, scaleH)
        let fitSize = sizeByScale(size: srcRect.size, scale: scale)
        let fitOrigin = CGPoint(x: targetRect.midX - fitSize.width * 0.5, y: targetRect.midY - fitSize.height * 0.5)
        return CGRect(origin: fitOrigin, size: fitSize)
    }
    
    class func rectByFillRect(srcRect: CGRect, targetRect: CGRect) -> CGRect {
        let scaleW = targetRect.width / srcRect.width
        let scaleH = targetRect.height / srcRect.height
        let scale = max(scaleW, scaleH)
        let fillSize = sizeByScale(size: srcRect.size, scale: scale)
        let fillOrigin = CGPoint(x: targetRect.midX - fillSize.width * 0.5, y: targetRect.midY - fillSize.height * 0.5)
        return CGRect(origin: fillOrigin, size: fillSize)
    }
    
}
