//
//  PayMethodView.swift
//  SwiftTest
//
//  Created by bfgjs on 2019/5/23.
//  Copyright © 2019 ZhangLiang. All rights reserved.
//

import UIKit

class PayMethodView: UIView {
    
    init() {
        super.init(frame: CGRect.zero)
        
        self.frame = CGRect(x: 0, y: 0, width: kMainScreenWidth, height: kMainScreenHeight)
        
        let visualEffect = UIBlurEffect(style: UIBlurEffect.Style.dark)
        let visualEffectView = UIVisualEffectView(effect: visualEffect)
        visualEffectView.alpha = 0.5
        visualEffectView.frame = self.bounds
        
        CommonFunction.addTapGesture(with: visualEffectView, target: self, action: #selector(visualViewClick))
        self.addSubview(visualEffectView)
        
        configureViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var bgView: UIView = {
        var view = UIView()
        view.backgroundColor = UIColor.white
        return view
    }()
    
    private func configureViews() {
        self.addSubview(bgView)
        bgView.snp.makeConstraints { (make) in
            make.top.left.right.equalTo(0)
            make.height.equalTo(287 + iphoneXBottomMargin)
        }
    }
    
    @objc private func visualViewClick() {
        dismissMethodView()
    }

    //MARK: - show / dismiss
    func showMethodView() {
        let window = getKeyWindow()
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseIn, animations: {
            window?.addSubview(self)
            self.bgView.snp.updateConstraints({ (make) in
                make.top.equalTo(self.zl_height - (287 + iphoneXBottomMargin))
            })
            
        }) { (finished) in
            window?.isHidden = false
        }
    }

    func dismissMethodView() {
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseOut, animations: {
            self.bgView.snp.updateConstraints({ (make) in
                make.top.equalTo(kMainScreenHeight + kNavBarAndStatusBarHeight)
            })
        }) { (finished) in
            self.alpha = 0
            self.removeFromSuperview()
            self.window?.isHidden = true
        }
    }
}
