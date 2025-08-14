//
//  AlignmentCollectionCell.swift
//  SwiftTest
//
//  Created by ZhangLiang on 2020/7/23.
//  Copyright © 2020 ZhangLiang. All rights reserved.
//

import UIKit

class AlignmentCollectionCell: UICollectionViewCell {
    
    var label: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureViews() {
        label = CommonFunction.createLabel(font: UIFont.systemFont(ofSize: 14), text: "", textColor: UIColor.darkGray, textAlignment: .center)
        contentView.addSubview(label)
        
        label.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        contentView.layer.borderWidth = 0.6
        contentView.layer.borderColor = colorWithRGB(r: 150, g: 150, b: 150).cgColor
    }
}
