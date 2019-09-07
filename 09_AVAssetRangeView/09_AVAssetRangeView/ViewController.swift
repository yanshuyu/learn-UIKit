//
//  ViewController.swift
//  09_AVAssetRangeView
//
//  Created by sy on 2019/9/1.
//  Copyright © 2019 sy. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {

    @IBOutlet weak var videoThumbView_1: VideoAssetThumbnailView!
    @IBOutlet weak var videoThumbView_2: VideoAssetThumbnailView!
    @IBOutlet weak var waveformView_1: AudioAssetWaveformView!
    @IBOutlet weak var waveformView_2: AudioAssetWaveformView!
    @IBOutlet weak var waveformView_3: AudioAssetWaveformView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let videoURL = Bundle.main.url(forResource: "redPanda", withExtension: "mp4")

        self.videoThumbView_1.preferredThumbnailAspectRatio = 0
        self.videoThumbView_1.setAssetURL(url: videoURL, prepareCompletionHandler: nil)
        self.videoThumbView_2.setAssetURL(url: videoURL, prepareCompletionHandler: nil)
    
        //self.waveformView_1.waveStyle = .WaveStyleAsymmetric
        self.waveformView_1.setAssetURL(url: videoURL, prepareCompletionHandler: nil)
        
        
        self.waveformView_2.downsamplePolicy = .DownsamplePolicyMin
        //self.waveformView_2.waveStyle = .WaveStyleAsymmetric
        self.waveformView_2.setAssetURL(url: videoURL, prepareCompletionHandler: nil)
        
        self.waveformView_3.downsamplePolicy = .DownsamplePolicyAverage
        //self.waveformView_3.waveStyle = .WaveStyleAsymmetric
        self.waveformView_3.setAssetURL(url: videoURL, prepareCompletionHandler: nil)
    }


}

