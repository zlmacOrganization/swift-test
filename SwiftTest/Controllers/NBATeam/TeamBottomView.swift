//
//  ShopcartBottomView.swift
//  SupvpSwift
//
//  Created by bfgjs on 2019/6/3.
//  Copyright © 2019 bfgjs. All rights reserved.
//

import UIKit

class ShopcartBottomView: UIView {
    
    var selectClosure: ((Bool) -> Void)?
    
    private lazy var allSelectBtn: UIButton = {
        let button = CommonFunction.createButton(frame: CGRect.zero, title: nil, textColor: nil, font: nil, imageName: "wxzshangpin_", isBackgroundImage: false, target: self, action: #selector(allButtonClick))
        button.setImage(UIImage(named: "shangpin_"), for: .selected)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.setTitleColor(UIColor.purple, for: .normal)
        button.setTitle("全选", for: .normal)
        return button
    }()

    init() {
        super.init(frame: CGRect.zero)
        
        configureViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureViews() {
        self.addSubview(allSelectBtn)
        
        allSelectBtn.snp.makeConstraints { (make) in
            make.top.bottom.equalTo(0)
            make.left.equalTo(2)
            make.width.equalTo(50)
        }
        
        allSelectBtn.imagePosition(at: .top, space: 18)
    }
    
    @objc private func allButtonClick() {
        allSelectBtn.isSelected = !allSelectBtn.isSelected
        
        if let closure = selectClosure {
            closure(allSelectBtn.isSelected)
        }
    }
}

enum ZGJButtonImageEdgeInsetsStyle {
    case top, left, right, bottom
}
