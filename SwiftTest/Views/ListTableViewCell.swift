//
//  ListTableViewCell.swift
//  SwiftTest
//
//  Created by ZhangLiang on 17/1/10.
//  Copyright © 2017年 ZhangLiang. All rights reserved.
//

import UIKit
import Kingfisher
//import SwiftyJSON

class ListTableViewCell: UITableViewCell {
    private var headerImage: UIImageView?
    private var nameLabel: UILabel?
    private var sloganLabel: UILabel?
    private var signImage: UIImageView?
    
//    var model: MyFansModel! {
//        didSet {
//
//        }
//    }

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
        
        if #available(iOS 14.0, *) {
            
        }else {
            setupViews()
        }
    }
    
    //iOS 14设置圆角
    @available(iOS 14.0, *)
    override func updateConfiguration(using state: UICellConfigurationState) {
//        var configuration = UIBackgroundConfiguration.listPlainCell()
//        configuration.backgroundColor = UIColor.lightGray
//        configuration.cornerRadius = 10
//        backgroundConfiguration = configuration
        
//        var content = UserListCellConfiguration().updated(for: state)
//        content.model = model
//        contentConfiguration = content
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateModel(_ newModel: MyFansModel) {
        if #available(iOS 14.0, *) {
            var config = contentConfiguration as? UserListCellConfiguration
            if config?.model == newModel {
                contentConfiguration = config
            }else {
                config?.model = newModel
                contentConfiguration = config
                setNeedsUpdateConfiguration()
            }
        }
    }
    
    private func setupViews() {
        let imageWidth = 44 as CGFloat
        
        headerImage = UIImageView(frame: CGRect(x: 8, y: 8, width: imageWidth, height: imageWidth))
//        headerImage?.layer.cornerRadius = imageWidth/2
//        headerImage?.layer.masksToBounds = true
//        headerImage?.layer.shouldRasterize = true
//        headerImage?.layer.rasterizationScale = layer.contentsScale
        self.contentView.addSubview(headerImage!)
        
        nameLabel = CommonFunction.createLabel(frame: CGRect(x: (headerImage?.frame.origin.x)! + imageWidth + 8, y: 10, width: 100, height: 18), text: "NickName", font: UIFont.systemFont(ofSize: 15), textColor: UIColor.darkGray.withAlphaComponent(0.7), textAlignment: .left)
//        nameLabel?.layer.shouldRasterize = true
        self.contentView.addSubview(nameLabel!)
        
        sloganLabel = CommonFunction.createLabel(frame: CGRect(x: (headerImage?.frame.origin.x)! + imageWidth + 8, y: (nameLabel?.frame.origin.y)! + 18 + 4, width: 200, height: 17), text: "slogan none", font: UIFont.systemFont(ofSize: 14), textColor: UIColor.lightGray, textAlignment: .left)
        self.contentView.addSubview(sloganLabel!)
        
//        signImage = UIImageView(frame: CGRect(x: kMainScreenWidth - 30, y: self.contentView.frame.size.height - 25, width: 20, height: 20))
//        signImage?.image = UIImage(named: "radio_nomal")
//        self.contentView.addSubview(signImage!)
    }
}

extension ListTableViewCell: CellDataProtocol {
    typealias DataType = MyFansModel
    func setCell(_ model: DataType) {
        let processor = RoundCornerImageProcessor(cornerRadius: 22)
        headerImage?.kf.setImage(with: URL(string: model.userHeadImg ?? ""), placeholder: UIImage(named: "man"), options: [.transition(ImageTransition.fade(1)), .processor(processor)], progressBlock: nil, completionHandler: nil)
        
        nameLabel?.text = model.userNickName ?? ""
        sloganLabel?.text = model.slogan ?? ""
    }
}

@available(iOS 14.0, *)
struct UserListCellConfiguration: UIContentConfiguration {
    var model: MyFansModel?
    
    func makeContentView() -> UIView & UIContentView {
        return ListContentView(config: self)
    }
    
    func updated(for state: UIConfigurationState) -> UserListCellConfiguration {
        return self
    }
    
}

@available(iOS 14.0, *)
class ListContentView: UIView, UIContentView {
    private var headerImage: UIImageView!
    private var nameLabel: UILabel!
    private var sloganLabel: UILabel!
    
    var configuration: UIContentConfiguration {
        didSet {
            configData()
        }
    }
    
    init(config: UIContentConfiguration) {
        self.configuration = config
        super.init(frame: .zero)
        
        let imageWidth: CGFloat = 44
        headerImage = UIImageView(frame: CGRect(x: 8, y: 10, width: imageWidth, height: imageWidth))
        
        nameLabel = CommonFunction.createLabel(frame: CGRect(x: headerImage.frame.origin.x + imageWidth + 8, y: 13, width: 100, height: 18), text: "NickName", font: UIFont.systemFont(ofSize: 15), textColor: UIColor.darkGray.withAlphaComponent(0.7), textAlignment: .left)
        
        sloganLabel = CommonFunction.createLabel(font: UIFont.systemFont(ofSize: 13), text: "", textColor: UIColor.lightGray, textAlignment: .left)
        
        addSubview(headerImage)
        addSubview(nameLabel)
        addSubview(sloganLabel)
        
        sloganLabel.snp.makeConstraints { make in
            make.left.equalTo(nameLabel)
            make.top.equalTo(nameLabel.snp.bottom).offset(4)
            make.right.equalTo(-4)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configData() {
        guard let config = self.configuration as? UserListCellConfiguration else { return }
        
        let processor = RoundCornerImageProcessor(cornerRadius: 22)
        headerImage.kf.setImage(with: URL(string: config.model?.userHeadImg ?? ""), placeholder: UIImage(named: "man"), options: [.transition(ImageTransition.fade(1)), .processor(processor)], progressBlock: nil, completionHandler: nil)
        
        nameLabel.text = config.model?.userNickName
        sloganLabel.text = config.model?.slogan
    }
}
