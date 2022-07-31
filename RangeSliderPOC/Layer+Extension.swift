//
//  Layer+Extension.swift
//  RangeSliderPOC
//
//  Created by Vikas on 26/07/22.
//

import UIKit

// MARK: Extension
extension CALayer {
    
    // Brings the sublayer to front
    func bringToFront() {
        guard let sLayer = superlayer else {
            return
        }
        removeFromSuperlayer()
        sLayer.insertSublayer(self, at: UInt32(sLayer.sublayers?.count ?? 0))
    }
    
    // Send the sublayer to back
    func sendToBack() {
        guard let sLayer = superlayer else {
            return
        }
        removeFromSuperlayer()
        sLayer.insertSublayer(self, at: 0)
    }
}
