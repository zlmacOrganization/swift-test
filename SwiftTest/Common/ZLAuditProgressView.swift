//
//  ZLAuditProgressView.swift
//  SwiftTest
//
//  Created by zhangliang on 2020/10/9.
//  Copyright © 2020 zhangliang. All rights reserved.
//

import UIKit

class ZLAuditProgressView: UIView {
    
    static let normalColor = colorWithRGB(r: 204, g: 204, b: 204)
    static let selectedColor = colorWithRGB(r: 46, g: 192, b: 148)
    
    private let titles: [String]
    private let currentProgress: Int

    init(frame: CGRect, titles: [String], progress: Int) {
        self.titles = titles
        currentProgress = progress
        super.init(frame: frame)
        
        configureViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureViews() {
        let viewX: CGFloat = 10
        
        let firstCircle = CircleView(frame: CGRect(x: viewX, y: 0, width: 14, height: 14))
        firstCircle.isSelected = true
        addSubview(firstCircle)
        
        let lineWidth: CGFloat = (zl_width - viewX*2 - CGFloat(titles.count)*14)/4
        
        for (index, title) in titles.enumerated() {
            if index == 0 {
                let label = CommonFunction.createLabel(font: UIFont.systemFont(ofSize: 14), text: title, textColor: ZLAuditProgressView.selectedColor, textAlignment: .center)
                addSubview(label)
                
                label.snp.makeConstraints { (make) in
                    make.centerX.equalTo(firstCircle)
                    make.top.equalTo(firstCircle.snp.bottom).offset(5)
                }
            }else {
                let lineView = UIView(frame: CGRect(x: firstCircle.zl_right + (lineWidth + 14)*CGFloat(index - 1), y: firstCircle.zl_centerY - 1, width: lineWidth, height: 2))
                addSubview(lineView)
                
                let otherCircle = CircleView(frame: CGRect(x: lineView.zl_right, y: 0, width: 14, height: 14))
                addSubview(otherCircle)
                
                let label = CommonFunction.createLabel(font: UIFont.systemFont(ofSize: 14), text: title, textColor: ZLAuditProgressView.normalColor, textAlignment: .center)
                addSubview(label)
                
                if currentProgress >= index {
                    otherCircle.isSelected = true
                    lineView.backgroundColor = ZLAuditProgressView.selectedColor
                    label.textColor = ZLAuditProgressView.selectedColor
                }else {
                    otherCircle.isSelected = false
                    lineView.backgroundColor = ZLAuditProgressView.normalColor
                    label.textColor = ZLAuditProgressView.normalColor
                }
                
                label.snp.makeConstraints { (make) in
                    make.centerX.equalTo(otherCircle)
                    make.top.equalTo(otherCircle.snp.bottom).offset(5)
                }
            }
        }
    }
}

class CircleView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layer.cornerRadius = frame.size.width/2
        clipsToBounds = true
    }
    
    var isSelected: Bool = false {
        didSet {
            if isSelected {
                backgroundColor = ZLAuditProgressView.selectedColor
            }else {
                backgroundColor = ZLAuditProgressView.normalColor
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
