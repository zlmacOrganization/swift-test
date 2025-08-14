//
//  DragCollectionViewCell.swift
//  SwiftTest
//
//  Created by ZhangLiang on 2017/12/17.
//  Copyright © 2017年 ZhangLiang. All rights reserved.
//

import UIKit

class DragCollectionViewCell: UICollectionViewCell {
    
    var targetImageView: UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.configureViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureViews() {
        self.targetImageView = UIImageView(frame: self.contentView.bounds)
        self.contentView.addSubview(self.targetImageView!)
    }
}
