//
//  ZLLayoutConstraint2.swift
//  SwiftTest
//
//  Created by ZhangLiang on 2020/6/28.
//  Copyright © 2020 ZhangLiang. All rights reserved.
//

import Foundation
import SnapKit
import UIKit

extension NSLayoutConstraint {
    private struct Keys {
        static var w_constraintKey = "width_constraint_key"
        static var h_constraintKey = "height_constraint_key"
    }

    @IBInspectable var widthAdaptive: Bool {

        get {
            return (objc_getAssociatedObject(self, &(Keys.w_constraintKey)) != nil)
        }
        
        set {
            objc_setAssociatedObject(self, &(Keys.w_constraintKey), newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)

            if newValue == true {
                constant *= SCALE_RATIO
            }
        }
    }
    
    @IBInspectable var heightAdaptive: Bool {

        get {
            return (objc_getAssociatedObject(self, &(Keys.h_constraintKey)) != nil)
        }
        
        set {
            objc_setAssociatedObject(self, &(Keys.h_constraintKey), newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)

            if newValue {
                constant *= SCALE_RATIO
            }
        }
    }
    
    @IBInspectable
    var adapterScreen: Bool {
        set {
            if newValue {
                self.constant = self.constant * (kMainScreenWidth/375 < 1.2 ? 1.2 : kMainScreenWidth/375)
            }
        }
        get {
            return true
        }
    }
}

extension UIView {
    private struct Keys {
        static var widthKey = "width_key"
    }
    
//    @IBInspectable var zlWidth: CGFloat {
//        get {
//            return objc_getAssociatedObject(self, &(Keys.widthKey)) as! CGFloat
//        }
//
//        set {
//            var tempFrame = frame
//            tempFrame.size.width = newValue*SCALE_RATIO
//            frame = tempFrame
//
//            objc_setAssociatedObject(self, &(Keys.widthKey), newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
//        }
//    }
}

extension UILabel {
    
    private struct Keys {
        static var sizeKey = "fontSize_key"
    }
    
    @IBInspectable var zlFontSize: CGFloat {
        get {
            return objc_getAssociatedObject(self, &(Keys.sizeKey)) as! CGFloat
        }
        
        set {
            font = UIFont.systemFont(ofSize: newValue*SCALE_RATIO)
            
            objc_setAssociatedObject(self, &(Keys.sizeKey), newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}
