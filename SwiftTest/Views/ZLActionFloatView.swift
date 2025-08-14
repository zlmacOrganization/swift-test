//
//  ZLActionFloatView.swift
//  SwiftTest
//
//  Created by bfgjs on 2019/1/10.
//  Copyright © 2019年 ZhangLiang. All rights reserved.
//

import UIKit
import SnapKit

private let kActionViewWidth: CGFloat = 140   //container view width
private let kActionViewHeight: CGFloat = 190    //container view height
private let kActionButtonHeight: CGFloat = 44   //button height
private let kFirstButtonY: CGFloat = 12 //the first button Y value

protocol ActionFloatViewDelegate: AnyObject {
    func floatViewTapItemIndex(_ type: ActionFloatViewItemType)
}

enum ActionFloatViewItemType: Int {
    case groupChat = 0, addFriend, scan, payment
}

class ZLActionFloatView: UIView {
    weak var delegate: ActionFloatViewDelegate?
    
    override init (frame: CGRect) {
        super.init(frame : frame)
        self.initContent()
    }
    
    convenience init () {
        self.init(frame:CGRect.zero)
        self.initContent()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    fileprivate func initContent() {
        self.backgroundColor = UIColor.clear
        let actionImages = [
            UIImage(named: "contacts_add_newmessage"),
            UIImage(named: "barbuttonicon_add_cube"),
            UIImage(named: "contacts_add_scan"),
            UIImage(named: "receipt_payment_icon")
            ]
        
        let actionTitles = [
            "发起群聊",
            "添加朋友",
            "扫一扫",
            "收付款",
            ]
        
        //Init containerView
        let containerView : UIView = UIView()
        containerView.backgroundColor = UIColor.clear
        self.addSubview(containerView)
        containerView.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(self.snp.top).offset(3)
            make.right.equalTo(self.snp.right).offset(-5)
            make.width.equalTo(kActionViewWidth)
            make.height.equalTo(kActionViewHeight)
        }
        
        //Init bgImageView
        let stretchInsets = UIEdgeInsets(top: 14, left: 6, bottom: 6, right: 34)
        let bubbleMaskImage = UIImage(named: "rightFloatBg")?.resizableImage(withCapInsets: stretchInsets, resizingMode: .stretch)
        let bgImageView: UIImageView = UIImageView(image: bubbleMaskImage)
        containerView.addSubview(bgImageView)
        bgImageView.snp.makeConstraints { (make) -> Void in
            make.edges.equalTo(containerView)
        }
        
        //init custom buttons
        var yValue = kFirstButtonY
        for index in 0 ..< actionImages.count {
            let itemButton: UIButton = UIButton(type: .custom)
            itemButton.backgroundColor = UIColor.clear
            itemButton.titleLabel!.font = UIFont.systemFont(ofSize: 17)
            itemButton.setTitleColor(UIColor.white, for: UIControl.State())
            itemButton.setTitleColor(UIColor.white, for: .highlighted)
            itemButton.setTitle(actionTitles[index], for: .normal)
            itemButton.setTitle(actionTitles[index], for: .highlighted)
            itemButton.setImage(actionImages[index], for: .normal)
            itemButton.setImage(actionImages[index], for: .highlighted)
            itemButton.addTarget(self, action: #selector(ZLActionFloatView.buttonTaped(_:)), for: UIControl.Event.touchUpInside)
            itemButton.contentHorizontalAlignment = .left
            itemButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 0)
            itemButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
            itemButton.tag = index
            containerView.addSubview(itemButton)
            
            itemButton.snp.makeConstraints { (make) -> Void in
                make.top.equalTo(containerView.snp.top).offset(yValue)
                make.right.equalTo(containerView.snp.right)
                make.width.equalTo(containerView.snp.width)
                make.height.equalTo(kActionButtonHeight)
            }
            yValue += kActionButtonHeight
        }
        
        CommonFunction.addTapGesture(with: self, target: self, action: #selector(ZLActionFloatView.viewTapped))
        
        self.isHidden = true
    }
    
    @objc private func viewTapped() {
        self.hide(true)
    }
    
    @objc private func buttonTaped(_ sender: UIButton!) {
        guard let delegate = self.delegate else {
            self.hide(true)
            return
        }
        
        let type = ActionFloatViewItemType(rawValue:sender.tag)!
        delegate.floatViewTapItemIndex(type)
        self.hide(true)
    }
    
    /**
     Hide the float view
     
     - parameter hide: is hide
     */
    func hide(_ hide: Bool) {
        if hide {
            self.alpha = 1.0
            UIView.animate(withDuration: 0.2 ,
                           animations: {
                            self.alpha = 0.0
            },
                           completion: { finish in
                            self.isHidden = true
                            self.alpha = 1.0
            })
        } else {
            self.alpha = 1.0
            self.isHidden = false
        }
    }

}
