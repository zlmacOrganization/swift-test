//
//  SearchBarView.swift
//  SwiftTest
//
//  Created by zhangliang on 2021/3/1.
//  Copyright © 2021 zhangliang. All rights reserved.
//

import UIKit

class SearchBarView: UIView {
    private var textField: UITextField!
    private var placeholder: String
    
    var searchBlock: ((String) -> Void)?

    init(placeholder: String = "请输入搜索文字") {
        self.placeholder = placeholder
        super.init(frame: CGRect.zero)
        
        configureViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureViews() {
        let imageView = UIImageView(image: UIImage(named: "search_bg"))
        addSubview(imageView)
        
        let iconImage = UIImageView(image: UIImage(named: "search_icon"))
        addSubview(iconImage)
        
        textField = UITextField()
        textField.placeholder = placeholder
        textField.returnKeyType = .search
        textField.delegate = self
        addSubview(textField)
        
        imageView.snp.makeConstraints { (make) in
            make.left.equalTo(10)
            make.right.equalTo(-10)
            make.height.equalTo(34)
            make.center.equalToSuperview()
        }
        
        iconImage.snp.makeConstraints { (make) in
            make.left.equalTo(20)
            make.width.height.equalTo(16)
            make.centerY.equalToSuperview()
        }
        
        textField.snp.makeConstraints { (make) in
            make.right.equalTo(-20)
            make.centerY.equalToSuperview()
            make.left.equalTo(iconImage.snp.right).offset(6)
        }
    }
}

extension SearchBarView: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchBlock?(textField.text ?? "")
        return true
    }
}
