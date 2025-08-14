//
//  MyTestViewController.swift
//  Exercise
//
//  Created by ZhangLiang on 2017/7/5.
//  Copyright © 2017年 ZhangLiang. All rights reserved.
//

import UIKit
import Alamofire
//import PromiseKit
import SwiftPullToRefresh
//import AXPhotoViewer

class MyPostViewController: BaseViewController {
    
    static private let cellIdentifier = "emotionCell"
    var testName: String = ""
    
    var dataArray = [DynamicModel]()
    var startRow = 0
    var previewingContext: UIViewControllerPreviewing?
    
    private lazy var tableView: UITableView = {
        let myTableView = UITableView()
        myTableView.delegate = self
        myTableView.dataSource = self
        myTableView.register(EmotionTableViewCell.classForCoder(), forCellReuseIdentifier: MyPostViewController.cellIdentifier)
        myTableView.estimatedRowHeight = 120
        myTableView.rowHeight = UITableView.automaticDimension
        myTableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        return myTableView
    }()
    
//    init(name: String) {
//        self.init()
//
//        self.testName = name
//    }
    
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
    
    convenience init(text: String){
        self.init()
        
        self.testName = text
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.white;
        self.title = "MyTest"
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.bottom.equalTo(view.snp.bottom).offset(-iphoneXBottomMargin)
        }
//        tableView.addFCXFooterRefresh { [weak self] (footerView) in
//            self?.startRow = self?.dataArray.count ?? 0
//            self?.secretDataRequest()
//        }
        
        pullRefresh()
        
        secretDataRequest()
        lemonNetRequest()
    }
    
    deinit {
        print("MyTestViewController deinit ++++")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func pullRefresh() {
        tableView.spr_setTextHeader { [weak self] in
            self?.startRow = self?.dataArray.count ?? 0
            self?.secretDataRequest()
        }
        
        tableView.spr_setTextFooter { [weak self] in
            self?.startRow = self?.dataArray.count ?? 0
            self?.secretDataRequest()
        }
    }
    
    //MARK: -
    private func secretDataRequest() {
        self.pleaseWait()
        
        let params: Parameters = ["userPhoneNum": "15926395764", "targetPhoneNum": "15926395764", "startRow": startRow, "debug": "1"]
        CommonNetRequest.new_get(urlString: CommonRequestUrl + "GetSecretByUserServlet", parammeters: params) { jsonDict, error in
            self.clearAllNotice()
//            self.tableView.footerEndRefresh()
            self.tableView.spr_endRefreshing()
//            self.tableView.spr_endRefreshingWithNoMoreData()
            
            if let jsonDict = jsonDict {
                let code = jsonDict["error"] as? String ?? "e"
                if code == "" {
                    if let secrets = jsonDict["secrets"] as? Array<Any> {
                        let array = [DynamicModel].deserialize(from: secrets) as! [DynamicModel]
                        if self.startRow == 0 {
                            self.dataArray = array
                            self.tableView.reloadData()
                        }else {
                            if array.count > 0 {
                                for model in array {
                                    self.dataArray.append(model)
                                }
                                self.tableView.reloadData()
                            }else {
                                //                                    self.tableView.footer?.state = .noMoreData
                            }
                        }
                    }
                }
            }else {
                self.noticeOnlyText("\(error?.localizedDescription ?? "error")")
            }
        }
    }
    
    func lemonNetRequest() {
        let parameters : Parameters = ["userPhoneNum": "12312341234", "debug": "1"]
        
        CommonNetRequest.new_get(urlString: CommonRequestUrl + "GetPromoServlet", parammeters: parameters) { dict, error in
            if let dict = dict {
                let dataDict = dict["promo"] as! Dictionary<String, Any>
                
                if let model = CommonFunction.decodeModel(model: PromoModel.self, object: dataDict) {
                    print("解析成功:\(model.url1)")
                }
            }else {
                print("request error: \(error?.localizedDescription ?? "")")
            }
        }
        
//        let url = URL(string: "http://ningmengxinli.com/GetPromoServlet?userPhoneNum=12312341234&debug=1")
        
    }
    
    func beiguaNetRequest(key: String) {
        let parameters : Parameters = ["telNum": "15926395764", "token": "Lezhi123456"]
        let requestData = try! JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
        let stringEncode = CFStringConvertEncodingToNSStringEncoding(CFStringEncoding(CFStringEncodings.GB_18030_2000.rawValue))
        let jsonString = String.init(format: "%@=%@", key, String(data: requestData, encoding: String.Encoding(rawValue: stringEncode))!)
//        let headers = ["Authorization": jsonString]
        
        var request = URLRequest(url: URL(string: "http://121.42.56.153:9097/dataflow/api/System_getSystemParams.do")!)
        request.httpMethod = "POST"
        request.httpBody = jsonString.data(using: String.Encoding(rawValue: stringEncode), allowLossyConversion: true)
        request.setValue(String(format: "%lu", jsonString.count), forHTTPHeaderField: "Content-Length")
        
        AF.request(request).responseData(queue: DispatchQueue.main) { (response: DataResponse) in
            switch response.result{
                
            case .success(let data):
                
                print("response.response = \(String(describing: response.response))") // HTTP URL response
                print("response.data = \(String(describing: response.data))")     // server data
                print("response.value = \(String(describing: response.value))")
                
                let resStr = String(data: data, encoding: String.Encoding(rawValue: stringEncode))
                if let jsonDict = try? JSONSerialization.jsonObject(with: (resStr?.data(using: .utf8, allowLossyConversion: true))!, options: .mutableLeaves) as? Dictionary<String, Any> {
                    
                    if let dict = jsonDict["sysParams"] as? Dictionary<String, Any> {
                        print("SHARE_EXTERNAL_URL_TITLE: \(dict["SHARE_EXTERNAL_URL_TITLE"] ?? "")")
                    }
                    
                    print("jsonDict = \(String(describing: jsonDict))")
                }
                
            case .failure(let error):
                print("request error: \(error)")
            }
        }
    }
}

extension MyPostViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MyPostViewController.cellIdentifier, for: indexPath) as! EmotionTableViewCell
        let model = dataArray[indexPath.row]
        cell.model = model
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        
//        cell.imageClickClosure = {(clickImageView, model) in
//            
//        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let userInfo = UserInfo.queryInfo() {
            print("userInfo: \(userInfo.name)")
            userInfo.deleteData()
        }else {
            let user = UserInfo("1123", "zhang")
            user.saveData()
        }
    }
}

struct PromoModel: Decodable {
    let url1: String
    let url2: String
    let url3: String?
    let useTimes: String
    let addTime1: String
    
    enum CodingKeys: String, CodingKey {
        case url1
        case url2
        case url3
        case useTimes = "useTimes1"
        case addTime1
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        url1 = try container.decode(String.self, forKey: .url1)
        url2 = try container.decode(String.self, forKey: .url2)
        addTime1 = try container.decode(String.self, forKey: .addTime1)
        
        do {
            url3 = try container.decodeIfPresent(String.self, forKey: .url3) ?? ""
        } catch DecodingError.keyNotFound {
            url3 = nil
        }
        
        if let value = try? container.decode(Int.self, forKey: .useTimes) {
            useTimes = String(value)
        } else {
            useTimes = try container.decode(String.self, forKey: .useTimes)
        }
    }
}
