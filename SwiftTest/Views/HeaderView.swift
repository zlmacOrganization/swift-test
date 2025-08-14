//
//  HeaderView.swift
//  Exercise
//
//  Created by ZhangLiang on 2017/10/14.
//  Copyright © 2017年 ZhangLiang. All rights reserved.
//

import Foundation
import UIKit

typealias ButtonClickClosure = (String) -> Void

class HeaderView: UIView {
    private var nameLabel = UILabel()
    var buttonClickClosure : ButtonClickClosure?

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureViews() {
        nameLabel = CommonFunction.createLabel(frame: CGRect(x: 12, y: (self.frame.size.height - 20)/2, width: 150, height: 20), text: "", font: UIFont.systemFont(ofSize: 15), textColor: UIColor.darkGray, textAlignment: .left)
        nameLabel.text = "jianjiandandan"
        self.addSubview(nameLabel)
        
        let buttonWidth = 70 as CGFloat
        
        let button = CommonFunction.createButton(frame: CGRect(x: kMainScreenWidth - buttonWidth, y: (self.frame.size.height - 40)/2, width: buttonWidth, height: 40), title: "button", textColor: UIColor.red, font: UIFont.systemFont(ofSize: 15), imageName: nil, isBackgroundImage: false, target: self, action: #selector(buttonClickAction))
        button.setTitle("button", for: UIControl.State.normal)
        button.setTitleColor(UIColor.red, for: UIControl.State.normal)
        self.addSubview(button)
    }

    @objc func buttonClickAction() {
        
        if let closure = self.buttonClickClosure {
            closure("hahahaha")
        }
    }
}
