//
//  SCHeaderFooterView.swift
//  SupvpSwift
//
//  Created by bfgjs on 2019/6/6.
//  Copyright © 2019 bfgjs. All rights reserved.
//

import UIKit

class SCHeaderFooterView: UITableViewHeaderFooterView {
    
    private var titleLabel: UILabel!
    private var introLabel: UILabel!

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        configureViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureViews() {
        titleLabel = CommonFunction.createLabel(font: UIFont.systemFont(ofSize: 15), text: "", textColor: UIColor.darkGray, textAlignment: .left)
        contentView.addSubview(titleLabel)

        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(8)
//            make.centerX.equalTo(contentView.snp.centerX)
            make.top.equalTo(10)
        }

        introLabel = CommonFunction.createLabel(font: UIFont.systemFont(ofSize: 15), text: "", textColor: UIColor.darkGray, textAlignment: .left)
        introLabel.numberOfLines = 0
//        introLabel.text = "NBA NBA NBA NBA NBA NBA NBA NBA NBA NBA NBA NBA NBA NBA"
        contentView.addSubview(introLabel)

        introLabel.snp.makeConstraints { (make) in
            make.left.equalTo(8)
            make.right.equalTo(-8)
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
        }
    }
    
    var headerFooterModel: NBATeamModel? {
        didSet {
//            if let model = headerFooterModel {
//                titleLabel.text = model.name
//            }
        }
    }
}
