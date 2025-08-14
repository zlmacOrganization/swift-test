//
//  DXAlertView.swift
//  SwiftTest
//
//  Created by lezhi on 2018/6/12.
//  Copyright © 2018年 ZhangLiang. All rights reserved.
//

import UIKit

typealias LeftClickClosure = () -> Void
typealias RightClickClosure = () -> Void

class DXAlertView: UIView {
    private let kTitleHeight = 20
    private let kImglabelHeight = 40
    private let kContentOffset = 30 as CGFloat
    private let kBetweenLabelOffset = 20
    
    var leftBlock: LeftClickClosure?
    var rightBlock: RightClickClosure?
    
//    var customInterView: UIView
//    var imgView: UIImageView
//    var imgTitlelabel: UILabel
//    var imgTitleBgView: UIView
//    var imgmaskView: UIView
//    var dotLineView: UIImageView
    private var alertTitleLabel: UILabel?
    private var alertContentLabel: UILabel?
    private var leftBtn: UIButton?
    private var rightBtn: UIButton?
    private var backBgView: UIView?
    
    private var kAlertWidth: CGFloat
    private var kAlertHeight: CGFloat
//    var kImgHeight: Int
    private var leftLeave: Bool = false

    init(title: String, content: String, leftButtonTitle: String, rightButtonTitle: String) {
        
        kAlertHeight = 190;
        kAlertWidth = 300*SCALE_RATIO_LIGHT_MORE;
        
        super.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        
        configureViews(title: title, content: content, leftButtonTitle: leftButtonTitle, rightButtonTitle: rightButtonTitle)
        
        self.layer.cornerRadius = 10.0
        self.backgroundColor = UIColor.white
        self.clipsToBounds = true;
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("DXAlertView deinit ++++")
    }
    
    private func configureViews(title: String, content: String, leftButtonTitle: String, rightButtonTitle: String) {
        let topYTitle = 26;
        let contentTitleGap = 5*SCALE_RATIO;
        let contentHeight = 60 as CGFloat
        let closeButtonWidth = 24 as CGFloat
        let closeButtonGap = 8 as CGFloat
        
        self.alertTitleLabel = CommonFunction.createLabel(frame: CGRect(x: 0, y: topYTitle, width: Int(kAlertWidth), height: kTitleHeight), text: "", font: UIFont.systemFont(ofSize: 16), textColor: colorWithRGB(r: 56, g: 64, b: 71), textAlignment: .center)
        self.alertTitleLabel?.text = title
        self.addSubview(alertTitleLabel!)
        
        let contentLabelWidth = kAlertWidth - kContentOffset
        self.alertContentLabel = CommonFunction.createLabel(frame: CGRect(x: (kAlertWidth - contentLabelWidth) * 0.5, y: (self.alertTitleLabel?.frame.maxY)! + contentTitleGap, width: contentLabelWidth, height: contentHeight), text: "", font: UIFont.systemFont(ofSize: 14), textColor: colorWithRGB(r: 127, g: 127, b: 127), textAlignment: .center)
        self.alertContentLabel?.text = content
        self.alertContentLabel?.numberOfLines = 0
        self.addSubview(self.alertContentLabel!)
        
        var leftBtnFrame: CGRect
        let rightBtnFrame: CGRect
        let kSingleButtonWidth = 160 as CGFloat
        let kCoupleButtonWidth = 107 as CGFloat
        let kButtonHeight = 40 as CGFloat
        let kButtonBottomOffset = 15 as CGFloat
        
        if leftButtonTitle.isEmpty {
            if !rightButtonTitle.isEmpty {
                rightBtnFrame = CGRect(x: (kAlertWidth - kSingleButtonWidth) * 0.5, y: kAlertHeight - kButtonBottomOffset - kButtonHeight, width: kCoupleButtonWidth, height: kButtonHeight)
                self.rightBtn = CommonFunction.createButton(frame: rightBtnFrame, title: rightButtonTitle, textColor: UIColor.white, font: UIFont.systemFont(ofSize: 15), imageName: nil, isBackgroundImage: false, target: self, action: #selector(rightButtonClick))
                self.rightBtn?.backgroundColor = NewBgColor
                self.addSubview(self.rightBtn!)
            }
        }else{
            leftBtnFrame = CGRect(x: (kAlertWidth - 2 * kCoupleButtonWidth - kButtonBottomOffset) * 0.5, y: kAlertHeight - kButtonBottomOffset - kButtonHeight, width: kCoupleButtonWidth, height: kButtonHeight)
            rightBtnFrame = CGRect(x: leftBtnFrame.maxX + kButtonBottomOffset, y: kAlertHeight - kButtonBottomOffset - kButtonHeight, width: kCoupleButtonWidth, height: kButtonHeight)
            
            self.leftBtn = CommonFunction.createButton(frame: leftBtnFrame, title: leftButtonTitle, textColor: UIColor.white, font: UIFont.systemFont(ofSize: 15), imageName: nil, isBackgroundImage: false, target: self, action: #selector(leftButtonClick))
            self.leftBtn?.backgroundColor = NewBgColor
            self.leftBtn?.layer.cornerRadius = 3
            self.leftBtn?.clipsToBounds = true
            self.addSubview(self.leftBtn!)
            
            if rightButtonTitle.isEmpty {
                leftBtnFrame = CGRect(x: (kAlertWidth - kSingleButtonWidth) * 0.5, y: kAlertHeight - kButtonBottomOffset - kButtonHeight, width: kSingleButtonWidth, height: kButtonHeight)
                self.leftBtn?.frame = leftBtnFrame
            }else{
                self.rightBtn = CommonFunction.createButton(frame: rightBtnFrame, title: rightButtonTitle, textColor: UIColor.white, font: UIFont.systemFont(ofSize: 15), imageName: nil, isBackgroundImage: false, target: self, action: #selector(rightButtonClick))
                self.rightBtn?.backgroundColor = NewBgColor
                self.rightBtn?.layer.cornerRadius = 3
                self.rightBtn?.clipsToBounds = true
                self.addSubview(self.rightBtn!)
            }
        }
        
        let closeButton = CommonFunction.createButton(frame: CGRect(x: kAlertWidth - closeButtonWidth - closeButtonGap, y: closeButtonGap, width: closeButtonWidth, height: closeButtonWidth), title: nil, textColor: nil, font: nil, imageName: "btn_close_normal", isBackgroundImage: false, target: self, action: #selector(closeButtonClick))
        closeButton.layer.cornerRadius = closeButtonWidth/2
        closeButton.clipsToBounds = true
        let tintImage = UIImage(named: "btn_close_normal")?.imageWith(tintColor: UIColor.white)
        closeButton.setImage(tintImage, for: .normal)
        closeButton.backgroundColor = NewBgColor
        self.addSubview(closeButton)
    }
    
    //MARK: - action
    @objc private func leftButtonClick() {
        leftLeave = true
        dismissAlert()
        
        if self.leftBlock != nil {
            self.leftBlock!()
        }
    }
    
    @objc private func rightButtonClick() {
        leftLeave = false
        dismissAlert()
        
        if self.rightBlock != nil {
            self.rightBlock!()
        }
    }
    
    @objc private func closeButtonClick() {
        dismissAlert()
    }
    
    private func dismissAlert() {
        self.removeFromSuperview()
    }
    
    //MARK: - override
    private func appRootViewController() -> UIViewController {
        let appRootVC = getKeyWindow()?.rootViewController
        var topVC = appRootVC
        while ((topVC?.presentedViewController) != nil) {
            topVC = topVC?.presentedViewController
        }
        return topVC!
    }
    
    override func willMove(toSuperview newSuperview: UIView?) {
        if newSuperview == nil {
            return
        }
        
        let topVC = appRootViewController()
        
        self.backBgView = UIView.init(frame: topVC.view.bounds)
        self.backBgView?.backgroundColor = UIColor.black.withAlphaComponent(0.25)
        CommonFunction.addTapGesture(with: self.backBgView!, target: self, action: #selector(closeButtonClick))
        
        topVC.view.addSubview(self.backBgView!)
        self.transform = CGAffineTransform(rotationAngle: CGFloat(-M_1_PI / 2))
        
        UIView.animate(withDuration: 0.15, delay: 0, options: .curveEaseIn, animations: {
            self.transform = CGAffineTransform(rotationAngle: 0)
            self.frame = CGRect(x: (topVC.view.bounds.size.width - self.kAlertWidth)/2, y: (topVC.view.bounds.size.height - self.kAlertHeight)/2, width: self.kAlertWidth, height: self.kAlertHeight)
        }) { (finished) in
            
        }
        
        super.willMove(toSuperview: newSuperview)
    }
    
    override func removeFromSuperview() {
        self.backBgView?.removeFromSuperview()
        
        let topVC = appRootViewController()
        let afterFrame = CGRect(x: (topVC.view.bounds.size.width - self.kAlertWidth)/2, y: topVC.view.bounds.size.height, width: kAlertWidth, height: kAlertHeight)
        
        UIView.animate(withDuration: 0.15, delay: 0, options: .curveEaseIn, animations: {
            self.transform = CGAffineTransform(rotationAngle: 0)
            self.frame = afterFrame
            
            if self.leftLeave {
                self.transform = CGAffineTransform(rotationAngle: CGFloat(-M_1_PI / 1.5))
            }else{
                self.transform = CGAffineTransform(rotationAngle: CGFloat(M_1_PI / 1.5))
            }
        }) { (finished) in
            super.removeFromSuperview()
        }
    }
    
    func show() {
        let window = getKeyWindow()
        self.frame = CGRect(x: ((window?.bounds.size.width)! - kAlertWidth)/2, y: -kAlertHeight - 30, width: kAlertWidth, height: kAlertHeight)
        window?.addSubview(self)
    }
}
