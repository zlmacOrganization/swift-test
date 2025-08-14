//
//  DragTableViewCell.swift
//  SwiftTest
//
//  Created by ZhangLiang on 2017/12/17.
//  Copyright © 2017年 ZhangLiang. All rights reserved.
//

import UIKit

class DragTableViewCell: UITableViewCell {
    
    var targetImageView: UIImageView?

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
    
    func configureViews() {
        let margin = 20 as CGFloat
        self.targetImageView = UIImageView(frame: CGRect(x: margin, y: margin, width: kMainScreenWidth-2*margin, height: drapTableHeight-2*margin))
        self.contentView.addSubview(self.targetImageView!)
    }
    
}
