//
//  ShopCarViewController.swift
//  SupvpSwift
//
//  Created by bfgjs on 2019/5/24.
//  Copyright © 2019 bfgjs. All rights reserved.
//

import UIKit
import Alamofire
import VisionKit
import NaturalLanguage
import SwiftPullToRefresh

class TeamViewController: UIViewController {
    
    private let headerFooterIdentifier = "headerFooterIdentifier"
    private var westData: [NBATeamModel] = [NBATeamModel]()
    private var eastData: [NBATeamModel] = [NBATeamModel]()
//    private var carouselView: ZLCarouselView!
    
    private var rightButton: UIButton!
    
    private lazy var tableView: UITableView = {
        let listTableView = UITableView()
        listTableView.delegate = self
        listTableView.dataSource = self
        if #available(iOS 15.0, *) {
            listTableView.sectionHeaderTopPadding = 0
        }
        listTableView.estimatedRowHeight = 80
        listTableView.rowHeight = UITableView.automaticDimension
        listTableView.zl_registerCell(TeamInfoTableCell.self)
        listTableView.zl_registerHeaderFooterView(SCHeaderFooterView.self, identifier: headerFooterIdentifier)
        
        return listTableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "NBA"
        view.backgroundColor = UIColor.white
        
        navigationItem.leftBarButtonItem = CommonFunction.createBarButtonItem(title: "Left", target: self, action: #selector(leftButtonClick))
        
        navigationItem.rightBarButtonItem = CommonFunction.createBarButtonItem(title: "Edit", target: self, action: #selector(rightButtonClick))
        
//        rightButton = CommonFunction.createButton(frame: CGRect(x: 0, y: 0, width: 60, height: 40), title: "Edit", textColor: UIColor.darkGray, font: UIFont.systemFont(ofSize: 16), imageName: nil, isBackgroundImage: false, target: self, action: #selector(rightButtonClick))
//        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightButton)
        
        configureViews()
        pullRefresh()
        requestData()
    }
    
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//        carouselView.startTimer()
//    }
//
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(animated)
//
//        carouselView.stopTimer()
//    }
    
    private func configureViews() {
        let bottomView = ShopcartBottomView()
        view.addSubview(bottomView)
        
        bottomView.snp.makeConstraints { (make) in
            make.bottom.equalTo(-kTabbarHeight)
            make.left.right.equalTo(0)
            make.height.equalTo(50)
        }
        
        let scanButton = CommonFunction.createButton(frame: CGRect(x: 70, y: 0, width: 60, height: 40), title: "Scan", textColor: UIColor.black, font: UIFont.systemFont(ofSize: 15), target: self, action: #selector(scanClick))
        bottomView.addSubview(scanButton)
        
        view.addSubview(tableView)
//        carouselView = ZLCarouselView(frame: CGRect(x: 0, y: 0, width: kMainScreenWidth, height: 40), datas: ["JAY ZHOU", "范特西", "八度空间", "叶惠美", "七里香", "十一月的肖邦", "依然范特西", "牛仔很忙"])
//        view.addSubview(carouselView)
        
        tableView.snp.makeConstraints { (make) in
//            make.top.equalTo(carouselView.zl_height)
            make.left.right.top.equalTo(0)
            make.bottom.equalTo(bottomView.snp.top)
        }
    }
    
    private func pullRefresh() {
//        tableView.addFCXHeaderRefresh(handler: { [weak self] (refreshHeader) in
//            self?.requestData()
//        })
        
        tableView.spr_setTextHeader { [weak self] in
            self?.requestData()
        }

//        tableView.spr_setTextFooter { [weak self] in
//            self?.requestData()
//        }
    }

    private func requestData() {
        self.pleaseWait()
        
        CommonNetRequest.new_get(urlString: "https://sportsnba.qq.com/team/list", parammeters: nil) { jsonDict, error  in
            self.clearAllNotice()
            self.tableView.spr_endRefreshing()
            
            if let jsonDict = jsonDict, let model = TeamListModel.deserialize(from: jsonDict), let data = model.data {
                self.westData = data.west
                self.eastData = data.east
            }
            
            CommonFunction.setupNoDataView(tableView: self.tableView, array: self.westData)
            self.tableView.reloadData()
        }
    }
    
    //MARK: - action
    @objc private func leftButtonClick() {
        let pageContentVC = SegmentViewController()
        zl_pushViewController(pageContentVC)
    }
    
    @objc private func rightButtonClick() {
        let filterVC = FilterViewController()
        zl_pushViewController(filterVC)
    }
    
    @objc private func scanClick() {
        if #available(iOS 13.0, *) {
            if VNDocumentCameraViewController.isSupported {
                let cameraVC = VNDocumentCameraViewController()
                cameraVC.delegate = self
                present(cameraVC, animated: true, completion: nil)
            }else {
                self.showNoticeOnlyText("不支持操作")
            }
        }
    }
}

extension TeamViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return westData.count
        }else {
            return eastData.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.zl_dequeueReusableCell(TeamInfoTableCell.self, indexPath: indexPath)
        
        if indexPath.section == 0 {
            cell.teamInfoModel = westData[indexPath.row]
        }else {
            cell.teamInfoModel = eastData[indexPath.row]
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        var urlString = ""
        var nameString = ""
        
        if indexPath.section == 0 {
            let model = westData[indexPath.row]
            urlString = model.detailUrl
            nameString = model.teamName
        }else {
            let model = eastData[indexPath.row]
            urlString = model.detailUrl
            nameString = model.teamName
        }
        
        let webVC = ZLWebViewController()
        webVC.titleName = nameString
        webVC.zlUrlString = urlString
        webVC.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(webVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = tableView.zl_dequeueHeaderFooterView(SCHeaderFooterView.self, identifier: headerFooterIdentifier)
        if section == 0 {
            headerView.textLabel?.text = "West"
        }else {
            headerView.textLabel?.text = "East"
        }
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if westData.isEmpty {
            return CGFloat.Magnitude.leastNormalMagnitude
        }
        return 50
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
}

@available(iOS 13.0, *)
extension TeamViewController: VNDocumentCameraViewControllerDelegate {
    func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFinishWith scan: VNDocumentCameraScan) {
        let image = scan.imageOfPage(at: 0)
        ZFPrint("image.size: \(image.size)")
        controller.dismiss(animated: true, completion: nil)
    }
    
    func documentCameraViewControllerDidCancel(_ controller: VNDocumentCameraViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFailWithError error: Error) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    func wordTokenizer(_ text: String) {
        let stopWords: [String: Any] = [:]
        let tokenizer = NLTokenizer(unit: .word) // 分词器操作的粒度级别
        tokenizer.setLanguage(.simplifiedChinese) // 设置要分词的文本的语言
        tokenizer.string = text
        var tokenResult = [String]()
        
        tokenizer.enumerateTokens(in: text.startIndex..<text.endIndex) { tokenRange, attribute in
          let str = String(text[tokenRange])
          if attribute != .numeric, stopWords[str] == nil, str.count > 1 {
                    tokenResult.append(str)
          }
          return true
        }
        
        //        if #available(iOS 15.0, *) {
        //            let num = 3.14159
        //            num.formatted() //1,234
        //            let never = num.formatted(.number.grouping(.never)) //1234
        //
        //            //指定小数点位数
        //            let format = num.formatted(.number.precision(.fractionLength(2)))
        //            num.formatted(.percent) //32.3%
        //            num.formatted(.currency(code: "JPY"))
        //            num.formatted(.number.rounded(rule: .down, increment: 0.1)) //3.1
        //        }
    }
}
