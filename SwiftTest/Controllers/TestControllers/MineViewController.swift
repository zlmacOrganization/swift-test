//
//  MineViewController.swift
//  SwiftTest
//
//  Created by ZhangLiang on 2020/6/24.
//  Copyright © 2020 ZhangLiang. All rights reserved.
//

import UIKit

class MineViewController: UIViewController {
    
    private var topBgView: UIView!
    private var topLabelView: LeftRightLabelView!
    private var topBehandView: UIView!
    
    private var tableView: UITableView!
    private var actionFloatView: ZLActionFloatView!
    private var datas: [String] = []

    private var canScroll: Bool = true
    private var isLoadMore: Bool = false
    
    private let headerHeight: CGFloat = 160
    private var startY: CGFloat = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        
        for i in 0...19 {
            datas.append("item\(i)")
        }

        configureTopView()
        configureTableView()
        addFloatView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
            super.viewWillDisappear(animated)
            
//            actionFloatView.hide(true)
            
    //        if #available(iOS 11.0, *) {
    //            self.navigationController?.navigationBar.prefersLargeTitles = false;
    //        }
    }
    
    //MARK: -
    
    private func configureTableView() {
        let viewTop: CGFloat = 0
        tableView = UITableView(frame: CGRect(x: 0, y: viewTop, width: kMainScreenWidth, height: kMainScreenHeight - kNaviBarHeight - viewTop - kTabbarHeight), style: .plain)
        tableView.contentInset = UIEdgeInsets(top: 40, left: 0, bottom: 0, right: 0)
        tableView.backgroundColor = UIColor.clear
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 50
        tableView.zl_registerCell(UITableViewCell.self)
        tableView.tableFooterView = UIView()
        
        view.addSubview(tableView)
        
//        tableView.snp.makeConstraints { (make) in
//            make.edges.equalTo(view)
//        }
        
//        tableView.scrollDragBlock = { [weak self] in
//            self?.canScroll = true
//            self?.tableView.canScroll = false
//        }
        
        let leftItem = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(leftButtonClick))
        navigationItem.leftBarButtonItem = leftItem
        
        let rightItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(rightButtonClick))
        navigationItem.rightBarButtonItem = rightItem
    }
    
    private func configureTopView() {
        topBgView = UIView(frame: CGRect(x: 0, y: 0, width: kMainScreenWidth, height: headerHeight))
//        CommonFunction.addPanGesture(with: topBgView, target: self, action: #selector(panGesture(_:)))
        view.addSubview(topBgView)
        
        topLabelView = LeftRightLabelView()
        topLabelView.frame = CGRect(x: 0, y: 0, width: kMainScreenWidth, height: 40)
        topLabelView.leftLabel.text = "18000"
        topLabelView.rightLabel.text = "-66.70"
        topBgView.addSubview(topLabelView)
        
        topBehandView = UIView(frame: CGRect(x: 0, y: topLabelView.zl_bottom, width: kMainScreenWidth, height: 120))
        topBehandView.backgroundColor = UIColor.white
        topBgView.addSubview(topBehandView)
        
        let titles = ["余额", "余额宝", "理财", "基金", "黄金"]
        let rights = ["8.30", "1122.40", "14000", "738.2", "0.80"]
        let viewWidth = kMainScreenWidth/2, height: CGFloat = 40
        
        for (i, str) in titles.enumerated() {
            let labelView = LeftRightLabelView()
            labelView.leftLabel.text = str
            labelView.rightLabel.text = rights[i]
            topBehandView.addSubview(labelView)
            
            let row = CGFloat(i/2), col = CGFloat(i%2)
            
            labelView.snp.makeConstraints { (make) in
                make.top.equalTo(row * height)
                make.left.equalTo(col * viewWidth)
                make.size.equalTo(CGSize(width: viewWidth, height: height))
            }
        }
    }
    
    private func addFloatView() {
//        actionFloatView = ZLActionFloatView()
//        actionFloatView.delegate = self
//        actionFloatView.hide(true)
//        view.addSubview(actionFloatView)
//        actionFloatView.snp.makeConstraints { (make) -> Void in
//            make.edges.equalTo(UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
//        }
    }
    
    @objc private func leftButtonClick() {
        let arVC = ARTestController()
        zl_pushViewController(arVC)
    }

    @objc private func rightButtonClick() {
//        actionFloatView.hide(!actionFloatView.isHidden)
        let mineVC = OtherViewController()
        zl_pushViewController(mineVC)
    }
    
    //MARK: - gesture
    @objc private func panGesture(_ gesture: UIPanGestureRecognizer) {
                let point = gesture.translation(in: view)
                print("point: \(point)")
                
                if gesture.state == .began {
                    startY = (gesture.view?.frame.origin.y)!
                }else if gesture.state == .changed {
                    
//                    var frame = gesture.view?.frame
//                    frame!.origin.y = startY + point.y
//
//                    if frame!.origin.y < kNavBarAndStatusBarHeight {
//                        frame!.origin.y = kNavBarAndStatusBarHeight
//                    }
//
//                    if frame!.maxY > kMainScreenHeight - kNavBarAndStatusBarHeight {
//                        frame!.origin.y = kMainScreenHeight - kNavBarAndStatusBarHeight - 200
//                    }
//
//                    gesture.view?.frame = frame!
                    
                }else if gesture.state == .ended {
                    let velocityY = gesture.velocity(in: view).y
                    print("velocityY: \(velocityY)")
                    
                    if velocityY < 0 {//向上
//                        UIView.animate(withDuration: 0.3) {
//                            var frame = gesture.view?.frame
//                            frame?.origin.y = kNavBarAndStatusBarHeight
//                            gesture.view?.frame = frame!
//                        }
                    }else {//向下
//                        UIView.animate(withDuration: 0.3) {
//                            var frame = gesture.view?.frame
//                            frame?.origin.y = kMainScreenHeight - kNavBarAndStatusBarHeight - 200
//                            gesture.view?.frame = frame!
//                        }
                    }
                }
            }
}

extension MineViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.zl_dequeueReusableCell(UITableViewCell.self, indexPath: indexPath)
        cell.textLabel?.text = datas[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.row == 0 || indexPath.row == 1 {
            if #available(iOS 13.0, *) {
                let collectionVC = CompositionCollectionController()
                zl_pushViewController(collectionVC)
            }
            
        }else if indexPath.row == 2 || indexPath.row == 3 {
            let textureVC = TextureViewController()
            zl_pushViewController(textureVC)
        }else {
            let ratioVC = RatioViewController()
            zl_pushViewController(ratioVC)
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if isLoadMore {
            return
        }
        
        let count = datas.count
        if indexPath.row >= count - 2 && count < 100 {
            isLoadMore = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                for i in 0...9 {
                    self.datas.append("item\(count + i)")
                    self.tableView.reloadData()
                }
                self.isLoadMore = false
            }
        }
    }
}

extension MineViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
//        let tableOffsetY = tableView.contentOffset.y
////        print("tableView offsetY: \(tableOffsetY)")
//        print("offsetY: \(offsetY)")
        
        if offsetY < -headerHeight {
            topBgView.zl_top = abs(offsetY) - headerHeight
        }else if offsetY > -40 {
            let topY = -(offsetY + 40)
            topLabelView.zl_top = topY
        }else if offsetY <= -40 {
            topLabelView.zl_top = 0
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let offsetY = scrollView.contentOffset.y
        if offsetY < -100 {
            tableView.contentOffset = CGPoint(x: 0, y: -headerHeight)
            tableView.contentInset = UIEdgeInsets(top: headerHeight, left: 0, bottom: 0, right: 0)
        }else {
            tableView.contentInset = UIEdgeInsets(top: 40, left: 0, bottom: 0, right: 0)
        }
    }
    
    private func setTableViewHeight(_ viewTop: CGFloat) {
        tableView.zl_top = viewTop
        tableView.zl_height = kMainScreenHeight - kNaviBarHeight - viewTop - kTabbarHeight
    }
    
    private func setScrollEnable(_ enable: Bool) {
        tableView.isScrollEnabled = !enable
    }
}

extension MineViewController: ActionFloatViewDelegate {
    func floatViewTapItemIndex(_ type: ActionFloatViewItemType) {
        print("tap item \(type)")
    }
}
