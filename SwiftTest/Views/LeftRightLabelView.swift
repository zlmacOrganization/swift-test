//
//  LeftRightLabelView.swift
//  SwiftTest
//
//  Created by ZhangLiang on 2020/8/12.
//  Copyright © 2020 ZhangLiang. All rights reserved.
//

import UIKit

class LeftRightLabelView: UIView {
    var leftLabel: UILabel!
    var rightLabel: UILabel!

    init() {
        super.init(frame: CGRect.zero)
        
        configureViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureViews() {
        leftLabel = CommonFunction.createLabel(font: UIFont.systemFont(ofSize: 15), text: "", textColor: UIColor.darkGray, textAlignment: .center)
        addSubview(leftLabel)
        
        rightLabel = CommonFunction.createLabel(font: UIFont.systemFont(ofSize: 13), text: "", textColor: UIColor.darkGray, textAlignment: .center)
        addSubview(rightLabel)
        
        
        leftLabel.snp.makeConstraints { (make) in
            make.left.equalTo(0)
            make.top.equalTo(0)
            make.height.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.5)
        }
        
        rightLabel.snp.makeConstraints { (make) in
            make.left.equalTo(leftLabel.snp.right)
            make.height.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.5)
        }
    }
}
