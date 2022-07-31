//
//  RangeSliderThumbLayer.swift
//  RangeSliderPOC
//
//  Created by Vikas on 26/07/22.
//

import Foundation
import UIKit

// MARK: Designable VKRangeSliderThumbLayer
@IBDesignable class VKRangeSliderThumbLayer: CALayer {
    
    // MARK: Variable declaration
    var highlighted = false
    
    // MARK: Private variable
    private var curvaceousness: CGFloat = 1.0

    // MARK: Lifecycle
    override func draw(in ctx: CGContext) {
        /// Add range button
        let thumbFrame = bounds.insetBy(dx: 2.0, dy: 2.0)
        let myLayer = CALayer()
        let myImage = UIImage(named: "range_button")?.cgImage
        myLayer.frame = thumbFrame
        let cornerRadius = thumbFrame.height * curvaceousness / 2.0
        myLayer.cornerRadius = cornerRadius
        myLayer.contents = myImage
        addSublayer(myLayer)
    }
}

// MARK: Designable VKRangeSliderVector
@IBDesignable class VKRangeSliderVector: CALayer {
    
    // MARK: Private variable
    private var curvaceousness: CGFloat = 1.0
    private var vectorLabel: UILabel = UILabel()
    
    // MARK: Lifecycle
    override func draw(in ctx: CGContext) {
        /// Add baloon text
        let vectorImageFrame = bounds.insetBy(dx: 2.0, dy: 0.0)
        let imageLayer = CALayer()
        let myImage = UIImage(named: "Vector")?.cgImage
        imageLayer.frame = vectorImageFrame
        let cornerRadius = vectorImageFrame.height * curvaceousness / 2.0
        imageLayer.cornerRadius = cornerRadius
        imageLayer.contents = myImage
        addSublayer(imageLayer)
        
        vectorLabel.frame = CGRect(x: bounds.minX, y: bounds.minY, width: bounds.width, height: bounds.height - 5)
        vectorLabel.textColor = .black
        vectorLabel.font = UIFont.systemFont(ofSize: 11.0)
        vectorLabel.textAlignment = .center
        let textLayer = vectorLabel.layer
        addSublayer(textLayer)
    }
    
    // MARK: update text on baloon
    func update(text: String) {
        DispatchQueue.main.async {
            self.vectorLabel.text = text
        }
    }
    
    // MARK: Set vectors visibility
    func setVisible(visible: Bool) {
        if isHidden != visible { return }
        let timeInterval: CFTimeInterval = 0.3
        let opacityAnimation = CABasicAnimation(keyPath: "opacity")
        opacityAnimation.fromValue = self.isHidden ? 0.0 : 1.0
        opacityAnimation.toValue = self.isHidden ? 1.0 : 0.0
        opacityAnimation.isRemovedOnCompletion = true
        opacityAnimation.duration = timeInterval
        opacityAnimation.repeatCount = 0
        self.add(opacityAnimation, forKey: nil)
        self.isHidden = !visible
    }
}
