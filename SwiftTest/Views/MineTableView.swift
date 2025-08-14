//
//  MineTableView.swift
//  SwiftTest
//
//  Created by ZhangLiang on 2020/8/13.
//  Copyright © 2020 ZhangLiang. All rights reserved.
//

import UIKit

class MineTableView: UITableView {
    var canScroll: Bool = false
    var currentOffsetY: CGFloat = 0
    var scrollDragBlock: (() -> Void)?
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        self.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension MineTableView: UITableViewDelegate, UIScrollViewDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        currentOffsetY = scrollView.contentOffset.y
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        let tableOffsetY = scrollView.contentOffset.y
        
//        if !canScroll {
//            scrollView.contentOffset = CGPoint(x: 0, y: tableOffsetY == 0 ? 0 : -currentOffsetY)
//        }
        
//        currentOffsetY = tableOffsetY
//        print("tableView offsetY: \(tableOffsetY)")
        
//        if tableOffsetY < -160 {
//            canScroll = false
//            scrollView.contentOffset = CGPoint.zero
//
//            scrollDragBlock?()
//        }
    }
}

extension MineTableView: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
