//
//  KeyboardLayoutViewController.swift
//  SwiftTest
//
//  Created by zhangliang on 2022/4/12.
//  Copyright © 2022 zhangliang. All rights reserved.
//

import UIKit
import MetricKit

class KeyboardLayoutViewController: BaseViewController {
    private var textField: UITextField!
    private var inputTextField: UITextField = CommonFunction.createTextField(frame: CGRect(x: 0, y: kMainScreenHeight - kNaviBarHeight - iphoneXBottomMargin - 40, width: kMainScreenWidth, height: 40), fontNum: 15, textColor: UIColor.darkGray, placeholder: "input something")
    private var textView: UITextView!
    private var keyboardIsHidden = true
    
    private var myInputView = ZLInputView(frame: CGRect.zero)

    override func viewDidLoad() {
        super.viewDidLoad()

        configureViews()
        
//        if #available(iOS 13.0, *) {
//            MXMetricManager.shared.add(self)
//        }
    }
    
//    override var canBecomeFirstResponder: Bool {
//        return true
//    }
//
//    override var inputAccessoryView: UIView? {
//        get {
////            myInputView.sendBlock?.delegate(on: self, block: { (self, inputText) in
////                print("inputText: \(inputText)")
////                self.view.endEditing(true)
////            })
//
//            if keyboardIsHidden {
//                inputTextField.frame = CGRect(x: 0, y: -iphoneXBottomMargin, width: kMainScreenWidth, height: 40)
//            }else {
//                inputTextField.frame = CGRect(x: 0, y: 0, width: kMainScreenWidth, height: 40)
//            }
//
//            inputTextField.delegate = self
//            inputTextField.borderStyle = .line
//            return inputTextField
//        }
//    }
    
    deinit {
//        if #available(iOS 13.0, *) {
//            MXMetricManager.shared.remove(self)
//        }
    }
    
    private func configureViews() {
        textField = CommonFunction.createTextField(frame: CGRect.zero, fontNum: 15, textColor: UIColor.darkGray, placeholder: "input something")
        textField.borderStyle = .bezel
        textField.delegate = self
        textField.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(textField)

        if #available(iOS 15.0, *) {
            view.keyboardLayoutGuide.followsUndockedKeyboard = true

            let layout = view.keyboardLayoutGuide.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 20)
            view.keyboardLayoutGuide.setConstraints([layout], activeWhenAwayFrom: .top)
        }

        NSLayoutConstraint.activate([
            textField.widthAnchor.constraint(equalToConstant: 200),
            textField.heightAnchor.constraint(equalToConstant: 40),
            textField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//            textField.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -160)
        ])
    }
    
    private func addKeyboardNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_ :)), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidHide(_ :)), name: UIResponder.keyboardDidHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardFrameChanged(_:)), name: UIResponder.keyboardDidChangeFrameNotification, object: nil)
    }
    
    @objc private func sendAction() {
        
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        inputTextField.resignFirstResponder()
        view.endEditing(true)
    }
}

extension KeyboardLayoutViewController {
    // MARK: - KeyboardNotification
    @objc func keyboardWillShow(_ notify: Notification) {
        keyboardIsHidden = false
    }
    
    @objc func keyboardWillHide(_ notify: Notification) {
        keyboardIsHidden = true
    }
    
    @objc func keyboardDidHide(_ notify: Notification) {
        keyboardIsHidden = true
    }
    
    @objc func keyboardFrameChanged(_ notification: Notification) {
//        if !keyboardIsHidden {
//            guard let userInfo = notification.userInfo, let frame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect
//            else {
//                return
//            }
//            let convertedFrame = view.convert(frame, from: UIScreen.main.coordinateSpace)
//            let intersectedKeyboardHeight = view.frame.intersection(convertedFrame).height
//            print("kHeight: \(intersectedKeyboardHeight)")
//        }
    }
}

extension KeyboardLayoutViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        inputTextField.resignFirstResponder()
        return true
    }
    
    @available(iOS 16.0, *)
    func textField(_ textField: UITextField, editMenuForCharactersIn range: NSRange, suggestedActions: [UIMenuElement]) -> UIMenu? {
        let favorite = UIAction(title: "Favorite") { _ in
            print("favorite")
        }
        let share = UIAction(title: "Share") { _ in
            print("share")
        }
        let delete = UIAction(title: "Delete", attributes: [.destructive]) { _ in
            print("delete")
        }
        return UIMenu(children: [favorite, share, delete])
    }
}

@available(iOS 13.0, *)
extension KeyboardLayoutViewController: MXMetricManagerSubscriber {
    func didReceive(_ payloads: [MXMetricPayload]) {
        print("payloads: \(payloads)")
    }
}

class ZLInputView: UIView {
    private var inputTextField: UITextField!
    private var sendButton: UIButton!
    var sendBlock: Delegate<String, Void>?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureViews()
    }
    
//    override var intrinsicContentSize: CGSize {
//        return .zero
//    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureViews() {
        let buttonWidth: CGFloat = 60
        inputTextField = CommonFunction.createTextField(frame: CGRect.zero, fontNum: 15, textColor: UIColor.darkGray, placeholder: "please input...")
        inputTextField.borderStyle = .bezel
        addSubview(inputTextField)
        
        sendButton = CommonFunction.createButton(frame: CGRect.zero, title: "send", textColor: UIColor.blue, font: UIFont.systemFont(ofSize: 15), target: self, action: #selector(sendAction))
        addSubview(sendButton)
        
        inputTextField.snp.makeConstraints { make in
            make.left.equalTo(20)
            make.right.equalTo(sendButton.snp.left).offset(-10)
            make.height.equalTo(40)
            make.bottom.equalTo(0)
        }
        
        sendButton.snp.makeConstraints { make in
            make.left.equalTo(inputTextField.snp.right).offset(10)
            make.right.equalTo(-6)
            make.centerY.equalTo(inputTextField)
            make.size.equalTo(CGSize(width: buttonWidth, height: 40))
        }
    }
    
    @objc private func sendAction() {
        sendBlock?.call(inputTextField.text ?? "")
        print("sendAction ++++")
    }
}
