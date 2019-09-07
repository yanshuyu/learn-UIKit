//
//  AudioAssetWaveformView.swift
//  09_AVAssetRangeView
//
//  Created by sy on 2019/9/2.
//  Copyright © 2019 sy. All rights reserved.
//

import UIKit
import AVFoundation

class AudioAssetWaveformView: AVAssetVisualView {
    enum DownsamplePolicy {
        case DownsamplePolicyMax
        case DownsamplePolicyMin
        case DownsamplePolicyAverage
    }
    
    enum WaveStyle {
        case WaveStyleSymmetric
        case WaveStyleAsymmetric
    }
    
    private var rowAudioSamples: NSData?
    private var filterAudioSamples: [Int16]?
    
    var downsamplePolicy: DownsamplePolicy = .DownsamplePolicyMax
    var waveStyle: WaveStyle = .WaveStyleSymmetric
    var foregroundColor: UIColor
    
    private var defaultForegroundColor = #colorLiteral(red: 0.721568644, green: 0.8862745166, blue: 0.5921568871, alpha: 1)
    private var defaultBackgroundColor = #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1)
    private var defaultRenderInset  = CGSize(width: 4, height: 4)
    private var defaaultDownsamplePolicy = DownsamplePolicy.DownsamplePolicyMax
    
    override init(frame: CGRect) {
        self.foregroundColor = defaultForegroundColor
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.foregroundColor = defaultForegroundColor
        super.init(coder: aDecoder)
        setupView()
    }
    
    
    private func setupView() {
        self.foregroundColor = self.defaultForegroundColor
        self.backgroundColor = self.defaultBackgroundColor
        self.renderingAeraInset = self.defaultRenderInset
        self.layer.cornerRadius = 3
        self.layer.masksToBounds = true
    }
    
    
    override func prepareForVisualized(compeletionHandler: AVAssetVisualViewPrepareCompeletionHandler?) {
        if let asset = self.asset {
            if asset.tracks(withMediaType: .audio).count <= 0 {
                print("[AudioAssetWaveformView DEBUG] try to read audio samples for asset: \(asset) didn't have any audio track.")
                return
            }
            
            let renderSize = self.bounds.insetBy(dx: self.renderingAeraInset.width, dy: self.renderingAeraInset.height).size
            DispatchQueue.global(qos: .userInitiated).async { [weak self] in
                // read asset audio track audio samples
                self?.rowAudioSamples = self?.fetchAudioSamples(for: asset, at: self?.timeRange ?? CMTimeRange(start: CMTime.zero, end: CMTime.positiveInfinity))
                
                // downsample audio samples for rendering
                if let rowAudioSamples = self?.rowAudioSamples {
                   self?.filterAudioSamples = self?.downsampleAudioSample(samples: rowAudioSamples, for: renderSize, with: self?.downsamplePolicy ?? DownsamplePolicy.DownsamplePolicyMax)
                }
                
                if let _ = self?.rowAudioSamples, let _ = self?.filterAudioSamples {
                    self?.prepared = true
                    DispatchQueue.main.async {
                        //self?.layoutSubviews()
                        self?.setNeedsDisplay()
                    }
                    
                    if let ch = compeletionHandler {
                        ch()
                    }
                }
            }

        }
    }
    
    private func fetchAudioSamples(for asset: AVAsset, at timeRange: CMTimeRange) -> NSData? {
        let readedSamples = NSMutableData()
        if asset.tracks(withMediaType: .audio).count <= 0 {
            return nil;
        }
        guard let assetReader = try? AVAssetReader(asset: asset) else {
            return nil
        }
        assetReader.timeRange = timeRange
        let audioTrack = asset.tracks(withMediaType: .audio).first
        let outputSetting = [
            AVFormatIDKey : kAudioFormatLinearPCM,
            AVLinearPCMIsFloatKey : false,
            AVLinearPCMIsBigEndianKey : false,
            AVLinearPCMBitDepthKey : 16,
            ] as [String : Any]
        let assetReaderTrackOutput = AVAssetReaderTrackOutput(track: audioTrack!, outputSettings: outputSetting);
        assetReader.add(assetReaderTrackOutput)
        assetReader.startReading()
        
        while assetReader.status == .reading {
            if let audioSampleBuffer = assetReaderTrackOutput.copyNextSampleBuffer(),
                let audioBlockBuffer =  CMSampleBufferGetDataBuffer(audioSampleBuffer) {
                let blockLength = CMBlockBufferGetDataLength(audioBlockBuffer)
                var bytesBuffer = Array<UInt8>(repeating: 0, count: blockLength)
                CMBlockBufferCopyDataBytes(audioBlockBuffer, atOffset: 0, dataLength: blockLength, destination: &bytesBuffer)
                readedSamples.append(&bytesBuffer, length: blockLength)
                CMSampleBufferInvalidate(audioSampleBuffer)
            }
        }
        
        switch assetReader.status {
        case .cancelled:
            return nil
        case .failed:
            print("[AudioAssetWaveformView DEBUG] failed to fetch audio samples for asset: \(asset), error: \(String(describing: assetReader.error))")
            return nil
        default:
            break
        }
        
        return readedSamples
    }
    
    private func downsampleAudioSample(samples srcSamples: NSData, for renderSize: CGSize, with samplePolicy: DownsamplePolicy) -> [Int16] {
        let count = Int(renderSize.width)
        let height = self.waveStyle == .WaveStyleSymmetric ? Int(renderSize.height * 0.5) : Int(renderSize.height)
        
        if srcSamples.isEmpty || count <= 0 {
            return []
        }
        
        let byteCntPerSample = MemoryLayout<Int16>.size
        let srcSampleCnt = srcSamples.count / byteCntPerSample
        let binSampleCnt = (srcSampleCnt / count)
        var filteredSamples = [Int16](repeating: 0, count: count)
        var i = 0
        
        while i < count {
            let rangeSamples = srcSamples.subdata(with: NSRange(location: i * binSampleCnt * byteCntPerSample , length: binSampleCnt * byteCntPerSample))
            let processValue = rangeSamples.withUnsafeBytes{ (samplePtr: UnsafePointer<Int16>) -> Int16 in
                let sampleBufferPtr = UnsafeBufferPointer<Int16>(start: samplePtr, count: binSampleCnt)
                var sampleValue: Int16 = 0
                var sum: Int = 0
                
                switch samplePolicy {
                case .DownsamplePolicyMax:
                    for value in sampleBufferPtr {
                        if value > sampleValue {
                            sampleValue = value
                        }
                    }
                    break
                case .DownsamplePolicyMin:
                    for value in sampleBufferPtr {
                        if value < sampleValue {
                            sampleValue = value
                        }
                    }
                    break
                    
                case .DownsamplePolicyAverage:
                    for value in sampleBufferPtr {
                        sum += Int(value)
                    }
                    sampleValue = Int16(sum / binSampleCnt)
                    break
                } 
                
                return sampleValue
            }
            
            filteredSamples[i] = processValue
            i += 1
        }
        

        filteredSamples = filteredSamples.map { (value: Int16) -> Int16 in
            let roundValue = value == Int16.min ? value + 1 : value
            return abs(roundValue)
        }
        
        if let maxValue = filteredSamples.max() {
            let scaleFactor =  Float(height) / Float(maxValue)
            filteredSamples = filteredSamples.map({ (value: Int16) -> Int16 in
                return Int16(Float(value) * scaleFactor)
            })
        }
        
        return filteredSamples
    }
    
    override func reset() {
        super.reset()
        self.rowAudioSamples = nil
        self.filterAudioSamples = nil
        setupView()
    }
    
    override func draw(_ rect: CGRect) {
        if let filterSamples = self.filterAudioSamples, filterSamples.count > 0 {
            self.foregroundColor.setStroke()
            let wavePath = UIBezierPath()
            for (index, sampleVaule) in filterSamples.enumerated() {
                let startPointX = self.renderingAeraInset.width + CGFloat(index)
                let startPointY = self.waveStyle == .WaveStyleSymmetric ? self.bounds.height * 0.5 + CGFloat(sampleVaule ) : self.bounds.height - self.renderingAeraInset.height
                let endPointX = startPointX
                let endPointY = self.waveStyle == .WaveStyleSymmetric ? self.bounds.height * 0.5 - CGFloat(sampleVaule ) : self.bounds.height - self.renderingAeraInset.height - CGFloat(sampleVaule)
                
                wavePath.move(to: CGPoint(x: startPointX, y: startPointY))
                wavePath.addLine(to: CGPoint(x: endPointX, y: endPointY))
            }
            
            wavePath.stroke()
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if let audioSamples = self.rowAudioSamples,  self.prepared {
            let renderSize = self.bounds.insetBy(dx: self.renderingAeraInset.width, dy: self.renderingAeraInset.height).size
            self.filterAudioSamples = downsampleAudioSample(samples: audioSamples,
                                                            for: renderSize,
                                                            with: self.downsamplePolicy)
            setNeedsDisplay()
        }
    }

}
