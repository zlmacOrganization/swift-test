//
//  ZLSegmentTitleView.swift
//  SwiftTest
//
//  Created by bfgjs on 2020/1/3.
//  Copyright © 2020 ZhangLiang. All rights reserved.
//

import UIKit

protocol ZLSegmentTitleViewDelegate: AnyObject {
    func zlSegmentTitleView(titleView: ZLSegmentTitleView, startIndex: Int, endIndex: Int)
    func zlSegmentTitleViewWillBeginDragging()
    func zlSegmentTitleViewWillEndDragging()
}

extension ZLSegmentTitleViewDelegate {
    func zlSegmentTitleViewWillBeginDragging() {
        
    }
    
    func zlSegmentTitleViewWillEndDragging() {
        
    }
}

class ZLSegmentTitleView: UIView {
    private let tagNum = 222
    private let indicatorWidth: CGFloat = 30
    private var titles: [String]
    private var buttons: [UIButton] = []
    private weak var delegate: ZLSegmentTitleViewDelegate?
    private var currentIndicatorX: CGFloat = 0
    
    private var scrollView: UIScrollView!
    private var indicatorView: UIView!
    
    var selectIndex: Int = 0 {
        didSet {
            if (selectIndex < 0 || selectIndex > buttons.count - 1) {
                return;
            }
            
            for button in buttons {
                let index = button.tag - tagNum
                if selectIndex == index {
                    button.isSelected = true
                    button.titleLabel?.font = titleSelectFont
                }else {
                    button.isSelected = false
                    button.titleLabel?.font = titleFont
                }
            }
            
            setNeedsLayout()
            layoutIfNeeded()
        }
    }
    
    var itemMargin: CGFloat = 15 {
        didSet {
            setNeedsLayout()
            layoutIfNeeded()
        }
    }
    
    var titleFont: UIFont = UIFont.systemFont(ofSize: 14)
    
    var titleSelectFont: UIFont = UIFont.systemFont(ofSize: 15)
    
    var normalTitleColor: UIColor = UIColor.darkGray
    
    var selectTitleColor: UIColor = UIColor.red
    
    var indicatorColor: UIColor = UIColor.purple {
        didSet {
            indicatorView.backgroundColor = indicatorColor
        }
    }

    //MARK: -
    init(frame: CGRect, titles: [String], delegate: ZLSegmentTitleViewDelegate?) {
        self.titles = titles
        self.delegate = delegate
        super.init(frame: frame)
        
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        scrollView = UIScrollView()
        scrollView.delegate = self
        scrollView.showsHorizontalScrollIndicator = false
        addSubview(scrollView)
        
        
        for (i, title) in titles.enumerated() {
            let button = CommonFunction.createButton(frame: CGRect.zero, title: title, textColor: normalTitleColor, font: titleFont, imageName: nil, isBackgroundImage: false, target: self, action: #selector(itemButtonClick(_:)))
            button.setTitleColor(selectTitleColor, for: .selected)
            button.tag = buttons.count + tagNum
            
            if i == selectIndex {
                button.isSelected = true
                button.titleLabel?.font = titleSelectFont
            }
            
            scrollView.addSubview(button)
            buttons.append(button)
        }
        
        indicatorView = UIView()
        indicatorView.backgroundColor = indicatorColor
        scrollView.addSubview(indicatorView)
    }
    
    @objc private func itemButtonClick(_ button: UIButton) {
        let index = button.tag - tagNum
        
        for btn in buttons {
            if btn.tag == button.tag {
                btn.isSelected = true
            }else {
                btn.isSelected = false
            }
        }
        
        if index == selectIndex {
            return
        }
        
        delegate?.zlSegmentTitleView(titleView: self, startIndex: selectIndex, endIndex: index)
        selectIndex = index
    }
    
    //MARK: -
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let width = self.zl_width
        scrollView.frame = CGRect(x: 0, y: 0, width: width, height: self.zl_height)
        
        if titles.isEmpty {
            return
        }
        
        var totalBtnWidth: CGFloat = 0
        for (i, title) in titles.enumerated() {
            let font = getCurrentButtonFont(index: i)
            let btnWidth = CommonFunction.getTextWidth(string: title, font: font, height: 20) + itemMargin
            totalBtnWidth += btnWidth
        }
        
        if totalBtnWidth < width {
            let itemWidth = width/CGFloat(buttons.count)
            for (i, button) in buttons.enumerated() {
                button.frame = CGRect(x: CGFloat(i)*itemWidth, y: 0, width: itemWidth, height: self.zl_height)
            }
            
            scrollView.contentSize = CGSize(width: width, height: self.zl_height)
        }else {
            var currentX: CGFloat = 0
            for (i, button) in buttons.enumerated() {
                let font = getCurrentButtonFont(index: i)
                let itemWidth = CommonFunction.getTextWidth(string: titles[i], font: font, height: 20) + itemMargin
                button.frame = CGRect(x: currentX, y: 0, width: itemWidth, height: self.zl_height)
                
                currentX += itemWidth
            }
            
            scrollView.contentSize = CGSize(width: totalBtnWidth, height: self.zl_height)
        }
        
        moveIndicatorView(animated: true)
    }
    
    private func moveIndicatorView(animated: Bool) {
        
        guard selectIndex < buttons.count else {
            return
        }
        let button = buttons[selectIndex]
        let duration = animated ? 0.1 : 0
        
        UIView.animate(withDuration: duration, animations: {
            let viewX = button.center.x - self.indicatorWidth/2
            self.currentIndicatorX = viewX
            self.indicatorView.frame = CGRect(x: viewX, y: self.frame.size.height - 3, width: self.indicatorWidth, height: 2)
        }) { (finished) in
//            self.scrollRect(button: button, animated: animated)
            self.scrollSelectItemToMiddle(button: button)
        }
    }
    
    private func scrollRect(button: UIButton, animated: Bool) {
        let centerRect = CGRect(x: button.center.x - scrollView.zl_width/2, y: 0, width: scrollView.zl_width, height: scrollView.zl_height)
        scrollView.scrollRectToVisible(centerRect, animated: animated)
    }
    
    func scrollSelectItemToMiddle(button: UIButton) {
        let offsetX:CGFloat = (frame.size.width - button.frame.size.width) / 2
        if button.frame.origin.x <= frame.size.width / 2 {
            scrollView.setContentOffset(CGPoint.zero, animated: true)
        } else if button.frame.maxX >= (scrollView.contentSize.width - frame.size.width / 2) {
            scrollView.setContentOffset(CGPoint.init(x: scrollView.contentSize.width - frame.size.width, y: 0), animated: true)
        } else {
            scrollView.setContentOffset(CGPoint.init(x: button.frame.minX - offsetX, y: 0), animated: true)
        }
    }
    
    func resetIndicatorFrame(progress: CGFloat, offset: CGPoint) {
//        let buttonWidth = kMainScreenWidth/CGFloat(titles.count)
//        let viewX = buttonWidth * progress + (buttonWidth - indicatorWidth)/2
        
        if selectIndex >= titles.count {
            return
        }
        
        var viewX = currentIndicatorX
        
        var itemWidth = CommonFunction.getTextWidth(string: titles[selectIndex], font: getCurrentButtonFont(index: selectIndex), height: 20) + itemMargin
        if itemWidth >= 95 {
            itemWidth = 85
        }
        
        let offsetX = offset.x - CGFloat(selectIndex) * kMainScreenWidth
        
//        if offsetX > 0 {
//            if selectIndex + 1 < titles.count {
//                itemWidth = CommonFunction.getTextWidth(string: titles[selectIndex + 1], font: getCurrentButtonFont(index: selectIndex + 1), height: 20) + itemMargin
//            }
//        }else if offsetX < 0 {
//            itemWidth = CommonFunction.getTextWidth(string: titles[selectIndex - 1], font: getCurrentButtonFont(index: selectIndex - 1), height: 20) + itemMargin
//        }
        
        viewX += offsetX*itemWidth/kMainScreenWidth
        
        indicatorView.frame = CGRect(x: viewX, y: self.frame.size.height - 3, width: self.indicatorWidth, height: 2)
    }
    
    private func getCurrentButtonFont(index: Int) -> UIFont {
        if index >= titles.count {
            return titleFont
        }
        
        let button = buttons[index]
        let font = button.isSelected ? titleSelectFont : titleFont
        return font
    }
}

extension ZLSegmentTitleView: UIScrollViewDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        delegate?.zlSegmentTitleViewWillBeginDragging()
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        delegate?.zlSegmentTitleViewWillEndDragging()
    }
}
