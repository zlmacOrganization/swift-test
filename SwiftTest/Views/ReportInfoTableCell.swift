//
//  ReportInfoTableCell.swift
//  SwiftTest
//
//  Created by zhangliang on 2021/3/11.
//  Copyright © 2021 zhangliang. All rights reserved.
//

import UIKit

class ReportInfoTableCell: UITableViewCell {
    private var nameField: UITextField!
    private var phoneField: UITextField!
    
    var deleteBlock: (() -> Void)?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configureViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureViews() {
        let button = CommonFunction.createButton(frame: CGRect.zero, title: nil, textColor: nil, font: nil, imageName: "customerReport_delete", target: self, action: #selector(deleteAction))
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: -5)
        contentView.addSubview(button)
        
        nameField = createTextField(leftTitle: "姓名", placeholder: "请输入姓名")
        
        let lineView = UIView()
        lineView.backgroundColor = colorWithRGB(r: 240, g: 240, b: 240)
        contentView.addSubview(lineView)
        
        phoneField = createTextField(leftTitle: "手机号", placeholder: "请输入手机号")
        
        let bottomLine = UIView()
        bottomLine.backgroundColor = colorWithRGB(r: 240, g: 240, b: 240)
        contentView.addSubview(bottomLine)
        
        
        button.snp.makeConstraints { (make) in
            make.left.equalTo(0)
            make.width.height.equalTo(40)
            make.centerY.equalToSuperview()
        }
        
        nameField.snp.makeConstraints { (make) in
            make.top.right.equalTo(0)
            make.height.equalTo(40)
            make.left.equalTo(button.snp.right).offset(6)
        }
        
        lineView.snp.makeConstraints { (make) in
            make.right.equalTo(10)
            make.height.equalTo(1)
            make.top.equalTo(nameField.snp.bottom)
            make.left.equalTo(button.snp.right).offset(2)
        }
        
        phoneField.snp.makeConstraints { (make) in
            make.right.equalTo(0)
            make.height.equalTo(40)
            make.top.equalTo(lineView.snp.bottom)
            make.left.equalTo(button.snp.right).offset(6)
        }
        
        bottomLine.snp.makeConstraints { (make) in
            make.left.equalTo(20)
            make.right.equalTo(0)
            make.height.equalTo(1)
            make.top.equalTo(phoneField.snp.bottom)
        }
    }
    
    @objc private func deleteAction() {
        deleteBlock?()
    }
    
    private func createTextField(leftTitle: String, placeholder: String) -> UITextField {
        let field = DefinedTextField()
        field.font = UIFont.systemFont(ofSize: 14)
        field.placeholder = placeholder
        field.setPadding(enable: true, top: 0, left: 60, bottom: 0, right: 4)
        
        let label = CommonFunction.createLabel(frame: CGRect(x: 0, y: 0, width: 60, height: 40), text: leftTitle, font: UIFont.systemFont(ofSize: 14), textColor: UIColor.darkGray, textAlignment: .left)
        field.leftView = label
        field.leftViewMode = .always
        
        contentView.addSubview(field)
        
        return field
    }
}
