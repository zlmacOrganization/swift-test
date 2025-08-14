//
//  ShadowView.swift
//  SwiftTest
//
//  Created by ZhangLiang on 16/12/18.
//  Copyright © 2016年 ZhangLiang. All rights reserved.
//

import UIKit

protocol ShadowViewDelegate: AnyObject {
    func shadowButtonClick()
}

class ShadowView: UIView {
    
    weak var shadowDelegate: ShadowViewDelegate?
    
    func drawRectAtTopOfScreen() {
        let currentContext = UIGraphicsGetCurrentContext()
//        currentContext?.saveGState()
        let offect = CGSize(width: 10, height: 10)
        currentContext?.setShadow(offset: offect, blur: 20, color: UIColor.gray.cgColor)
        let path = CGMutablePath()
        let firstRect = CGRect(x: 55, y: 80, width: 150, height: 150)
        //        CGPathAddRect(path, nil, firstRect)
        path.addRect(firstRect)
        currentContext?.addPath(path)
        UIColor(red: 0.20, green: 0.60, blue: 0.80, alpha: 1.0).setFill()
        //        CGContextDrawPath(currentContext, kCGPathFill)
        //        CGContext.draw(currentContext)
        currentContext?.drawPath(using: .fill)
//        currentContext?.restoreGState()
    }
    
    func drawRectAtBottomOfScreen() {
        let currentContext = UIGraphicsGetCurrentContext()
        let secondPath = CGMutablePath()
        let secondRect = CGRect(x: 150, y: 260, width: 100, height: 100)
        secondPath.addRect(secondRect)
        currentContext?.addPath(secondPath)
        
        UIColor.purple.setFill()
        currentContext?.drawPath(using: .fill)
    }

    override func draw(_ rect: CGRect) {
//        drawRectAtTopOfScreen()
//        drawRectAtBottomOfScreen()
        
        let view = UIView(frame: CGRect(x: 60, y: 80, width: 150, height: 150))
        view.backgroundColor = UIColor.lightGray
        self.addSubview(view)
        
        let shadowButton = UIButton(frame: CGRect(x: 25, y: 50, width: 100, height: 50))
        shadowButton .setTitle("Click", for: UIControl.State.normal)
        shadowButton.addTarget(self, action: #selector(self.buttonClick), for: UIControl.Event.touchUpInside)
        view.addSubview(shadowButton)
    }
    
    @objc func buttonClick() {
        if let myDelegate = shadowDelegate {
            myDelegate.shadowButtonClick()
        }
    }

}
