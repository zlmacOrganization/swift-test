//
//  TextureViewController.swift
//  SwiftTest
//
//  Created by ZhangLiang on 2020/7/10.
//  Copyright © 2020 ZhangLiang. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
//import AsyncDisplayKit

class TextureViewController: BaseViewController {
    
//    private var tableNode: ASTableNode!
    private var datas: [SecreListModel] = []
    private var responseJson: JSON = JSON.null
    
    private var westData: [NBATeamModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureTable()
        requestData()
    }
    
    private func configureTable() {
//        tableNode = ASTableNode()
//        tableNode.backgroundColor = UIColor.white
//        tableNode.delegate = self
//        tableNode.dataSource = self
//        tableNode.frame = view.bounds
//        tableNode.view.separatorStyle = .none
//        view.addSubnode(tableNode)
        
//        tableNode.view.spr_setTextHeader {[weak self] in
//            if let self = self {
//                self.netRequest()
//            }
//        }
    }
    
    private func requestData() {
            let urlString = "https://sportsnba.qq.com/team/list"
            let param: Parameters = [:]
            
            self.pleaseWait()
            
            CommonNetRequest.get(urlString: urlString, parammeters: param, success: { (codeOK, code, jsonDict) in
                
                self.clearAllNotice()
                
                if let data = jsonDict["data"] as? Dictionary<String, Any> {
                    if let west = data["west"] as? Array<Any> {
                        self.westData = [NBATeamModel].deserialize(from: west) as! [NBATeamModel]
                    }
                    
//                    if let east = data["east"] as? Array<Any> {
//                        self.eastData = [NBATeamModel].deserialize(from: east) as! [NBATeamModel]
//                    }
                }
                
//                self.tableNode.reloadData()
            }) { (error) in
                debugPrint("shopcart error: \(error)")
                self.clearAllNotice()
            }
        }

    private func netRequest() {
        let parameters : Parameters = ["userPhoneNum": "18021401774", "debug": "1"]
        CommonNetRequest.new_get(urlString: CommonRequestUrl + "user/getHomePageInfoM", parammeters: parameters) { jsonDict, error in
            if let jsonDict = jsonDict {
                if let array = jsonDict["secreList"] as? [Dictionary<String, Any>] {
                    if let model = CommonFunction.decodeModel(model: [SecreListModel].self, object: array) {
                        self.datas = model

//                            self.tableNode.reloadData()
                    }
                }
            }else {
                print("request error: \(error?.localizedDescription ?? "")")
            }
        }
    }
}

//extension TextureViewController: ASTableDelegate, ASTableDataSource {
//    func tableNode(_ tableNode: ASTableNode, numberOfRowsInSection section: Int) -> Int {
//        return westData.count
////        return responseJson["secreList"].arrayValue.count
//    }
//
////    func tableNode(_ tableNode: ASTableNode, nodeForRowAt indexPath: IndexPath) -> ASCellNode {
////        let dict = responseJson["secreList"].arrayValue[indexPath.row].dictionary
////        let cellNode = MyCellNode(jsonDict: dict)
////        return cellNode
////    }
//
//    func tableNode(_ tableNode: ASTableNode, nodeBlockForRowAt indexPath: IndexPath) -> ASCellNodeBlock {
//        let model = westData[indexPath.row]
//
//        let nodeBlock: () -> ASCellNode = {
//            let cellNode = MyCellNode(model)
//            return cellNode
//        }
//
//        return nodeBlock
//    }
//
//    func tableNode(_ tableNode: ASTableNode, didSelectRowAt indexPath: IndexPath) {
//        tableNode.deselectRow(at: indexPath, animated: true)
//    }
//}

struct LHInfoModel: Decodable {
    var infoList: [InfoListModel] = []
    var category: String = ""
}

struct InfoListModel: Decodable {
    var title: String = ""
    var recommendTime: String = ""
    var picture: String = ""
    var category: String = ""
}

struct SecreListModel: Decodable {
    var address: String = ""
    var content: String = ""
    var userHeadimg: String = ""
    var userNickName: String = ""
}
