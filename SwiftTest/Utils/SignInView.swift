//
//  SignInView.swift
//  SwiftTest
//
//  Created by ZhangLiang on 2020/7/3.
//  Copyright © 2020 ZhangLiang. All rights reserved.
//

import UIKit
import AuthenticationServices

class SignInView: UIView {

    init() {
        super.init(frame: CGRect.zero)
        
        addASAuthorizationButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addASAuthorizationButton() {
        if #available(iOS 13.0, *) {
            let signButton = ASAuthorizationAppleIDButton(type: .default, style: .black)
            signButton.addTarget(self, action: #selector(buttonClick), for: .touchUpInside)
            addSubview(signButton)
            
            signButton.snp.makeConstraints { (make) in
                make.center.equalToSuperview()
            }
        }
    }
    
    @objc private func buttonClick() {
        SignInTool.shareInstance.signInWithApple()
    }
}
