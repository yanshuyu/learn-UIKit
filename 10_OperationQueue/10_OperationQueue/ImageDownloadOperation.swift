//
//  ImageDownloadOperation.swift
//  10_OperationQueue
//
//  Created by sy on 2019/9/11.
//  Copyright © 2019 sy. All rights reserved.
//

import UIKit

class ImageDownloadOperation: Operation {
    private var photoRecord: PhotoRecord
    
    init(_ photoRecord: PhotoRecord) {
        self.photoRecord = photoRecord
    }
    
    override func main() {
        if self.isCancelled {
            return
        }
        
        if photoRecord.status == .Downloaded || photoRecord.status == .Filtered {
            return
        }
        
        guard let image = downloadPhoto(url: photoRecord.url) else {
            photoRecord.status = .Filtered
            photoRecord.image = UIImage(named: "Failed")
            return
        }
        
        if self.isCancelled {
            return
        }
        
        photoRecord.status = .Downloaded
        photoRecord.image = image
    }
    
    private func downloadPhoto(url: URL) -> UIImage? {
        if let photoData = try? Data(contentsOf: url) {
            if let image = UIImage(data: photoData) {
                return image
            }
        }
        
        return nil
    }
}
