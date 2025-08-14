//
//  SortViewController.swift
//  SwiftTest
//
//  Created by zhangliang on 2021/3/19.
//  Copyright © 2021 zhangliang. All rights reserved.
//

import UIKit

class SortViewController: BaseViewController {
    private var tableView: UITableView!
    
    private var neighbors: [(String, [NeighborModel])] = []
    private var indexTitles: [String] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        configureViews()
        dataRequest()
    }
    
    private func configureViews() {
        tableView = UITableView(frame: .zero, style: .grouped)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 50
        tableView.sectionHeaderHeight = 30
        tableView.sectionFooterHeight = 0.01
//        if #available(iOS 15.0, *) {
//            tableView.sectionHeaderTopPadding = 0
//        }
        tableView.zl_registerCell(UITableViewCell.self)
        
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }

    private func dataRequest() {
        let url = "http://barhoppersf.com/json/neighborhoods.json"
        CommonNetRequest.get(urlString: url, parammeters: [:]) { (ok, code, dict) in
            guard let hoods = dict["hoods"] as? [String: Any] else { return }
            guard let names = hoods["neighborhoodNames"] as? [String: [AnyObject]] else { return }
            self.makeDataSource(names: names)
            
            self.tableView.reloadData()
        } failure: { (error) in
            print(error)
        }

    }
    
    private func makeDataSource(names: [String: [AnyObject]]) {
        var dict: [String: [NeighborModel]] = [:]
        
        for (_, value) in names {
            for obj in value {
                if let model = CommonFunction.decodeModel(model: NeighborModel.self, object: obj) {
                    if !(model.name.isBlank()) {
                        let key = String(model.name.first!)
                        let sortKey = isKeyCharacter(key: key, letters: CharacterSet.letters) ? key : "#"
                        if let keyValue = dict[sortKey] {
                            var filtered = keyValue
                            filtered.append(model)
//                            filtered = filtered.sorted(by: {$0.name < $1.name})
//
//                            for item in filtered {
//                                print("name: \(item.name)")
//                            }
                            dict[key] = filtered
                        }else {
                            let filtered = [model]
                            dict[key] = filtered
                        }
                    }
                }
            }
        }
//        print("keys: \(dict.keys.sorted(by: <))")
        neighbors = Array(dict).sorted(by: { $0.0 < $1.0 })
        
//        let temp = neighbors[0]
//        neighbors.removeFirst()
//        neighbors.append(temp)

        //For setting index titles
        indexTitles = Array(dict.keys.sorted(by: <))

        //Making the index title # at the bottom
//        let tempIndex = indexTitles[0]
//        indexTitles.removeFirst()
//        indexTitles.append(tempIndex)
    }
    
    func isKeyCharacter(key:String, letters:CharacterSet) -> Bool {
        let range = key.rangeOfCharacter(from: letters)
        if let _ = range {
            //Your key is an alphabet
            return true
        }
        return false
    }
}

extension SortViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return neighbors.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return neighbors[section].1.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.zl_dequeueReusableCell(UITableViewCell.self, indexPath: indexPath)
        let model = neighbors[indexPath.section].1[indexPath.row]
        cell.textLabel?.text = model.name
//        cell.leftImageView?.kf.setImage(with: URL(string: model.image))
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
//        let model = neighbors[indexPath.section].1[indexPath.row]
//        if !model.website.isEmpty {
//            let webVC = ZLWebViewController()
//            webVC.zlUrlString = model.website
//            zl_pushViewController(webVC)
//        }
    }
    
    //
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return neighbors[section].0
    }
    
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return indexTitles
    }
    
    func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
//        var tpIndex = 0
//
//        for str in indexTitles {
//            if str == title {
//                return tpIndex
//            }
//
//            tpIndex += 1
//        }
        
        let selIndex = indexTitles.firstIndex(of: title) ?? 0
        
        return selIndex
    }
}

struct NeighborModel: Decodable {
    var name: String = ""
    var description: String = ""
    var address: String = ""
    var image: String = ""
    var website: String = ""
}

class NeighborhoodCell: UITableViewCell {
    var leftImageView: UIImageView!
    var nameLabel: UILabel!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configureViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureViews() {
        leftImageView = UIImageView()
        leftImageView.layer.cornerRadius = 25
        leftImageView.clipsToBounds = true
        contentView.addSubview(leftImageView)
        
        nameLabel = CommonFunction.createLabel(font: UIFont.systemFont(ofSize: 15), text: "", textColor: UIColor.darkGray, textAlignment: .left)
        contentView.addSubview(nameLabel)
        
        leftImageView.snp.makeConstraints { (make) in
            make.left.equalTo(16)
            make.width.height.equalTo(50)
            make.centerY.equalToSuperview()
        }
        
        nameLabel.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalTo(leftImageView.snp.right).offset(20)
        }
    }
}
