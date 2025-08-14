//
//  TBPasswordTextField.swift
//  AirDroid
//
//  iOS 14.2开始，使用中文九宫格键盘无法输入密码
//  https://developer.apple.com/forums/thread/668859
//  我决定通过替身来修复此问题
//
//  Created by Easher Yii on 2021/3/5.
//  Copyright © 2021 sandstudio. All rights reserved.
//

import UIKit

fileprivate class TBShadowTextField: UITextField {
    override func becomeFirstResponder() -> Bool {
        superview?.becomeFirstResponder()
        return false
    }
}

class TBPasswordTextField: UITextField {
    private lazy var shadowTextField: TBShadowTextField = { [weak self] in
        let view = TBShadowTextField()
        view.placeholder = self?.placeholder
        view.isSecureTextEntry = true
        view.keyboardType = .asciiCapable
        self?.addSubview(view)
        return view
    }()
    
    var isSecurePassword: Bool = true {
        didSet {
            isSecureTextEntry = isSecurePassword
            rightViewMode = isSecurePassword ? .whileEditing : .always
        }
    }
    
    override var text: String? {
        didSet {
            shadowTextField.text = text
        }
    }
    
    init(placeholder: String) {
        super.init(frame: .zero)
        self.placeholder = placeholder
        self.setEyeButton()
        self.setShadowTextFieldHidden(true, initial: true)
        self.keyboardType = .asciiCapable
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setEyeButton() {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "ic_eye"), for: .normal)
        button.setImage(UIImage(named: "ic_eye_h"), for: .selected)
        button.sizeToFit()
        button.addTarget(self, action: #selector(eyeButtonAction(_:)), for: .touchUpInside)
        rightView = button
        rightViewMode = .whileEditing
    }
    
    @objc func eyeButtonAction(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        isSecurePassword = !sender.isSelected
    }
    
    func setShadowTextFieldHidden(_ hidden: Bool, initial: Bool) {
        guard isSecurePassword else { return }
        if !initial { // 初始化时只隐藏视图，不设置密码文本，否则在iOS 14.2下会触发密码自动填充的bug，导致键盘卡住
            isSecureTextEntry = hidden
        }
        subviews.forEach({ $0.isHidden = !hidden })
        rightView?.isHidden = !hidden
        shadowTextField.isHidden = hidden
        shadowTextField.text = self.text
    }
    
    @discardableResult
    override func becomeFirstResponder() -> Bool {
        setShadowTextFieldHidden(true, initial: false)
        return super.becomeFirstResponder()
    }
    
    @discardableResult
    override func resignFirstResponder() -> Bool {
        defer {
            setShadowTextFieldHidden(false, initial: false)
        }
        return super.resignFirstResponder()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        shadowTextField.frame = self.bounds
    }
}
