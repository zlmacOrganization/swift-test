//
//  CustomView.swift
//  SwiftTest
//
//  Created by ZhangLiang on 2018/9/2.
//  Copyright © 2018年 ZhangLiang. All rights reserved.
//

import UIKit

class CustomView: UIView {

    override func draw(_ rect: CGRect) {
        let roundPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: 4.0)
        UIColor.yellow.set()
        roundPath.fill()
        
        let image = UIImage(named: "deleteRow")
        image?.draw(at: CGPoint(x: 2.0, y: 2.0))
        
//        let dict = [NSAttributedStringKey.font: 12]
        let text = NSAttributedString(string: "Live", attributes: nil)
        text.draw(at: CGPoint(x: 20, y: 2.0))
    }

}
