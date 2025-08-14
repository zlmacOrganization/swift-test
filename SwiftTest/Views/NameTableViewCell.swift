//
//  NameTableViewCell.swift
//  Exercise
//
//  Created by ZhangLiang on 2017/9/3.
//  Copyright © 2017年 ZhangLiang. All rights reserved.
//

import UIKit

class NameTableViewCell: UITableViewCell {
    
    enum Position {
        case solo
        case first
        case middle
        case last
    }
    var position: Position = .middle
    
    var nameLabel = UILabel()
    var secondLabel = UILabel()

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
        
        self.configureViews()
        contentView.backgroundColor = UIColor.white
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //section圆角
    override func layoutSubviews() {
        super.layoutSubviews()
        
        frame = CGRect(x: 20, y: frame.minY, width: superview!.frame.width - 40, height: frame.height)
        setCorners()
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
//    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
//        return true
//    }

    //MARK: -
    private func configureViews() {
        nameLabel.frame = CGRect(x: 15, y: (50 - 18)/2, width: 70, height: 18)
        nameLabel.font = UIFont.systemFont(ofSize: 16)
        nameLabel.textColor = UIColor.red
        self.contentView.addSubview(nameLabel)
        
        secondLabel.frame = CGRect(x: nameLabel.frame.maxX + 10, y: (50 - 18)/2, width: 100, height: 18)
        secondLabel.font = UIFont.systemFont(ofSize: 14)
        secondLabel.textColor = UIColor.darkGray
        self.contentView.addSubview(secondLabel)
    }
    
    private func setCorners() {
        let cornerRadius: CGFloat = 11.0
        switch position {
            case .solo: roundCorners(corners: .allCorners, radius: cornerRadius)
            case .first: roundCorners(corners: [.topLeft, .topRight], radius: cornerRadius)
            case .last: roundCorners(corners: [.bottomLeft, .bottomRight], radius: cornerRadius)
            default: noCornerMask()
        }
    }
    
    private func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.shadowRadius = 8
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.05).cgColor
        layer.mask = mask
    }
    
    private func noCornerMask() {
        layer.mask = nil
    }

}
