//
//  ResultsViewController.swift
//  SwiftTest
//
//  Created by bfgjs on 2020/1/3.
//  Copyright © 2020 ZhangLiang. All rights reserved.
//

import UIKit

class ResultsViewController: UITableViewController {
    
    var resultDatas: [SearchModel] = []
    var keyword: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.backgroundColor = UIColor.white
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "searchResultCell")
    }

}

// MARK: - Table view data source
extension ResultsViewController {

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return resultDatas.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "searchResultCell", for: indexPath)
//        cell.textLabel?.text = resultDatas[indexPath.row].title
        
        cell.textLabel?.getSearchAttribute(keyword: keyword, lightString: resultDatas[indexPath.row].title, textColor: UIColor.red)
        
        return cell
    }
}
