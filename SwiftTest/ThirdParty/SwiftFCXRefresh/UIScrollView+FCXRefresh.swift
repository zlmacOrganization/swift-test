//
//  UIScrollView+FCXRefresh.swift
//  FCXRefresh
//
//  Created by 冯 传祥 on 2017/6/19.
//  Copyright © 2017年 冯 传祥. All rights reserved.
//

import UIKit

extension UIScrollView {
    private struct AssociatedKey {
        static var headerKey = "fcx_headerKey"
        static var footerKey = "fcx_footerKey"
    }
    
    var header: FCXRefreshHeaderView? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKey.headerKey) as? FCXRefreshHeaderView
        }
        
        set {
            if let value = newValue {
                objc_setAssociatedObject(self, &AssociatedKey.headerKey, value, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            }
        }
    }
    
    var footer: FCXRefreshFooterView? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKey.footerKey) as? FCXRefreshFooterView
        }
        
        set {
            if let value = newValue {
                objc_setAssociatedObject(self, &AssociatedKey.footerKey, value, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            }
        }
    }
    
    func addFCXHeaderRefresh(handler: @escaping (FCXRefreshBaseView) -> Void) {
        if self.header == nil {
            self.header = FCXRefreshHeaderView.init(frame: CGRect.init(x: 0, y: -60, width: kMainScreenWidth, height: 60), hangingHeight: 60, refreshType: .header, refreshHandler: handler)
            self.addSubview(self.header!)
        }
    }
    
    func addFCXFooterRefresh(handler: @escaping (FCXRefreshBaseView) -> Void) {
        if self.footer == nil {
            self.footer = FCXRefreshFooterView.init(frame: CGRect.init(x: 0, y: -60, width: kMainScreenWidth, height: 60), hangingHeight: 60, refreshType: .footer, refreshHandler: handler)
            self.addSubview(self.footer!)
        }
    }
    
    func headerEndRefreshing() {
        self.header?.endRefresh()
    }
    
    func footerEndRefresh() {
        self.footer?.endRefresh()
    }
    
    func endRefreshing() {
        self.header?.endRefresh()
        self.footer?.endRefresh()
    }
    
    //MARK: - origin
//    @discardableResult
//    open func addFCXRefreshHeader(handler: @escaping (FCXRefreshBaseView) -> Void) -> FCXRefreshHeaderView {
//        let refreshHeaderView = FCXRefreshHeaderView.init(frame: CGRect.init(x: 0, y: -60, width: self.frame.size.width, height: 60), hangingHeight: 60, refreshType: .header, refreshHandler: handler)
//        self.addSubview(refreshHeaderView)
//        return refreshHeaderView;
//    }
//    
//    @discardableResult
//    open func addFCXRefreshFooter(handler: @escaping (FCXRefreshBaseView) -> Void) -> FCXRefreshFooterView {
//        let refreshFooterView = FCXRefreshFooterView.init(frame: CGRect.init(x: 0, y: 0, width: self.frame.size.width, height: 60), hangingHeight: 60, refreshType: .footer, refreshHandler: handler)
//        self.addSubview(refreshFooterView)
//        return refreshFooterView;
//    }
//    
//    @discardableResult
//    open func addFCXRefreshAutoFooter(handler: @escaping (FCXRefreshBaseView) -> Void) -> FCXRefreshFooterView {
//        let refreshView = FCXRefreshFooterView.init(frame: CGRect.init(x: 0, y: 0, width: self.frame.size.width, height: 60), hangingHeight: 60, refreshType: .autoFooter, refreshHandler: handler)
//        self.addSubview(refreshView)
//        return refreshView;
//    }
}
