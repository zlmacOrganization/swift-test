//
//  SegmentViewController.swift
//  SwiftTest
//
//  Created by ZhangLiang on 2020/8/3.
//  Copyright © 2020 ZhangLiang. All rights reserved.
//

import UIKit
import JXPagingView
import JXSegmentedView

class SegmentViewController: BaseViewController {
    
    private lazy var pagingView: JXPagingSmoothView = JXPagingSmoothView(dataSource: self)
    private lazy var userHeaderView: UIImageView = preferredTableHeaderView()
    private let dataSource: JXSegmentedTitleDataSource = JXSegmentedTitleDataSource()
    private lazy var segmentedView: JXSegmentedView = JXSegmentedView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: CGFloat(headerInSectionHeight)))
    private var titles = ["first", "second", "third", "fourth"]
    private var tableHeaderViewHeight: Int = 200
    private var headerInSectionHeight: Int = 45
    private var isNeedHeader = false
    private var isNeedFooter = false

    override func viewDidLoad() {
        super.viewDidLoad()

        setupSegmentView()
    }
    
    private func setupSegmentView() {
        dataSource.titles = titles
        dataSource.titleSelectedColor = UIColor(red: 105/255, green: 144/255, blue: 239/255, alpha: 1)
        dataSource.titleNormalColor = UIColor.black
        dataSource.isTitleColorGradientEnabled = true
        dataSource.isTitleZoomEnabled = true

        segmentedView.backgroundColor = UIColor.white
        segmentedView.delegate = self
        segmentedView.isContentScrollViewClickTransitionAnimationEnabled = false
        segmentedView.dataSource = dataSource

        let lineView = JXSegmentedIndicatorLineView()
        lineView.indicatorColor = UIColor(red: 105/255, green: 144/255, blue: 239/255, alpha: 1)
        lineView.indicatorWidth = 30
        lineView.verticalOffset = 5
        segmentedView.indicators = [lineView]

//        let lineWidth = 1/UIScreen.main.scale
//        let bottomLineView = UIView()
//        bottomLineView.backgroundColor = UIColor.lightGray
//        bottomLineView.frame = CGRect(x: 0, y: segmentedView.bounds.height - lineWidth, width: segmentedView.bounds.width, height: lineWidth)
//        bottomLineView.autoresizingMask = .flexibleWidth
//        segmentedView.addSubview(bottomLineView)

//        pagingView.mainTableView.gestureDelegate = self
        self.view.addSubview(pagingView)
        
        segmentedView.contentScrollView = pagingView.listCollectionView

        //扣边返回处理，下面的代码要加上
        pagingView.listCollectionView.panGestureRecognizer.require(toFail: self.navigationController!.interactivePopGestureRecognizer!)
//        pagingView.mainTableView.panGestureRecognizer.require(toFail: self.navigationController!.interactivePopGestureRecognizer!)
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        pagingView.frame = self.view.bounds
    }

    func preferredTableHeaderView() -> UIImageView {
        return UIImageView(image: UIImage(named: "image4"))
    }
}

extension SegmentViewController: JXPagingSmoothViewDataSource {

    func heightForPagingHeader(in pagingView: JXPagingSmoothView) -> CGFloat {
        return CGFloat(tableHeaderViewHeight)
    }

    func viewForPagingHeader(in pagingView: JXPagingSmoothView) -> UIView {
        return userHeaderView
    }

    func heightForPinHeader(in pagingView: JXPagingSmoothView) -> CGFloat {
        return CGFloat(headerInSectionHeight)
    }

    func viewForPinHeader(in pagingView: JXPagingSmoothView) -> UIView {
        return segmentedView
    }

    func numberOfLists(in pagingView: JXPagingSmoothView) -> Int {
        return titles.count
    }

    func pagingView(_ pagingView: JXPagingSmoothView, initListAtIndex index: Int) -> JXPagingSmoothViewListViewDelegate {
        let list = NameTableViewController(style: .grouped)
        return list
    }
}

extension SegmentViewController: JXSegmentedViewDelegate {
    func segmentedView(_ segmentedView: JXSegmentedView, didSelectedItemAt index: Int) {
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = (index == 0)
    }
}

extension SegmentViewController: JXPagingMainTableViewGestureDelegate {
    func mainTableViewGestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        //禁止segmentedView左右滑动的时候，上下和左右都可以滚动
        if otherGestureRecognizer == segmentedView.collectionView.panGestureRecognizer {
            return false
        }
        return gestureRecognizer.isKind(of: UIPanGestureRecognizer.self) && otherGestureRecognizer.isKind(of: UIPanGestureRecognizer.self)
    }
}
