//
//  ReportAddView.swift
//  SwiftTest
//
//  Created by zhangliang on 2021/3/11.
//  Copyright © 2021 zhangliang. All rights reserved.
//

import UIKit

class ReportAddView: UITableViewHeaderFooterView {
    var addBlock: (() -> Void)?

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        contentView.backgroundColor = UIColor.white
        configureViews()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let addButton = contentView.viewWithTag(123) as? UIButton
        addButton?.imagePosition(at: .left, space: 10)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureViews() {
        let addButton = CommonFunction.createButton(frame: CGRect.zero, title: "添加", textColor: UIColor.lightGray, font: UIFont.systemFont(ofSize: 15), imageName: "customerReport_add", target: self, action: #selector(addButtonClick))
        addButton.tag = 123
        contentView.addSubview(addButton)
        
        addButton.snp.makeConstraints { (make) in
            make.left.equalTo(18)
            make.centerY.equalToSuperview()
            make.size.equalTo(CGSize(width: 70, height: 40))
        }
    }

    @objc private func addButtonClick() {
        addBlock?()
    }
}
