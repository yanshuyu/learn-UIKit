//
//  VideoAssetThumbnailView.swift
//  09_AVAssetRangeView
//
//  Created by sy on 2019/9/1.
//  Copyright © 2019 sy. All rights reserved.
//

import UIKit
import AVFoundation

let VideoAssetThumbnailView_DEBUG_MODE = false

class VideoAssetThumbnailView: AVAssetVisualView  {
    var preferredThumbnailAspectRatio: CGFloat
    private var imageGenerator: AVAssetImageGenerator?
    private var thumbnails: [UIImage]?
    
    override init(frame: CGRect) {
        self.preferredThumbnailAspectRatio = 1
        super.init(frame: frame)
        setUpview()
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.preferredThumbnailAspectRatio = 1
        super.init(coder: aDecoder)
        setUpview()
    }
    
    
    internal func setUpview() {
        self.layer.masksToBounds = true
        self.layer.cornerRadius = 3
        self.backgroundColor = UIColor.black
        if VideoAssetThumbnailView_DEBUG_MODE {
            self.layer.borderWidth = 1
            self.layer.borderColor = UIColor.red.cgColor
        }
    }
    
    override func prepareForVisualized(compeletionHandler: AVAssetVisualViewPrepareCompeletionHandler?) {
        clearThumbnails()
        if let asset = self.asset {
            if asset.tracks(withMediaType: .video).count <= 0 {
                print("[VideoAssetThumbnailView DEBUG] try to generate thumbnails for asset: \(asset) didn't have any video track.")
                return
            }
            
            self.imageGenerator = AVAssetImageGenerator(asset: asset)
            self.thumbnails = []
            let renderAreaSize = self.bounds.insetBy(dx: self.renderingAeraInset.width, dy: self.renderingAeraInset.height)
            let thumbnailSize = getThumbnailSize()
            let thumbnailCnt = Int(ceil(renderAreaSize.width / thumbnailSize.width))
            
            //let assetTimeRange = CMTimeRange(start: CMTime.zero, end: asset.duration)
            //let renderingTimeRange = self.timeRange.intersection(assetTimeRange)
            let renderingTimeRange = self.timeRange
            if renderingTimeRange.isValid {
                print("[VideoAssetThumbnailView DEBUG] generating thumbnails for asset: \(asset)  at time range: ")
                CMTimeRangeShow(renderingTimeRange)
                generateThumbnails(imageGenerator: self.imageGenerator!,
                                   timeRange: renderingTimeRange,
                                   thumbnailSize: thumbnailSize,
                                   thumbnailCount: thumbnailCnt,
                                   compeletionHandler: compeletionHandler)
            } else {
                print("[VideoAssetThumbnailView DEBUG] : fail to generating thumbnails for asset: \(asset) at time range: ")
                CMTimeRangeShow(self.timeRange)
            }
        }
    }
    
    private func generateThumbnails(imageGenerator: AVAssetImageGenerator, timeRange: CMTimeRange, thumbnailSize: CGSize, thumbnailCount: Int, compeletionHandler: AVAssetVisualViewPrepareCompeletionHandler?) {
        var timePoints: [NSValue] = []
        let timeInterval = CMTimeGetSeconds(timeRange.duration) / Float64(thumbnailCount)
        for  index in  0..<thumbnailCount {
            let timePoint = CMTimeAdd(timeRange.start, CMTimeMakeWithSeconds( Double(index) * timeInterval, preferredTimescale: timeRange.duration.timescale))
            timePoints.append(NSValue(time: timePoint))
        }
        var generatedThumbnailCnt: Int = 0
        imageGenerator.maximumSize = thumbnailSize
        imageGenerator.appliesPreferredTrackTransform = true
        imageGenerator.generateCGImagesAsynchronously(forTimes: timePoints) { [weakSelf = self] (requestTime:CMTime, outputImage:CGImage?, actualTime:CMTime, result:AVAssetImageGenerator.Result, error:Error?) in
            if let image = outputImage, result == .succeeded {
                weakSelf.thumbnails?.append(UIImage(cgImage: image, scale: UIScreen.main.scale, orientation: .up))
                generatedThumbnailCnt += 1
            } else  if result != .cancelled {
                weakSelf.thumbnails?.append(weakSelf.defaultThumbnailPlaceHodler())
                generatedThumbnailCnt += 1
            } else {
                return
            }
            
            if generatedThumbnailCnt == thumbnailCount {
                weakSelf.prepared = true
                DispatchQueue.main.async(execute: {
                    weakSelf.setNeedsDisplay()
                })
                if let ch = compeletionHandler {
                    ch()
                }
            }
        }
        
    }
    
    private func getThumbnailSize() -> CGSize {
        var actualAspectRatio = self.preferredThumbnailAspectRatio
        if actualAspectRatio == 0, let asset = self.asset {
            // use video asset aspect ratio
            if let track = asset.tracks(withMediaType: .video).first {
                actualAspectRatio = track.naturalSize.width / track.naturalSize.height
            } else {
                actualAspectRatio = 1
            }
        }
        let renderAreaSize = self.bounds.insetBy(dx: self.renderingAeraInset.width, dy: self.renderingAeraInset.height)
        let size = CGSize(width: actualAspectRatio * renderAreaSize.height, height:renderAreaSize.height)
        return size
    }
    
    
    
    func defaultThumbnailPlaceHodler() -> UIImage {
        return UIImage(named: "thumbnailPlaceholder")!
    }
    
    func clearThumbnails() {
        self.imageGenerator?.cancelAllCGImageGeneration()
        self.imageGenerator = nil
        self.thumbnails = nil
        self.prepared = false
    }
    
    
    override func reset() {
        clearThumbnails()
        self.preferredThumbnailAspectRatio = 1
        self.imageGenerator = nil
        self.thumbnails = nil
        super.reset()
    }
    
    override func draw(_ rect: CGRect) {
        guard let thumbnails = self.thumbnails else { return }
        
        for (index, image) in thumbnails.enumerated() {
            var targetRect = CGRect.zero
            let thumbnailSize = getThumbnailSize()
            targetRect.origin = CGPoint(x: CGFloat(index) * thumbnailSize.width + self.renderingAeraInset.width, y: self.renderingAeraInset.height)
            targetRect.size = thumbnailSize
            image.draw(in: targetRect)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setAsset(asset: self.asset, prepareCompletionHandler: nil)
    }
}
