//
//  BottomListView.swift
//  SwiftTest
//
//  Created by lezhi on 2018/6/15.
//  Copyright © 2018年 ZhangLiang. All rights reserved.
//

import UIKit

typealias ItemSelectBlock = () -> Void

private let itemHeight = 55
private let itemGap = 5
private let BottomCancelButtonHeight = 50 as CGFloat
private let BottomListViewAnimationTime = 0.15
private let BottomListViewAnimationInterval = BottomListViewAnimationTime/5

class BottomListView: UIView, UIGestureRecognizerDelegate {
    private var fullBgMaskView: UIView?
    private var titleLabel_: UILabel?
    private var buttons = [UIControl]()
    private var columnCount: Int = 1
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor(white: 0.95, alpha: 1)
        let viewTap = UITapGestureRecognizer(target: self, action: #selector(dismiss))
        viewTap.delegate = self
        self.isUserInteractionEnabled = true
        self.addGestureRecognizer(viewTap)
        
        fullBgMaskView = UIView(frame: CGRect(x: 0, y: 0, width: kMainScreenWidth, height: kMainScreenHeight))
        fullBgMaskView?.backgroundColor = UIColor(white: 0, alpha: 0.3)
        CommonFunction.addTapGesture(with: fullBgMaskView!, target: self, action: #selector(dismiss))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addMenuItemWith(title: String, selectBlock: @escaping ItemSelectBlock) {
        let itemButton = BottomListItemButton(title: title, selectBlock: selectBlock)
        itemButton.addTarget(self, action: #selector(itemButtonClick(btn:)), for: .touchUpInside)
        self.addSubview(itemButton)
        
        buttons.append(itemButton)
    }
    
    //MARK: -
    private func frameForButtonAt(index: Int) -> CGRect {
        return CGRect(x: 0, y: itemHeight * index, width: Int(kMainScreenWidth), height: itemHeight - itemGap)
    }
    
    private func riseAnimation() {
        for index in 0..<buttons.count {
            let frame = frameForButtonAt(index: index)
            let itemButton = buttons[index]
            itemButton.frame = frame
        }
        
        fullBgMaskView?.alpha = 0
        let frame = self.frame
        self.frame = CGRect(x: frame.origin.x, y: kMainScreenHeight, width: frame.size.width, height: frame.size.height)
        
        UIView.animate(withDuration: BottomListViewAnimationTime, animations: {
            self.fullBgMaskView?.alpha = 1
            self.frame = frame
        }) { (finished) in
            
        }
    }
    
    private func dropAnimation() {
        for index in 0..<buttons.count {
            let frame = frameForButtonAt(index: index)
            let itemButton = buttons[index]
            
            let toPosition = CGPoint(x: frame.origin.x + kMainScreenWidth / 2.0, y: kMainScreenHeight + CGFloat(itemHeight / 2))
            let interval = Double(index * columnCount) * BottomListViewAnimationInterval
            
            UIView.animate(withDuration: BottomListViewAnimationTime - interval, animations: {
                itemButton.layer.position = toPosition
            }) { (finished) in
                itemButton.removeFromSuperview()
            }
        }
    }
    
    func show() {
        let selfHeight = BottomCancelButtonHeight + CGFloat(itemHeight * buttons.count)
        self.frame = CGRect(x: 0, y: kMainScreenHeight - selfHeight - iphoneXBottomMargin, width: kMainScreenWidth, height: selfHeight)
        
        let cancelButton = CommonFunction.createButton(frame: CGRect(x: 0, y: self.frame.size.height - BottomCancelButtonHeight, width: self.frame.size.width, height: BottomCancelButtonHeight), title: CommonFunction.localizedString(originString: "Cancel"), textColor: UIColor.darkGray, font: UIFont.systemFont(ofSize: 14 * SCALE_RATIO_LIGHT_LIMIT), imageName: nil, isBackgroundImage: false, target: self, action: #selector(dismiss))
        cancelButton.backgroundColor = UIColor(white: 1, alpha: 1)
        self.addSubview(cancelButton)
        
        let window = getKeyWindow()
        window?.addSubview(fullBgMaskView!)
        window?.addSubview(self)
        
        riseAnimation()
    }
    
    //MARK: - action
    @objc private func itemButtonClick(btn: BottomListItemButton) {
        dismiss()
        
        let count = Double((buttons.count + 1))
        let timeInterval = BottomListViewAnimationTime + BottomListViewAnimationInterval*count
        DispatchQueue.main.asyncAfter(deadline: .now() + timeInterval) {
            btn.selectBlock!()
        }
    }
    
    @objc private func dismiss() {
        
        UIView.animate(withDuration: 0.1, animations: {
            self.fullBgMaskView?.alpha = 0
            self.frame = CGRect(x: self.frame.origin.x, y: kMainScreenHeight, width: self.frame.size.width, height: self.frame.size.height)
        }) { (finished) in
            self.fullBgMaskView?.removeFromSuperview()
            self.removeFromSuperview()
        }
    }
    
    //MARK: - UIGestureRecognizerDelegate
    override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if gestureRecognizer.view is BottomListItemButton {
            return false
        }
        
        let location = gestureRecognizer.location(in: self)
        for view in buttons {
            if view.frame.contains(location) {
                return false
            }
        }
        
        return true
    }
}

class BottomListItemButton: UIControl {
    var selectBlock: ItemSelectBlock?
    var titleLabel_: UILabel?
    
    init(title: String, selectBlock: @escaping ItemSelectBlock) {
        
        super.init(frame: CGRect.zero)
        self.selectBlock = selectBlock
        
        titleLabel_ = CommonFunction.createLabel(frame: CGRect(x: 0, y: 0, width: Int(kMainScreenWidth), height: itemHeight - itemGap), text: "", font: UIFont.systemFont(ofSize: 14*SCALE_RATIO_LIGHT_LIMIT), textColor: UIColor.darkGray, textAlignment: .center)
        titleLabel_?.text = title
        self.addSubview(titleLabel_!)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
