//
//  TeamInfoTableCell.swift
//  SupvpSwift
//
//  Created by bfgjs on 2019/6/6.
//  Copyright © 2019 bfgjs. All rights reserved.
//

import UIKit
import HandyJSON

struct TeamListModel: HandyJSON {
    init() {
        
    }
    
    var data: TeamDataModel?
    var version: String = ""
    var code: Int = -1
}

struct TeamDataModel: HandyJSON {
    init() {
        
    }
    
    var west: [NBATeamModel] = []
    var east: [NBATeamModel] = []
}

struct NBATeamModel: HandyJSON {
    init() {
        
    }
    
    var teamName: String = ""
    var fullCnName: String = ""
    var city: String = ""
    var detailUrl: String = ""
    var logo: String = ""
}

class TeamInfoTableCell: UITableViewCell {
    
    private var logoImageView: UIImageView!
    private var nameLabel: UILabel!
    private var introLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configureViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var teamInfoModel: NBATeamModel? {
        didSet {
            if let model = teamInfoModel {
                logoImageView.kf.setImage(with: URL(string: model.logo), placeholder: nil, options: [.transition(.fade(1))], progressBlock: nil, completionHandler: nil)
                nameLabel.text = model.teamName
                introLabel.text = model.fullCnName
            }
        }
    }
    
    private func configureViews() {
        logoImageView = UIImageView()
//        logoImageView.image = UIImage(named: "man")
        logoImageView.contentMode = .scaleAspectFit
        contentView.addSubview(logoImageView)
        
        nameLabel = CommonFunction.createLabel(font: UIFont.systemFont(ofSize: 15), text: "", textColor: UIColor.darkGray, textAlignment: .left)
        contentView.addSubview(nameLabel)
        
        introLabel = CommonFunction.createLabel(font: UIFont.systemFont(ofSize: 13), text: "", textColor: UIColor.lightGray, textAlignment: .left)
        contentView.addSubview(introLabel)
        
        makeViewConstraints()
    }
    
    private func makeViewConstraints() {
        logoImageView.snp.makeConstraints { (make) in
            make.width.height.equalTo(55)
            make.left.equalTo(18)
            make.centerY.equalTo(contentView)
        }
        
        nameLabel.snp.makeConstraints { (make) in
            make.top.equalTo(10)
            make.left.equalTo(logoImageView.snp.right).offset(10)
        }
        
        introLabel.snp.makeConstraints { (make) in
            make.top.equalTo(nameLabel.snp.bottom).offset(6)
            make.left.equalTo(nameLabel.snp.left)
            make.right.equalTo(-8)
        }
    }
}
