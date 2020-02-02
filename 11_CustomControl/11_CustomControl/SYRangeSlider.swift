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
    @IBInspectable public var minimumValue: CGFloat = 0 {
        didSet {
            if self.minimumValue != oldValue {
                if self.minimumValue > self.lowerValue {
                    self.lowerValue = self.minimumValue
                }
            }
            layoutSubLayers()
        }
    }
    @IBInspectable public var maximumValue: CGFloat = 10 {
        didSet {
            if self.maximumValue != oldValue {
                if self.maximumValue < self.upperValue {
                    self.upperValue = self.maximumValue
                }
                layoutSubLayers()
            }
        }
    }
    @IBInspectable public var lowerValue: CGFloat = 0 {
        didSet {
            if self.lowerValue != oldValue {
                if self.lowerValue < self.minimumValue {
                    self.minimumValue = self.lowerValue
                }
                if self.lowerValue > self.upperValue {
                    self.upperValue = self.lowerValue
                }
                
                layoutSubLayers()
                
                updateTrackApperanceWithRangeValues(begin: (self.lowerValue-self.minimumValue)/(self.maximumValue-self.minimumValue),
                                                    end: (self.upperValue-self.minimumValue)/(self.maximumValue-self.minimumValue))
                
                if self.slidingKnob != nil {
                    sendActions(for: .valueChanged)
                }
                
            }
        }
    }
    @IBInspectable public var upperValue: CGFloat = 6 {
        didSet {
            if self.upperValue != oldValue {
                if self.upperValue < self.lowerValue {
                    self.lowerValue = self.upperValue
                }
                if self.upperValue > self.maximumValue {
                    self.maximumValue = self.upperValue
                }
                
                layoutSubLayers()
                
                updateTrackApperanceWithRangeValues(begin: (self.lowerValue-self.minimumValue)/(self.maximumValue-self.minimumValue),
                                                    end: (self.upperValue-self.minimumValue)/(self.maximumValue-self.minimumValue))
                
                if self.slidingKnob != nil {
                    sendActions(for: .valueChanged)
                }
            }
        }
    }
    
    @IBInspectable public var roundness: CGFloat {
        get {
            return self.trackLayer.roundness
        }
        set {
            updateSliderApperanceWithRoundness(newValue)
        }
    }
    
    @IBInspectable public var trackColor: UIColor = UIColor.gray {
        didSet {
            updateTrackApperanceWithColors(trackColor: self.trackColor, rangeColor: self.rangeColor)
        }
    }
    @IBInspectable public var rangeColor: UIColor = UIColor.blue {
        didSet {
            updateTrackApperanceWithColors(trackColor: self.trackColor, rangeColor: self.rangeColor)
        }
    }
    @IBInspectable public var knobColor: UIColor = UIColor.white {
        didSet {
            updateKnobApperanceWithColor(self.knobColor)
        }
    }
    
    //
    // MARK: - private property
    //
    private let defaultHeight: CGFloat = 30
    private let defaultTrackHeightScaleFactor: CGFloat = 1 / 3
    
    private var usableTrackLength: CGFloat {
        return self.bounds.width - self.defaultHeight
    }
    
    private class SYRangeSliderKnobLayer: CALayer {
        public var tintColor: CGColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1).cgColor
        
        public var roundness: CGFloat = 1.0
        
        private var roundRadius: CGFloat {
            return self.bounds.height * 0.5 * self.roundness
        }
        
        override func draw(in ctx: CGContext) {
            let knobPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: self.roundRadius).cgPath
            //ctx.saveGState()
            ctx.addPath(knobPath)
            ctx.clip()
            
            // fill konb
            ctx.setShadow(offset: CGSize(width: 0, height: 1), blur: 1, color: UIColor.gray.cgColor)
            ctx.setFillColor(self.tintColor)
            ctx.addPath(knobPath)
            ctx.fillPath()
            
            // strok knob
            ctx.addPath(knobPath)
            ctx.setStrokeColor(UIColor.gray.cgColor)
            ctx.strokePath()
            
            // draw inner gradient
            //ctx.restoreGState()
//            let colorComps: [CGFloat] = [0.0, 0.0, 0.0, 0.15,
//                                         0.0, 0,0, 0.0, 0.05]
//            let locations: [CGFloat] = [0.0, 1.0]
//            
//            let linerGradient = CGGradient(colorSpace: CGColorSpaceCreateDeviceRGB(),
//                                           colorComponents: colorComps,
//                                           locations: locations,
//                                           count: locations.count)!
//            let gradientRect = self.bounds.insetBy(dx: 2, dy: 2)
//            let gradientPath = UIBezierPath(roundedRect: gradientRect, cornerRadius: gradientRect.width * 0.5 * self.roundness).cgPath
//            ctx.addPath(gradientPath)
//            ctx.clip()
//            ctx.drawLinearGradient(linerGradient,
//                                   start: CGPoint(x: self.bounds.midX, y: self.bounds.minY),
//                                   end: CGPoint(x: self.bounds.midX, y: self.bounds.maxY),
//                                   options: [])
            
            
        }
    }
    
    private class SYRangeSliderTrackLayer: CALayer {
        public var trackColor: CGColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1).cgColor
        public var rangeColor: CGColor = #colorLiteral(red: 0.1756276488, green: 0.3068953753, blue: 0.9300970435, alpha: 1).cgColor
        public var roundness: CGFloat = 1.0
        public var rangeStart: CGFloat = 0.0
        public var rangeEnd: CGFloat = 1.0
        private var roundRadius: CGFloat {
            return self.bounds.height * 0.5 * self.roundness
        }
        
        override func draw(in ctx: CGContext) {
            
            let trackPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: self.roundRadius).cgPath
            ctx.setFillColor(self.trackColor)
            ctx.addPath(trackPath)
            ctx.clip()
            
            // draw background track
            ctx.addPath(trackPath)
            ctx.fillPath()
            
            // draw range track
            let startX = self.bounds.width * self.rangeStart
            let endX = self.bounds.width * self.rangeEnd
            let rangePath = UIBezierPath(rect: CGRect(x: startX,
                                                      y: 0,
                                                      width: endX - startX,
                height: self.bounds.height)).cgPath
            ctx.setFillColor(self.rangeColor)
            ctx.addPath(rangePath)
            ctx.fillPath()
            
            // draw track highlight
            let highlightPath = UIBezierPath(roundedRect: CGRect(x: self.roundRadius,
                                                                 y: self.bounds.height*0.5,
                                                                 width: self.bounds.width-self.roundRadius,
                                                                 height: self.bounds.height*0.5), cornerRadius: self.roundRadius).cgPath
            ctx.addPath(highlightPath)
            ctx.setFillColor(UIColor(white: 1.0, alpha: 0.4).cgColor)
            ctx.fillPath()
            
            // outline track
            ctx.setShadow(offset: CGSize(width: 0, height: 2), blur: 4, color: UIColor.gray.cgColor)
            ctx.setStrokeColor(UIColor.gray.cgColor)
            ctx.addPath(trackPath)
            ctx.strokePath()
            
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
        self.trackLayer = SYRangeSliderTrackLayer()
        self.layer.addSublayer(self.trackLayer)
        
        self.leftKnobLayer = SYRangeSliderKnobLayer()
        self.layer.addSublayer(self.leftKnobLayer)
        
        self.rightKnobLayer = SYRangeSliderKnobLayer()
        self.layer.addSublayer(self.rightKnobLayer)
    
        layoutSubLayers()
        updateTrackApperanceWithRangeValues(begin: (self.lowerValue-self.minimumValue)/(self.maximumValue-self.minimumValue),
                                            end: (self.upperValue-self.minimumValue)/(self.maximumValue-self.minimumValue))
        self.roundness = 0.99
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
    
    private func updateTrackApperanceWithRangeValues(begin: CGFloat, end: CGFloat) {
        self.trackLayer.rangeStart = begin
        self.trackLayer.rangeEnd = end
        self.trackLayer.setNeedsDisplay()
    }
    
    private func updateKnobApperanceWithColor(_ tint: UIColor) {
        self.leftKnobLayer.tintColor = tint.cgColor
        self.rightKnobLayer.tintColor = tint.cgColor
        self.leftKnobLayer.setNeedsDisplay()
        self.rightKnobLayer.setNeedsDisplay()
    }
    
    private func updateTrackApperanceWithColors(trackColor: UIColor, rangeColor: UIColor) {
        self.trackLayer.rangeColor = rangeColor.cgColor
        self.trackLayer.trackColor = trackColor.cgColor
        self.trackLayer.setNeedsDisplay()
    }
    
    private func updateSliderApperanceWithRoundness(_ value: CGFloat) {
        self.trackLayer.roundness = value
        self.leftKnobLayer.roundness = value
        self.rightKnobLayer.roundness = value
        self.trackLayer.setNeedsDisplay()
        self.leftKnobLayer.setNeedsDisplay()
        self.rightKnobLayer.setNeedsDisplay()
        
    }
    
}
