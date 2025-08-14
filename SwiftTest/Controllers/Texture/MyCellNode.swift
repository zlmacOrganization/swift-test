//
//  MyCellNode.swift
//  SwiftTest
//
//  Created by ZhangLiang on 2020/7/10.
//  Copyright © 2020 ZhangLiang. All rights reserved.
//

import UIKit
import SwiftyJSON
//import AsyncDisplayKit

class MyCellNode {//ASCellNode
    
//    private var imageNode: ASNetworkImageNode!
//    private var nameLabel: ASTextNode!
//    private var addressLabel: ASTextNode!
//    private var badgeNode: ASTextNode!
    private var infoModel: SecreListModel?
    
//    init(_ model: NBATeamModel) {
//        super.init()
//
//        imageNode = ASNetworkImageNode()
//        imageNode.url = URL(string: model.logo)
//
//        badgeNode = ASTextNode()
//        badgeNode.tintColor = UIColor.white
//        badgeNode.backgroundColor = UIColor.red
//        badgeNode.attributedText = NSAttributedString(string: "3")
//
//        badgeNode.cornerRadius = 9
//        badgeNode.cornerRoundingType = .defaultSlowCALayer
//
//        nameLabel = ASTextNode()
//        nameLabel.attributedText = NSAttributedString(string: model.teamName)
//
//        addressLabel = ASTextNode()
//        addressLabel.attributedText = NSAttributedString(string: model.fullCnName)
//
//        automaticallyManagesSubnodes = true
//    }
//
//    init(jsonDict: [String: JSON]?) {
//        super.init()
//
//        imageNode = ASNetworkImageNode()
//        imageNode.url = URL(string: jsonDict?["userHeadimg"]?.string ?? "")
//
//        badgeNode = ASTextNode()
//        badgeNode.truncationMode = .byTruncatingTail
//        badgeNode.backgroundColor = UIColor.red
//
////        badgeNode.style.width = ASDimensionMake(18)
////        badgeNode.style.height = ASDimensionMake(18)
//        badgeNode.cornerRadius = 9
//        badgeNode.cornerRoundingType = .clipping
//
//        let dict = [NSAttributedString.Key.foregroundColor: UIColor.white]
//        let attributeString = NSMutableAttributedString(string: "3", attributes: dict)
//        badgeNode.attributedText = attributeString
//
//        nameLabel = ASTextNode()
//        nameLabel.attributedText = NSAttributedString(string: jsonDict?["userNickName"]?.string ?? "")
//
//        addressLabel = ASTextNode()
//        addressLabel.attributedText = NSAttributedString(string: jsonDict?["address"]?.string ?? "")
//
//        automaticallyManagesSubnodes = true
//    }
    
//    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
//        return avatarAndNameLayout(constrainedSize)
//    }
    
//    private func avatarAndNameLayout(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
//        let stackLayout = ASStackLayoutSpec()
//        stackLayout.direction = .horizontal
//
////        nameLabel.style.flexShrink = 1.0
////        addressLabel.style.flexShrink = 1.0
//
//        let leftLabelStack = ASStackLayoutSpec.vertical()
//        leftLabelStack.spacing = 8
//        leftLabelStack.children = [nameLabel, addressLabel]
//
//
////        badgeNode.style.preferredSize = CGSize(width: 18, height: 18)
////        badgeNode.cornerRadius = 9
////        badgeNode.style.width = ASDimensionMake(18)
////        badgeNode.style.height = ASDimensionMake(18)
////        badgeNode.cornerRadius = 9
//
////        let labelInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 15)
//        let rightSpec = ASInsetLayoutSpec(insets: UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 20), child: badgeNode)
//
//
//        let spacer = ASLayoutSpec()
//        spacer.style.flexGrow = 1.0
//
//        let avatarInset = UIEdgeInsets(top: 10, left: 5, bottom: 10, right: 20)
//        let insetSpec = ASInsetLayoutSpec(insets: avatarInset, child: imageNode)
//        imageNode.style.preferredSize = CGSize(width: 50, height: 50)
////        badgeNode.style.preferredSize = CGSize(width: 15, height: 15)
//
////        let cornerSpec = ASCornerLayoutSpec(child: imageNode, corner: badgeNode, location: .topRight)
//
//        let topStack = ASStackLayoutSpec.horizontal()
//        topStack.alignItems = .center
//        topStack.justifyContent = .start
//        topStack.children = [insetSpec, leftLabelStack, rightSpec]
//
//        let layoutSpec = ASInsetLayoutSpec(insets: UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8), child: topStack)
//
//        return layoutSpec
//    }
}
