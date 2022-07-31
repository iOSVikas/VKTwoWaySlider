//
//  VKRangeSliderTrackLayer.swift
//  RangeSliderPOC
//
//  Created by Vikas on 26/07/22.
//

import Foundation
import UIKit
import QuartzCore

/// Designable VKRangeSliderTrackLayer used in Range slider
@IBDesignable class VKRangeSliderTrackLayer: CALayer {
    
    // Referance to range slider
    weak var rangeSlider: VKRangeSlider?
    
    // MARK: Private variables
    private var curvaceousness: CGFloat = 1.0
    
    // MARK: Lifecycle
    override func draw(in ctx: CGContext) {
        if let slider = rangeSlider {
            /// Clip
            let cornerRadius = bounds.height * curvaceousness / 2.0
            let path = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius)
            ctx.addPath(path.cgPath)
            
            /// Fill the track
            ctx.setFillColor(slider.trackTintColor.cgColor)
            ctx.addPath(path.cgPath)
            ctx.fillPath()
            
            /// Fill the highlighted range
            ctx.setFillColor(slider.trackHighlightTintColor.cgColor)
            let lowerValuePosition =  CGFloat(slider.positionForValue(value: slider.lowerValue))
            let upperValuePosition = CGFloat(slider.positionForValue(value: slider.upperValue))
            let rect = CGRect(x: lowerValuePosition, y: 0.0, width: upperValuePosition - lowerValuePosition, height: bounds.height)
            ctx.fill(rect)
        }
    }
}

