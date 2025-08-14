//
//  ListViewController.swift
//  SwiftTest
//
//  Created by ZhangLiang on 17/1/10.
//  Copyright © 2017年 ZhangLiang. All rights reserved.
//

import UIKit
import Alamofire
//import ReactiveSwift
//import ReactiveCocoa
//import SwiftProgressHUD
import HandyJSON
//import SwiftyJSON

struct MyFansModel: Decodable, Equatable {//HandyJSON
    var userPhoneNum: String?
    var userHeadImg: String?
    var userNickName: String?
    var slogan: String?
}

class ListViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource, ActionFloatViewDelegate {
    
    var listTableView: UITableView?
//    var dataArray = [Any]()
    var fansList = [MyFansModel]()
    var totalNum: Int?
    var rightButton: UIButton!
    
    var actionFloatView: ZLActionFloatView!
    private var navbarView: BaseNavBarView!
    private var selectIndexPath: IndexPath?
    
    private var headImageView: UIImageView!
    private let imageHeight: CGFloat = 280

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        self.title = "List"
        view.backgroundColor = NormalBgColor
        totalNum = 0
        
        rightButton = CommonFunction.createButton(frame: CGRect(x: 0, y: 0, width: 65, height: 40), title: "Edit", textColor: UIColor.red, font: UIFont.systemFont(ofSize: 16), imageName: nil, isBackgroundImage: false, target: self, action: #selector(ListViewController.rightButtonClick))
        rightButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -20)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightButton)
        
//        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.add, target: self, action: #selector(ListViewController.rightButtonClick))

        listTableView = UITableView(frame: CGRect(x: 0, y: 0, width: kMainScreenWidth, height: kMainScreenHeight - iphoneXBottomMargin))
        if let theTableView = listTableView {
            theTableView.register(ListTableViewCell.classForCoder(), forCellReuseIdentifier: "listCell")
            theTableView.delegate = self
            theTableView.dataSource = self
            theTableView.allowsMultipleSelectionDuringEditing = true
            theTableView.separatorStyle = UITableViewCell.SeparatorStyle.none
            view.addSubview(theTableView)
        }
        
//        configureFloatView()
        setupHeaderView()
//        setupNavbarView()
//        pullRefresh()
        dataRequest()
        
//        for i in 0...9 {
//            var model = MyFansModel()
//            model.userNickName = "item: \(i)"
//            fansList.append(model)
//        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navTranslucent = true
//        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        navTranslucent = false
        
//        self.actionFloatView.hide(true)
    }
    
    private func configureFloatView() {
        self.actionFloatView = ZLActionFloatView()
        self.actionFloatView.delegate = self
        self.view.addSubview(self.actionFloatView)
        self.actionFloatView.snp.makeConstraints { (make) -> Void in
            make.edges.equalTo(UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
        }
    }
    
    private func setupNavbarView() {
        navbarView = BaseNavBarView(frame: CGRect(x: 0, y: 0, width: kMainScreenWidth, height: kNavBarAndStatusBarHeight))
        navbarView.backgroundColor = UIColor.white
        view.addSubview(navbarView)
    }
    
    private func setupHeaderView() {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: kMainScreenWidth, height: imageHeight))
        
        headImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: kMainScreenWidth, height: imageHeight))
        headImageView.image = UIImage(named: "image4")
        headImageView.contentMode = .scaleAspectFill
        headImageView.clipsToBounds = true
        
        headerView.addSubview(headImageView)
        
        listTableView?.tableHeaderView = headerView
        
        
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: kMainScreenWidth, height: 400))
        listTableView?.tableFooterView = footerView
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    private func pullRefresh() {
        listTableView?.addFCXHeaderRefresh(handler: { [weak self] (refreshHeader) in
            self?.dataRequest()
        })
//        listTableView?.addFCXFooterRefresh(handler: { [weak self] (footer) in
//            self?.dataRequest()
//        })
    }
    
    @objc private func rightButtonClick() {
        rightButton.isSelected.toggle()
//
//        if rightButton.isSelected {
//            rightButton.setTitle("Cancel", for: .normal)
//        }else {
//            rightButton.setTitle("Edit", for: .normal)
//        }
        
//        self.listTableView?.isEditing = rightButton.isSelected
//        self.actionFloatView.hide(!self.actionFloatView.isHidden)
        
        let menuView = ZFMoreMenuListView()
        menuView.showOnRelyView(relyView: rightButton, relyVC: self, menusType: .DefaultThreeItemType)
    }
    
    // MARK: - data request
    private func dataRequest() {
        let param: Parameters = ["userPhoneNum": "15926395764", "method": "fans", "debug": "1"]
        
//        SwiftProgressHUD.showWait()
        
        CommonNetRequest.get(urlString: CommonRequestUrl + "FocusOperateServlet", parammeters: param, success: { (codeOK, codeString, jsonDict) in
            self.listTableView?.headerEndRefreshing()
            
            if codeString == "" {
                if let focusList = jsonDict["focusList"] as? Array<Any> {
//                    self.fansList = [MyFansModel].deserialize(from: focusList)! as! [MyFansModel]
                    if let list = CommonFunction.decodeModel(model: [MyFansModel].self, object: focusList) {
                        self.fansList = list
                    }
                }
                
                self.listTableView?.reloadData()
            }
        }, failure: {error in
            self.listTableView?.headerEndRefreshing()
        })
    }
    
    // MARK: - ActionFloatViewDelegate
    func floatViewTapItemIndex(_ type: ActionFloatViewItemType) {
        print("tap item \(type)")
    }
    
    // MARK: - UITableViewDelegate, UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fansList.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.zl_dequeueReusableCell(ListTableViewCell.self, identifier: "listCell", indexPath: indexPath)
        cell.selectionStyle = .none
        let model = fansList[indexPath.row]
        
        if #available(iOS 14.0, *) {
            if selectIndexPath == indexPath {
                var model = fansList[indexPath.row]
                model.slogan = "no slogan"
                
                cell.updateModel(model)
                NotificationCenter.default.post(name: Notification.Name("changeModel"), object: model)
            }else {
                var config = UserListCellConfiguration()
                config.model = model
                cell.contentConfiguration = config
            }
        } else {
            cell.setCell(model)
        }
        
        return cell
    }

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    //去除编辑模式下的头部缩进
//    func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
//        return false
//    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let model = fansList[sourceIndexPath.row]
        fansList.remove(at: sourceIndexPath.row)
        fansList.insert(model, at: destinationIndexPath.row)
        
//        listTableView?.beginUpdates()
//        listTableView?.endUpdates()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
//        if tableView.isEditing {
//
//        }else {
//            tableView.deselectRow(at: indexPath, animated: true)
//        }
        
//        let searchVC = SearchTableViewController()
//        navigationController?.pushViewController(searchVC, animated: true)
        selectIndexPath = indexPath
        tableView.reloadData()
    }
    
}

extension ListViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        if offsetY < 0 {
            headImageView.frame = CGRect(x: 0, y: offsetY, width: kMainScreenWidth, height: imageHeight + abs(offsetY))
        }
        
        
//        let minOffset: CGFloat = 0
        let maxOffset: CGFloat = 64
//        let alpha = (offsetY - minOffset)/(maxOffset - minOffset)
        let alpha = 1 - (maxOffset - offsetY)/maxOffset
        
        if #available(iOS 15.0, *) {
            
        }else {
            navigationController?.navigationBar.shadowImage = UIImage()
            
            navigationController?.navigationBar.setBackgroundImage(UIColor.white.withAlphaComponent(alpha).getPureImage(), for: .default)
        }
        
        if alpha < 1 {
            setNavigationBar(UIColor.clear)
            leftImageName = "nav_back_white"
        }else {
            setNavigationBar(UIColor.white)
            leftImageName = "left_back"
        }
    }
}
