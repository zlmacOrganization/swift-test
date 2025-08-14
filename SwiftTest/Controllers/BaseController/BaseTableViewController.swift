//
//  BaseTableViewController.swift
//  SwiftTest
//
//  Created by lezhi on 2018/6/22.
//  Copyright © 2018年 ZhangLiang. All rights reserved.
//

import UIKit

class BaseTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.leftBarButtonItem = CommonFunction.createBarButtonItem(imageName: "left_back", tintColor: UIColor.white, target: self, action: #selector(baseTableBackButtonClick))
//        navigationController?.navigationBar.barTintColor = NewBgColor
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(false, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }

    
    @objc func baseTableBackButtonClick() {
        navigationController?.popViewController(animated: true)
    }
}
