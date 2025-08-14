//
//  ZLSliderView.swift
//  SwiftTest
//
//  Created by zhangliang on 2021/3/30.
//  Copyright © 2021 zhangliang. All rights reserved.
//

import UIKit

class ZLSliderView: UIView {
    private var scrollView: UIScrollView!
    private var pageLine: UIView!
    private var buttons: [UIButton] = []
    
    private var titles: [String]
    private var hasLine: Bool
    
    private let btnWidth: CGFloat = kMainScreenWidth/5.2
    private let btnHeight: CGFloat = 40
    private let lineWidth: CGFloat = 30
    
    var itemClickBlock: ((Int) -> Void)?

    init(titles: [String], hasLine: Bool = true) {
        self.titles = titles
        self.hasLine = hasLine
        super.init(frame: CGRect.zero)
        
        configureViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureViews() {
        scrollView = UIScrollView()
        addSubview(scrollView)
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.contentSize = CGSize(width: btnWidth*CGFloat(titles.count), height: btnHeight)
        
        scrollView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        for i in 0..<titles.count {
            let button = CommonFunction.createButton(frame: CGRect(x: CGFloat(i)*btnWidth, y: 0, width: btnWidth, height: btnHeight), title: titles[i], textColor: UIColor.darkGray, font: UIFont.systemFont(ofSize: 14), imageName: nil, target: self, action: #selector(buttonAction(_:)))
            button.setTitleColor(colorWithRGB(r: 247, g: 54, b: 87), for: .selected)
            button.tag = i
            scrollView.addSubview(button)
            
            buttons.append(button)
            
            if i == 0 {
                button.isSelected = true
            }
        }
        
        pageLine = UIView(frame: CGRect(x: (btnWidth - lineWidth)/2, y: 38, width: lineWidth, height: 2))
        pageLine.backgroundColor = colorWithRGB(r: 247, g: 54, b: 87)
        scrollView.addSubview(pageLine)
        
        if !hasLine {
            pageLine.isHidden = true
        }
    }
    
    @objc private func buttonAction(_ button: UIButton) {
        for btn in buttons {
            if btn.tag == button.tag {
                btn.isSelected = true
            }else {
                btn.isSelected = false
            }
        }
        
        UIView.animate(withDuration: 0.15) {
            self.pageLine.zl_left = button.zl_centerX - self.lineWidth/2
        }
        
        itemClickBlock?(button.tag)
        animateToMiddle(button)
    }
    
    private func animateToMiddle(_ button: UIButton) {
        var offsetX: CGFloat = 0
        
        if button.frame.origin.x <= frame.size.width / 2 {
            offsetX = 0
        } else if button.frame.maxX >= (scrollView.contentSize.width - frame.size.width / 2) {
            offsetX = scrollView.contentSize.width - frame.size.width
        } else {
            offsetX = button.frame.minX - (frame.size.width - button.frame.size.width) / 2
        }
        
        scrollView.setContentOffset(CGPoint(x: offsetX, y: 0), animated: true)
    }
}
