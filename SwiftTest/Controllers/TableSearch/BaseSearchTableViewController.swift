//
//  BaseSearchTableViewController.swift
//  SwiftTest
//
//  Created by bfgjs on 2020/1/3.
//  Copyright © 2020 ZhangLiang. All rights reserved.
//

import UIKit

class BaseSearchTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.white
    }
}

class SearchModel: NSObject, NSCoding {
    @objc let title: String
    
    private enum CoderKeys: String {
        case nameKey
        case yearKey
        case priceKey
    }
    
    init(title: String) {
        self.title = title
    }
    
    func encode(with coder: NSCoder) {
        coder.encode(title, forKey: CoderKeys.nameKey.rawValue)
    }
    
    required init?(coder: NSCoder) {
        guard let decodedTitle = coder.decodeObject(forKey: CoderKeys.nameKey.rawValue) as? String else {
            fatalError("A title did not exist. In your app, handle this gracefully.")
        }
        
        title = decodedTitle
    }
    
}
