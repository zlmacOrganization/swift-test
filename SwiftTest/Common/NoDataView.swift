//
//  NoDataView.swift
//  SwiftTest
//
//  Created by lezhi on 2018/6/22.
//  Copyright © 2018年 ZhangLiang. All rights reserved.
//

import UIKit
import SnapKit

enum LoadingType {
    case loading, empty, error
}

class NoDataView: UIView {
    private let loadImageWith = 100 as CGFloat
    private let loadImageHeight = 30 as CGFloat
    private let firstMargin = 10 as CGFloat
    private let secondMargin = 18 as CGFloat
    
    private var type: LoadingType
    
    private var bgView = UIView()
    var firstLabel: UILabel!
    var noImageView: UIImageView!
    private var retryButton: UIButton?
    private var activityView: UIActivityIndicatorView?
    
    var retryBlock: (() -> Void)?

    
    init(frame: CGRect, type: LoadingType) {
        self.type = type
        super.init(frame: frame)
        
        configureViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureViews() {
        addSubview(bgView)
        
        firstLabel = CommonFunction.createLabel(frame: CGRect.zero, text: "", font: UIFont.systemFont(ofSize: 14), textColor: UIColor(white: 0.2, alpha: 1), textAlignment: .center)
        bgView.addSubview(firstLabel)
        
//        secondLabel = CommonFunction.createLabel(frame: CGRect.zero, text: "", font: UIFont.systemFont(ofSize: 13), textColor: UIColor(white: 0.2, alpha: 1), textAlignment: .center)
//        bgView.addSubview(secondLabel)
        
        noImageView = UIImageView()
        noImageView.contentMode = .scaleAspectFill
        noImageView.clipsToBounds = true
        bgView.addSubview(noImageView)
        
//        activityView = UIActivityIndicatorView()
//        activityView?.style = .gray
//        self.addSubview(activityView!)
        
        if type == .error {
            retryButton = CommonFunction.createButton(frame: CGRect.zero, title: "重试", textColor: UIColor.white, font: UIFont.systemFont(ofSize: 14), imageName: nil, target: self, action: #selector(retryAction))
            retryButton?.backgroundColor = UIColor.red
            bgView.addSubview(retryButton!)
        }
        
        makeViewConstraints()
    }
    
    private func makeViewConstraints() {
        bgView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-kNavBarAndStatusBarHeight)
        }
        
        noImageView.snp.makeConstraints({ (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(0)
            make.size.equalTo(CGSize(width: loadImageWith, height: loadImageWith))
        })
        
        firstLabel.snp.makeConstraints({ (make) in
            make.top.equalTo(noImageView.snp.bottom).offset(firstMargin)
            make.left.right.equalToSuperview()
            
            if self.type != .error {
                make.bottom.equalTo(0)
            }
        })
        
//        secondLabel.snp.makeConstraints({ (make) in
//            make.top.equalTo(firstLabel.snp.bottom).offset(firstMargin)
//            make.left.right.equalToSuperview()
//        })
        
//        activityView?.snp.makeConstraints({ (make) in
//            make.centerX.centerY.equalToSuperview()
//            make.size.equalTo(CGSize(width: 60, height: 60))
//        })
        
        if type == .error {
            retryButton?.snp.makeConstraints({ (make) in
                make.centerX.equalToSuperview()
                make.top.equalTo(firstLabel.snp.bottom).offset(firstMargin)
                make.size.equalTo(CGSize(width: 80, height: 32))
                make.bottom.equalTo(0)
            })
        }
    }
    
    @objc private func retryAction() {
        retryBlock?()
    }
    
    func startAnimationWith(imageArray: Array<UIImage>) {
        noImageView?.animationImages = imageArray
        noImageView?.animationDuration = 0.8
        
        let imageY = (self.frame.size.height - loadImageHeight)/2
        noImageView?.frame = CGRect(x: (self.frame.size.width - loadImageWith)/2, y: imageY*0.85, width: loadImageWith, height: loadImageHeight)
        
        noImageView?.startAnimating()
    }
    
    func stopAnimation() {
        noImageView?.stopAnimating()
        noImageView?.isHidden = true
//        noImageView?.removeFromSuperview()
    }
    
    deinit {
        activityView?.stopAnimating()
    }
}
