//
//  SYRangeSlider.swift
//  11_CustomControl
//
//  Created by sy on 2020/1/31.
//  Copyright © 2020 sy. All rights reserved.
//

import UIKit

@IBDesignable
class SYRangeSlider: UIControl {
    //
    // MARK: - public property
    //
    public var minimumValue: CGFloat = 0 {
        didSet {
            if self.minimumValue != oldValue {
                if self.minimumValue > self.lowerValue {
                    self.lowerValue = self.minimumValue
                }
            }
            layoutSubLayers()
        }
    }
    public var maximumValue: CGFloat = 10 {
        didSet {
            if self.maximumValue != oldValue {
                if self.maximumValue < self.upperValue {
                    self.upperValue = self.maximumValue
                }
                layoutSubLayers()
            }
        }
    }
    public var lowerValue: CGFloat = 0 {
        didSet {
            if self.lowerValue != oldValue {
                if self.lowerValue < self.minimumValue {
                    self.minimumValue = self.lowerValue
                }
                if self.lowerValue > self.upperValue {
                    self.upperValue = self.lowerValue
                }
                
                layoutSubLayers()
                
                if self.slidingKnob != nil {
                    sendActions(for: .valueChanged)
                }
            }
        }
    }
    public var upperValue: CGFloat = 6 {
        didSet {
            if self.upperValue != oldValue {
                if self.upperValue < self.lowerValue {
                    self.lowerValue = self.upperValue
                }
                if self.upperValue > self.maximumValue {
                    self.maximumValue = self.upperValue
                }
                
                layoutSubLayers()
    
                if self.slidingKnob != nil {
                    sendActions(for: .valueChanged)
                }
            }
        }
    }
    
    public var roundness: CGFloat {
        get {
            return self.trackLayer.roundness
        }
        set {
            self.trackLayer.roundness = newValue
        }
    }
    //
    // MARK: - private property
    //
    private let defaultHeight: CGFloat = 30
    private let defaultTrackHeightScaleFactor: CGFloat = 1 / 5
    
    private var usableTrackLength: CGFloat {
        return self.bounds.width - self.defaultHeight
    }
    
    private class SYRangeSliderKnobLayer: CALayer {
        
    }
    
    private class SYRangeSliderTrackLayer: CALayer {
        public var trackColor: CGColor = UIColor.lightGray.cgColor
        public var rangeColor: CGColor = UIColor.blue.cgColor
        public var roundness: CGFloat = 1.0
        public var rangStart: CGFloat = 0.0
        public var rangEnd: CGFloat = 1.0
        
        private var roundRadius: CGFloat {
            return self.bounds.height * 0.5 * self.roundness
        }
        
        override func draw(in ctx: CGContext) {
            // draw background track
            let trackPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: self.roundRadius)
            ctx.setFillColor(self.trackColor)
            ctx.addPath(trackPath.cgPath)
            ctx.fillPath()
        }
    }
    
    private var trackLayer: SYRangeSliderTrackLayer!
    private var leftKnobLayer: SYRangeSliderKnobLayer!
    private var rightKnobLayer: SYRangeSliderKnobLayer!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.darkGray.cgColor
        
        self.trackLayer = SYRangeSliderTrackLayer()
        self.layer.addSublayer(self.trackLayer)
        self.trackLayer.backgroundColor = UIColor.lightGray.cgColor
        
        self.leftKnobLayer = SYRangeSliderKnobLayer()
        self.layer.addSublayer(self.leftKnobLayer)
        self.leftKnobLayer.backgroundColor = UIColor.darkGray.cgColor
        
        self.rightKnobLayer = SYRangeSliderKnobLayer()
        self.layer.addSublayer(self.rightKnobLayer)
        self.rightKnobLayer.backgroundColor = UIColor.darkGray.cgColor
        
        self.roundness = 1.0
        
        layoutSubLayers()
    }
    
    //
    // MARK: - layout
    //
    private func layoutSubLayers() {
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        let trackHeight = self.defaultHeight * self.defaultTrackHeightScaleFactor
        self.trackLayer.frame = CGRect(x: 0,
                                       y: self.bounds.midY - trackHeight/2,
                                       width: self.bounds.width,
                                       height: trackHeight)
        
        self.leftKnobLayer.frame = CGRect(origin: CGPoint.zero,
                                          size: CGSize(width: self.defaultHeight, height: self.defaultHeight))
        self.leftKnobLayer.position = centerForValue(self.lowerValue)
        
        self.rightKnobLayer.frame = CGRect(origin: CGPoint.zero,
                                           size: CGSize(width: self.defaultHeight, height: self.defaultHeight))
        self.rightKnobLayer.position = centerForValue(self.upperValue)
        CATransaction.commit()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        //layoutSubLayers()
    }
        
    //
    // MARK:- user interaction
    //
    private var lastTouchPosition: CGPoint = CGPoint.zero
    private var slidingKnob: CALayer?
    
    override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        let hitPoint = touch.location(in: self)
        let hitLeftKnob = self.leftKnobLayer.frame.contains(hitPoint)
        if hitLeftKnob {
            self.lastTouchPosition = hitPoint
            self.slidingKnob = self.leftKnobLayer
        }
        
        let hitRightKnob = self.rightKnobLayer.frame.contains(hitPoint)
        if hitRightKnob {
            self.lastTouchPosition = hitPoint
            self.slidingKnob = self.rightKnobLayer
        }
        
        if hitLeftKnob || hitRightKnob {
            sendActions(for: .touchDown)
        }
        return hitLeftKnob || hitRightKnob
    }
    
    override func continueTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        let hitPoint = touch.location(in: self)
        // update lower, upper value
        if let slidingKnob = self.slidingKnob {
            let positionDetal = hitPoint.x - self.lastTouchPosition.x
            let valueDetal = (positionDetal / self.usableTrackLength) * (self.maximumValue - self.minimumValue)
            
            if slidingKnob == self.leftKnobLayer {
                var value = self.lowerValue + valueDetal
                trimVaule(&value, lowerBound: self.minimumValue, upperBound: self.upperValue)
                self.lowerValue = value
                
            } else if slidingKnob == self.rightKnobLayer {
                var value =  self.upperValue + valueDetal
                trimVaule(&value, lowerBound: self.lowerValue, upperBound: self.maximumValue)
                self.upperValue = value
            }
            
            self.lastTouchPosition = hitPoint
            
            if positionDetal > 0 {
                let event: UIControl.Event = self.bounds.contains(hitPoint) ?  .touchDragInside : .touchDragOutside
                sendActions(for: event)
            }
        }
        
        return true
    }
    
    override func endTracking(_ touch: UITouch?, with event: UIEvent?) {
        self.lastTouchPosition = CGPoint.zero
        self.slidingKnob = nil
        if let _ = touch {
            let hitPoint = touch!.location(in: self)
            let event: UIControl.Event = self.bounds.contains(hitPoint) ? .touchUpInside : .touchUpOutside
            sendActions(for: event)
        }
    }
    
    //
    // MARK:- helper
    //
    private func centerForValue(_ value: CGFloat) -> CGPoint {
        let x = (value - self.minimumValue) / (self.maximumValue - self.minimumValue) * self.usableTrackLength + self.defaultHeight * 0.5
        let y = self.bounds.midY
        return CGPoint(x: x, y: y)
    }
    
    private func trimVaule(_ value: inout CGFloat, lowerBound: CGFloat, upperBound: CGFloat) {
        value = max(value, lowerBound)
        value = min(value, upperBound)
    }
}
