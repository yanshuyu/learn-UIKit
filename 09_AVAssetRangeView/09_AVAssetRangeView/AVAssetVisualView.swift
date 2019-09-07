//
//  AVAssetVisualView.swift
//  09_AVAssetRangeView
//
//  Created by sy on 2019/9/1.
//  Copyright © 2019 sy. All rights reserved.
//

import UIKit
import AVFoundation

typealias AVAssetVisualViewPrepareCompeletionHandler = () -> Void


class AVAssetVisualView: UIView {
    
    var asset: AVAsset?
    
    private var _timeRange: CMTimeRange
    var timeRange: CMTimeRange {
        set {
            _timeRange = newValue
        }
        get {
            return getAssetTimeRange()
        }
    }
    
    var renderingAeraInset: CGSize
    var prepared: Bool;
    
    override init(frame: CGRect) {
        self._timeRange = CMTimeRange.invalid
        self.renderingAeraInset = CGSize.zero
        self.prepared = false
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        self._timeRange = CMTimeRange.invalid
        self.renderingAeraInset = CGSize.zero
        self.prepared = false
        super.init(coder: aDecoder)
    }
    
    
    func prepareForVisualized(compeletionHandler: AVAssetVisualViewPrepareCompeletionHandler?) -> Void {

    }
    
    
    func setAsset(asset: AVAsset?, prepareCompletionHandler: AVAssetVisualViewPrepareCompeletionHandler? ) -> Void {
        self.asset = asset
        prepareForVisualized(compeletionHandler: prepareCompletionHandler)
    }
    
    func setAssetURL(url: URL?,  prepareCompletionHandler: AVAssetVisualViewPrepareCompeletionHandler?) -> Void {
        self.asset = nil
        if let _ = url {
            self.asset = AVAsset(url: url!)
        }
        prepareForVisualized(compeletionHandler: prepareCompletionHandler)
    }
    
    
    func reset() {
        self.asset = nil
        self.prepared = false
        self.renderingAeraInset = CGSize.zero
        self._timeRange = CMTimeRange.invalid
    }
    
    private func getAssetTimeRange() -> CMTimeRange {
        if let asset = self.asset {
            let assetTimeRange = CMTimeRange(start: CMTime.zero, duration: asset.duration)
            if self._timeRange.isValid {
                return self._timeRange.intersection(assetTimeRange)
            } else {
                return assetTimeRange
            }
        }
        return CMTimeRange.invalid
    }

}
