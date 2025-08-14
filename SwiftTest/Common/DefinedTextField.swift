//
//  DefinedTextField.swift
//  SwiftTest
//
//  Created by lezhi on 2018/5/24.
//  Copyright © 2018年 ZhangLiang. All rights reserved.
//

import UIKit

class DefinedTextField: UITextField {

    private var isEnablePadding: Bool = false
    private var topPadding: CGFloat = 0.0
    private var leftPadding: CGFloat = 0.0
    private var bottomPadding: CGFloat = 0.0
    private var rightPadding: CGFloat = 0.0
    
    private var leftViewPadding: CGFloat = 0.0
    private var rightViewPadding: CGFloat = 0.0

    func setPadding(enable: Bool, top: CGFloat, left: CGFloat, bottom: CGFloat, right: CGFloat, leftViewPadding: CGFloat = 0, rightViewPadding: CGFloat = 0) {
        self.isEnablePadding = enable
        self.topPadding = top
        self.leftPadding = left
        self.bottomPadding = bottom
        self.rightPadding = right
        
        self.leftViewPadding = leftViewPadding
        self.rightViewPadding = rightViewPadding
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        if isEnablePadding {
            return CGRect(x: bounds.origin.x + leftPadding, y: bounds.origin.y + topPadding, width: bounds.size.width - rightPadding, height: bounds.size.height - bottomPadding)
        }else{
            return CGRect(x: bounds.origin.x, y: bounds.origin.y, width: bounds.size.width, height: bounds.size.height)
        }
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return self.textRect(forBounds: bounds)
    }
    
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        let inset = CGRect(x: bounds.origin.x + leftPadding, y: bounds.origin.y + topPadding, width: bounds.size.width - 5, height: bounds.size.height - bottomPadding)
        return inset
    }
    
//    override func leftViewRect(forBounds bounds: CGRect) -> CGRect {
//        var rect = super.leftViewRect(forBounds: bounds)
//        rect.origin.x += leftViewPadding
//
//        return rect
//    }
//
//    override func rightViewRect(forBounds bounds: CGRect) -> CGRect {
//        var rect = super.rightViewRect(forBounds: bounds)
//        rect.origin.x -= rightViewPadding
//
//        return rect
//    }
}

class MyTextAttachment: NSTextAttachment {
    override func attachmentBounds(for textContainer: NSTextContainer?, proposedLineFragment lineFrag: CGRect, glyphPosition position: CGPoint, characterIndex charIndex: Int) -> CGRect {
        return CGRect.zero
    }
}
