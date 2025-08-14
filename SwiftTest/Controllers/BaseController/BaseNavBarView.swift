//
//  BaseNavBarView.swift
//  SwiftTest
//
//  Created by zhangliang on 2020/9/18.
//  Copyright © 2020 zhangliang. All rights reserved.
//

import UIKit

class BaseNavBarView: UIView {
    
    private var backButton: UIButton!
    var titleLabel: UILabel!

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureViews() {
        backButton = CommonFunction.createButton(frame: CGRect(x: 0, y: statusBarHeight(), width: 65, height: kNaviBarHeight), title: nil, textColor: nil, font: nil, imageName: "left_back", isBackgroundImage: false, target: self, action: #selector(backButtonClick))
//        backButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: -25, bottom: 0, right: 15)
        
        addSubview(backButton)
        
        
        titleLabel = CommonFunction.createLabel(font: UIFont.systemFont(ofSize: 16), text: "", textColor: UIColor.darkGray, textAlignment: .center)
        addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(statusBarHeight())
            make.height.equalTo(kNaviBarHeight)
            make.centerX.equalToSuperview()
        }
    }
    
    @objc private func backButtonClick() {
        let controller = getCurrentViewController()
        controller?.navigationController?.popViewController(animated: true)
    }
}
