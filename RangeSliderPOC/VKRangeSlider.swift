//
//  RangeSlider.swift
//  RangeSliderPOC
//
//  Created by Vikas on 26/07/22.
//


import Foundation
import UIKit
import QuartzCore

/// Designable VKRangeSlider
@IBDesignable class VKRangeSlider: UIControl {
    
    // MARK: Inspectable variables to support control on xibs
    /// Marimum alue for the range selector
    @IBInspectable var maxValue: CGFloat = 40.0 { didSet { updateLayerFrames() } }
    
    /// default low selected range value
    @IBInspectable var defaultLowerValue: CGFloat = 0.0 {
        didSet {
            if defaultLowerValue >= 0 {
                lowerValue = defaultLowerValue
                cntLowerValue = defaultLowerValue
                updateLayerFrames()
            } else {
                assertionFailure("Error setting range value: Default lower value should be zero or above")
            }
        }
    }
    
    /// default higher selected range value
    @IBInspectable var defaultUpperValue: CGFloat = 0.0 {
        didSet {
            if defaultUpperValue <= maxValue {
                upperValue = defaultUpperValue
                cntUpperValue = defaultUpperValue
                updateLayerFrames()
            } else {
                assertionFailure("Error setting range value: Default upper value should be greater than or equals to maxValue")
            }
        }
    }
    
    /// A slide span to jump the sliding with values
    @IBInspectable var slideSpam: CGFloat = 5.0
    
    /// Slider Track bar color
    @IBInspectable
    var trackTintColor: UIColor = UIColor.gray

    /// Slider Track selected range bar color
    @IBInspectable
    var trackHighlightTintColor: UIColor = UIColor.blue

    // MARK: Private variables
    private (set) var lowerValue: CGFloat = 5.0
    private (set) var upperValue: CGFloat = 35.0
    private var cntLowerValue: CGFloat = 0.0
    private var cntUpperValue: CGFloat = 0.10
    private var currentActiveThumb: VKRangeSliderThumbLayer
    private var minValue: CGFloat = 0.0
    private var isTrackingVector: Bool = false
    private var previousLocation = CGPoint()
    private var previousLower: CGFloat = 0.0
    private var previousUpper: CGFloat = 0.0

    // MARK: Private layers
    private let trackLayer = VKRangeSliderTrackLayer()
    private let lowerThumbLayer = VKRangeSliderThumbLayer()
    private let lowerVectorLayer = VKRangeSliderVector()
    private let upperThumbLayer = VKRangeSliderThumbLayer()
    private let upperVectorLayer = VKRangeSliderVector()
    
    /// height/width for range selector buttons
    var thumbWidth: CGFloat {
        return CGFloat(bounds.height)
    }
    
    // MARK: Lyfecysle
    required init?(coder: NSCoder) {
        currentActiveThumb = lowerThumbLayer
        super.init(coder: coder)
        setupUI()
    }
    
    override init(frame: CGRect) {
        currentActiveThumb = lowerThumbLayer
        super.init(frame: frame)
        setupUI()
    }
    
    override var frame: CGRect {
        didSet {
            updateLayerFrames()
        }
    }
    
    // MARK: track the movement of range buttons
    override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        isTrackingVector = true
        previousLocation = touch.location(in: self)
        
        // Hit test the thumb layers
        if lowerThumbLayer.frame.contains(previousLocation) &&
            upperThumbLayer.frame.contains(previousLocation) {
            lowerThumbLayer.highlighted = false
            upperThumbLayer.highlighted = false
            currentActiveThumb.highlighted = true
        } else if lowerThumbLayer.frame.contains(previousLocation) {
            lowerThumbLayer.highlighted = true
            upperThumbLayer.highlighted = false
            currentActiveThumb = lowerThumbLayer
        } else if upperThumbLayer.frame.contains(previousLocation) {
            upperThumbLayer.highlighted = true
            lowerThumbLayer.highlighted = false
            currentActiveThumb = upperThumbLayer
        }
        currentActiveThumb.bringToFront()
        return lowerThumbLayer.highlighted || upperThumbLayer.highlighted
    }
    
    override func continueTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        let location = touch.location(in: self)
        isTrackingVector = true
        
        // 1. Determine by how much the user has dragged
        let deltaLocation = Double(location.x - previousLocation.x)
        let deltaValue = (maxValue - minValue) * deltaLocation / Double(bounds.width - thumbWidth)
        previousLocation = location
        // 2. Update the values
        if lowerThumbLayer.highlighted {
            cntLowerValue += deltaValue
            cntLowerValue = boundValue(value: cntLowerValue, toLowerValue: minValue, upperValue: cntUpperValue - slideSpam)
            lowerValue = Double(Int(cntLowerValue/slideSpam)) * slideSpam
        } else if upperThumbLayer.highlighted {
            cntUpperValue += deltaValue
            cntUpperValue = boundValue(value: cntUpperValue, toLowerValue: cntLowerValue + slideSpam, upperValue: maxValue)
            upperValue = Double(Int(cntUpperValue/slideSpam)) * slideSpam
        }
        
        // 3. Update the UI
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        updateLayerFrames()
        CATransaction.commit()
        sendActions(for: .valueChanged)
        return true
    }
    
    override func endTracking(_ touch: UITouch?, with event: UIEvent?) {
        isTrackingVector = false
        updateLayerFrames()
        if lowerThumbLayer.frame.contains(previousLocation) &&
            upperThumbLayer.frame.contains(previousLocation) {
            if lowerThumbLayer.highlighted {
                currentActiveThumb = lowerThumbLayer
                upperThumbLayer.highlighted = false
            } else {
                currentActiveThumb = upperThumbLayer
                lowerThumbLayer.highlighted = false
            }
        } else {
            lowerThumbLayer.highlighted = false
            upperThumbLayer.highlighted = false
        }
    }
    
    func positionForValue(value: Double) -> Double {
        return Double(bounds.width - thumbWidth) * (value - minValue) /
        (maxValue - minValue) + Double(thumbWidth / 2.0)
    }
    
    /// Update frames on drag of slider
    func updateLayerFrames() {
        trackLayer.frame = bounds.insetBy(dx: 5.0, dy: bounds.height / 3)
        trackLayer.setNeedsDisplay()
        
        let lowerThumbCenter = CGFloat(positionForValue(value: lowerValue))
        
        lowerThumbLayer.frame = CGRect(x: lowerThumbCenter - thumbWidth / 2.0, y: 0.0,
                                       width: thumbWidth, height: thumbWidth)
        lowerThumbLayer.setNeedsDisplay()
        
        let upperThumbCenter = CGFloat(positionForValue(value: upperValue))
        upperThumbLayer.frame = CGRect(x: upperThumbCenter - thumbWidth / 2.0, y: 0.0,
                                       width: thumbWidth, height: thumbWidth)
        upperThumbLayer.setNeedsDisplay()
        
        let lowerVectorCenter = CGFloat(positionForValue(value: lowerValue))
        
        lowerVectorLayer.frame = CGRect(x: lowerVectorCenter - thumbWidth / 2.0, y: -thumbWidth,
                                        width: thumbWidth, height: thumbWidth)
        lowerVectorLayer.setNeedsDisplay()
        if previousLower != lowerValue {
            previousLower = lowerValue
            lowerVectorLayer.update(text: "\(Int(lowerValue))")
        }
        lowerVectorLayer.setVisible(visible: isTrackingVector)
        
        let upperVectorCenter = CGFloat(positionForValue(value: upperValue))
        upperVectorLayer.frame = CGRect(x: upperVectorCenter - thumbWidth / 2.0, y: -thumbWidth,
                                       width: thumbWidth, height: thumbWidth)
        upperVectorLayer.setNeedsDisplay()
        if previousUpper != upperValue {
            previousUpper = upperValue
            upperVectorLayer.update(text: "\(Int(upperValue))")
        }
        upperVectorLayer.setVisible(visible: isTrackingVector)
    }
}

// MARK: Private extensions for private functions
private extension VKRangeSlider {
    /// Setup UI
    private func setupUI() {
        trackLayer.rangeSlider = self
        trackLayer.contentsScale = UIScreen.main.scale
        layer.addSublayer(trackLayer)
        
        lowerThumbLayer.contentsScale = UIScreen.main.scale
        layer.addSublayer(lowerThumbLayer)
        
        upperThumbLayer.contentsScale = UIScreen.main.scale
        layer.addSublayer(upperThumbLayer)
        
        lowerVectorLayer.contentsScale = UIScreen.main.scale
        layer.addSublayer(lowerVectorLayer)
        
        upperVectorLayer.contentsScale = UIScreen.main.scale
        layer.addSublayer(upperVectorLayer)
        
        updateLayerFrames()
    }
    
    /// to return the minimum value for slider button
    private func boundValue(value: Double, toLowerValue lowerValue: Double, upperValue: Double) -> Double {
        return min(max(value, lowerValue), upperValue)
    }
}
