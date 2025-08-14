//
//  RectangleView.swift
//  SwiftTest
//
//  Created by Liang Zhang on 2024/6/25.
//  Copyright © 2024 zhangliang. All rights reserved.
//

import UIKit

class RectangleView: UIView {
    var bgColor: UIColor = UIColor.lightGray

    override func draw(_ rect: CGRect) {
        bgColor.set()
        
        let path2 = UIBezierPath(rect: CGRect(x: 0, y: 0, width: self.zl_width, height: self.zl_height))
        path2.lineCapStyle = .round
        path2.lineJoinStyle = .round
        path2.fill()
    }
}
