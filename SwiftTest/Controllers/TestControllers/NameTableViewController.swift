//
//  NameTableViewController.swift
//  Exercise
//
//  Created by ZhangLiang on 2017/9/3.
//  Copyright © 2017年 ZhangLiang. All rights reserved.
//

import UIKit
import FSPagerView
import JXPagingView

class NameTableViewController: UITableViewController {
    private var isHidden = true
    private var imageUrls: [Dictionary<String, String>] = [[:]]
    private var pagerView: FSPagerView!
    private var pageControl: FSPageControl!
    var myHeaderView: HeaderView?
    var changeString = "origin string"
    
    override init(style: UITableView.Style) {
        super.init(style: .grouped)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.backgroundColor = NormalBgColor
        tableView.separatorStyle = .none
        self.tableView.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
        self.tableView.register(NameTableViewCell.classForCoder(), forCellReuseIdentifier: "myCell")
        
        setupTableHeaderView()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        NotificationCenter.default.post(name: .bannerViewDidDisappear, object: nil)
    }
    
    deinit {
        print("NameTableViewController deinit ++++")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupTableHeaderView() {
        
        self.pagerView = FSPagerView(frame: CGRect(x: 0, y: 0, width: kMainScreenWidth, height: 180))
        self.pagerView.backgroundColor = UIColor.white
        self.pagerView.delegate = self
        self.pagerView.dataSource = self
        self.pagerView.isInfinite = true
        self.pagerView.interitemSpacing = 10
        self.pagerView.itemSize = CGSize(width: kMainScreenWidth - 20, height: 180)
        self.pagerView.register(FSPagerViewCell.self, forCellWithReuseIdentifier: "FSPagerViewCell")
        
        self.pageControl = FSPageControl(frame: CGRect(x: (kMainScreenWidth - 60)/2, y: 165, width: 60, height: 10))
        self.pagerView.addSubview(self.pageControl)
        
        imageUrls = [["imageUrl":"http://ningmengxinli.com/files//Promo/promo20170120155554931.png"], ["imageUrl":"http://ningmengxinli.com/files//Promo/promo20170121154219230.jpg"], ["imageUrl":"http://ningmengxinli.com/files//Promo/promo20170121154232160.jpg"]]
        pageControl.numberOfPages = imageUrls.count
        
        self.pagerView.reloadData()
        self.tableView.tableHeaderView = self.pagerView
    }
    
    // MARK: - action
    func headButtonClickAction() {
        
    }
    
    @objc private func copyItemAction() {
        debugPrint("copy ++++")
    }
    
    @objc private func deleteItemAction() {
        debugPrint("delete ++++")
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section + 1
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath) as! NameTableViewCell
        cell.nameLabel.text = String(format: "name-%zd", indexPath.row)
        cell.secondLabel.text = String(format: "second-%zd", indexPath.row)
        cell.selectionStyle = .none
        
        if indexPath.section == 0 {
            cell.position = .solo
        } else if indexPath.row == 0 {
            cell.position = .first
        } else if (indexPath.row == indexPath.section) {
            cell.position = .last
        } else {
            cell.position = .middle
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) else { return }
        let showRect = CGRect(x: cell.zl_centerX - 50, y: cell.zl_top + cell.zl_height/2, width: 100, height: cell.zl_height)
        
        let menuVC = UIMenuController.shared
        
        if menuVC.isMenuVisible {
//            menuVC.setMenuVisible(false, animated: true)
            menuVC.showMenu(from: tableView, rect: showRect)
        }else {
            let copyItem = UIMenuItem(title: "copy", action: #selector(copyItemAction))
            let deleteItem = UIMenuItem(title: "delete", action: #selector(deleteItemAction))
            menuVC.menuItems = [copyItem, deleteItem]
            
            cell.becomeFirstResponder()
            
//            menuVC.setTargetRect(showRect, in: cell.contentView)
            menuVC.showMenu(from: tableView, rect: showRect)
        }
    }

//    override func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
//        let cell = tableView.cellForRow(at: indexPath)
//
//        UIView.beginAnimations(nil, context: nil)
//        UIView.setAnimationDuration(0.2)
//        cell?.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
//
//        UIView.commitAnimations()
//    }
//
//    override func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
//        let cell = tableView.cellForRow(at: indexPath)
//
//        UIView.beginAnimations(nil, context: nil)
//        UIView.setAnimationDuration(0.2)
//        cell?.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
//
//        UIView.commitAnimations()
//    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 10
        }
        return 0.01
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10
    }
}

extension NameTableViewController : FSPagerViewDelegate, FSPagerViewDataSource {
    func numberOfItems(in pagerView: FSPagerView) -> Int {
        imageUrls.count
    }
    
    func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        let cell = pagerView.dequeueReusableCell(withReuseIdentifier: "FSPagerViewCell", at: index)
        
        let dict = imageUrls[index]
        cell.imageView?.kf.setImage(with: URL(string: dict["imageUrl"]!))
        
        return cell
    }
    
    func pagerView(_ pagerView: FSPagerView, didSelectItemAt index: Int) {
        let webVC = ZLWebViewController()
//        webVC.zlUrlString = "https://www.baidu.com"
//        webVC.zlUrlString = "http://h5.supvp.com/supvp/supvp/goodsDetail?id=250"
        webVC.zlUrlString = "https://www.wanandroid.com/blog/show/2"
        navigationController?.pushViewController(webVC, animated: true)
    }
    
    func pagerViewWillEndDragging(_ pagerView: FSPagerView, targetIndex: Int) {
        self.pageControl.currentPage = targetIndex
    }
    
    func pagerViewDidEndScrollAnimation(_ pagerView: FSPagerView) {
        self.pageControl.currentPage = pagerView.currentIndex
    }
}

extension NameTableViewController: JXPagingSmoothViewListViewDelegate {
    func listView() -> UIView {
        return view
    }

    func listScrollView() -> UIScrollView {
        return tableView
    }
}
