//
//  ZLCarouselView.swift
//  SwiftTest
//
//  Created by zhangliang on 2022/7/20.
//  Copyright © 2022 zhangliang. All rights reserved.
//

import UIKit

class ZLCarouselView: UIView {
    private var currentIndex = 0
    private var datas: [String] = []
    private var duration: Int
    private var subtype: CATransitionSubtype
    private var label: UILabel!
    var clickBlock: Delegate<String, Void>?
    
    var timer: DispatchSourceTimer?
    
    init(frame: CGRect, datas: [String], duration: Int = 3, subtype: CATransitionSubtype = .fromTop) {
        self.datas = datas
        self.duration = duration
        self.subtype = subtype
        super.init(frame: frame)
        
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        label = CommonFunction.createLabel(font: UIFont.systemFont(ofSize: 14), text: datas[safe: currentIndex] ?? "", textColor: UIColor.darkGray, textAlignment: .left)
        label.addTapGesture(target: self, action: #selector(clickAction))
        addSubview(label)
        
        label.snp.makeConstraints { make in
            make.left.equalTo(20)
            make.centerY.equalToSuperview()
        }
    }
    
    private func next() {
        currentIndex = (currentIndex + 1) % datas.count
        let transition = CATransition()
        transition.duration = CFTimeInterval(0.5)
        transition.type = .push
        transition.subtype = subtype
        
        label.text = datas[safe: currentIndex]
        label.layer.add(transition, forKey: "cube")
    }
    
    @objc private func clickAction() {
        clickBlock?.call(datas[safe: currentIndex] ?? "")
    }
    
    func startTimer() {
        stopTimer()
        timer = CommonFunction.createGCDTimer(interval: .seconds(duration)) {
            self.next()
        }
        timer?.resume()
    }
    
    func stopTimer() {
        if timer != nil {
            timer?.cancel()
            timer = nil
        }
    }
}
