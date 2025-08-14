//
//  ZFMoreMenuCell.swift
//  ZFBaseModule_Example
//
//  Created by guzhiyang on 2018/7/20.
//  Copyright © 2018年 CocoaPods. All rights reserved.
//


import UIKit

class ZFMoreMenuCell: UITableViewCell {
    
    private var iconImageView: UIImageView!
    private var titleLabel: UILabel!
    private var lineView: UIView!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configureViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureViews() {
        iconImageView = UIImageView()
        contentView.addSubview(iconImageView)
        
        titleLabel = CommonFunction.createLabel(font: UIFont.systemFont(ofSize: 14), text: "", textColor: UIColor.darkGray, textAlignment: .left)
        contentView.addSubview(titleLabel)
        
        lineView = UIView()
        contentView.addSubview(lineView)
        
        makeViewConstraints()
    }
    
    private func makeViewConstraints() {
        iconImageView.snp.makeConstraints { (make) in
            make.left.equalTo(15)
            make.centerY.equalTo(contentView)
            make.size.equalTo(CGSize(width: 15, height: 15))
        }
        
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(iconImageView.snp.right).offset(8)
            make.right.equalTo(-8)
            make.centerY.equalTo(contentView)
        }
        
        lineView.snp.makeConstraints { (make) in
            make.height.equalTo(0.5)
            make.left.right.bottom.equalTo(0)
        }
    }

    // MARK: - Set Content
    func setMenuContent(title:String,
                        iconName:String) {
        titleLabel.text = title
        iconImageView.image = UIImage(named: iconName)
    }
    
    /// 隐藏分割线
    func isHideSeperateLineView(hide:Bool) {
        lineView.isHidden = hide
    }

    // MARK: - Systtem Methods
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
