//
//  ShakeCollectionCell.swift
//  SwiftTest
//
//  Created by bfgjs on 2019/8/23.
//  Copyright © 2019 ZhangLiang. All rights reserved.
//

import UIKit

class ShakeCollectionCell: UICollectionViewCell {
//    var imgView: UIImageView!
//    var removeBtn: UIButton!
//    var isAnimate: Bool = true
    
    func startAnimate() {
        let shakeAnimation = CABasicAnimation(keyPath: "transform.rotation")
        shakeAnimation.duration = 0.05
        shakeAnimation.repeatCount = 4
        shakeAnimation.autoreverses = true
        shakeAnimation.duration = 0.2
        shakeAnimation.repeatCount = 99999
        
        let startAngle: Float = (-2) * 3.14159/180
        let stopAngle = -startAngle
        
        shakeAnimation.fromValue = NSNumber(value: startAngle as Float)
        shakeAnimation.toValue = NSNumber(value: 3 * stopAngle as Float)
        shakeAnimation.timeOffset = 290 * drand48()
        
        let layer: CALayer = self.layer
        layer.add(shakeAnimation, forKey:"animate")
//        removeBtn.isHidden = false
//        isAnimate = true
    }
    
    func stopAnimate() {
        let layer: CALayer = self.layer
        layer.removeAnimation(forKey: "animate")
//        self.removeBtn.isHidden = true
//        isAnimate = false
    }
}
