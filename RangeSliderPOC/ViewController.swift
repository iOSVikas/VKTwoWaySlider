//
//  ViewController.swift
//  RangeSliderPOC
//
//  Created by Vikas on 26/07/22.
//

import UIKit

/// ViewController to demo range slider
class ViewController: UIViewController {
    
    // Adding Range slider using Code
    let rangeSlider = VKRangeSlider(frame: .zero)
    
    // Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        addRangeSLider()
    }
    
    override func viewDidLayoutSubviews() {
       let margin: CGFloat = 20.0
       let width = view.bounds.width - 2.0 * margin
       rangeSlider.frame = CGRect(x: margin,
                                  y: margin + 170,
                                  width: width, height: 31.0)
    }
    
    // Private function to add range slider
    private func addRangeSLider() {
        rangeSlider.backgroundColor = UIColor.red
        rangeSlider.maxValue = 100
        rangeSlider.slideSpam = 10
        rangeSlider.defaultUpperValue = 80.0
        rangeSlider.defaultLowerValue = 10.0
        self.view.addSubview(rangeSlider)
        rangeSlider.addTarget(self, action: #selector(didChangeValueForSlider(_:)), for: .valueChanged)
    }
    
    // Notification for Range slider value changed
    @objc func didChangeValueForSlider(_ rangeSlider: VKRangeSlider) {
        print("Range slider value changed: (\(rangeSlider.lowerValue) \(rangeSlider.upperValue))")
    }
}
