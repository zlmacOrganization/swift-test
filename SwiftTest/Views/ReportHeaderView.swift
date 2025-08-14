//
//  ReportHeaderView.swift
//  SwiftTest
//
//  Created by zhangliang on 2021/3/11.
//  Copyright © 2021 zhangliang. All rights reserved.
//

import UIKit

class ReportHeaderView: UITableViewHeaderFooterView {
    var titleLabel: UILabel?

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        contentView.backgroundColor = UIColor.white
        
        if #unavailable(iOS 14.0) {//14.0以下
            configureViews()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureViews() {
        titleLabel = CommonFunction.createLabel(font: UIFont.systemFont(ofSize: 14), text: "", textColor: UIColor.darkGray, textAlignment: .left)
        contentView.addSubview(titleLabel!)
        
        let lineView = UIView()
        lineView.backgroundColor = colorWithRGB(r: 240, g: 240, b: 240)
        contentView.addSubview(lineView)
        
        titleLabel?.snp.makeConstraints { (make) in
            make.left.equalTo(20)
            make.top.equalTo(10)
        }
        
        lineView.snp.makeConstraints { (make) in
            make.left.equalTo(20)
            make.right.equalTo(0)
            make.height.equalTo(1)
            make.bottom.equalTo(0)
        }
    }
}

@available(iOS 14.0, *)
struct ReportContentConfiguration: UIContentConfiguration {
    var title: String
    
    func makeContentView() -> UIView & UIContentView {
        return ReportContentView(config: self)
    }
    
    func updated(for state: UIConfigurationState) -> ReportContentConfiguration {
        return self
    }
}

@available(iOS 14.0, *)
class ReportContentView: UIView, UIContentView {
    var titleLabel: UILabel!
    
    var configuration: UIContentConfiguration {
        didSet {
            configData()
        }
    }
    
    init(config: UIContentConfiguration) {
        self.configuration = config
        super.init(frame: .zero)
        
        titleLabel = CommonFunction.createLabel(font: UIFont.systemFont(ofSize: 14), text: "", textColor: UIColor.darkGray, textAlignment: .left)
        addSubview(titleLabel)
        
        let lineView = UIView()
        lineView.backgroundColor = colorWithRGB(r: 240, g: 240, b: 240)
        addSubview(lineView)
        
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(20)
            make.top.equalTo(10)
        }
        
        lineView.snp.makeConstraints { (make) in
            make.left.equalTo(20)
            make.right.equalTo(0)
            make.height.equalTo(1)
            make.top.equalTo(titleLabel.snp.bottom).offset(12)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configData() {
        if let config = configuration as? ReportContentConfiguration {
            titleLabel.text = config.title
        }
    }
}
