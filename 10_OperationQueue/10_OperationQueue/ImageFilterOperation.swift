//
//  ImageFilterOperation.swift
//  10_OperationQueue
//
//  Created by sy on 2019/9/11.
//  Copyright © 2019 sy. All rights reserved.
//

import UIKit

class ImageFilterOperation: Operation {
    private var photoRecord: PhotoRecord
    
    init(_ photoRecord: PhotoRecord) {
        self.photoRecord = photoRecord
    }
    
    override func main() {
        if self.isCancelled {
            return
        }
        
        if self.photoRecord.status != .Downloaded {
            return
        }
        
        guard let image = applySepiaFilter(photoRecord.image!) else {
            return
        }
        
        if self.isCancelled {
            return
        }
        
        photoRecord.image = image
        photoRecord.status = .Filtered
        
    }
    
    private func applySepiaFilter(_ image: UIImage) -> UIImage? {
        sleep(1)
        if let imageData =  photoRecord.image?.pngData(),
            let inputImage = CIImage(data: imageData),
            let sepiaFilter = CIFilter(name: "CISepiaTone") {
            sepiaFilter.setValue(inputImage, forKey: kCIInputImageKey)
            sepiaFilter.setValue(0.8, forKey: "inputIntensity")
            if let outputImage = sepiaFilter.outputImage {
                let ciContext = CIContext(options: nil)
                if let outputCgImage = ciContext.createCGImage(outputImage, from: outputImage.extent) {
                    return UIImage(cgImage: outputCgImage)
                }
            }
        }
        
        return nil
    }
}
