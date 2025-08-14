//
//  ScaleCollectionCell.swift
//  SwiftTest
//
//  Created by zhangliang on 2021/4/28.
//  Copyright © 2021 zhangliang. All rights reserved.
//

import UIKit

class ScaleCollectionCell: UICollectionViewCell {
    private var zlImageView: UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureViews() {
        zlImageView = UIImageView()
        zlImageView.layer.cornerRadius = 30
        zlImageView.clipsToBounds = true
        contentView.addSubview(zlImageView)
        
        zlImageView.snp.makeConstraints { (make) in
            make.width.height.equalTo(60)
            make.center.equalToSuperview()
        }
    }
    
    func setImageName(_ name: String) {
        zlImageView.image = UIImage(named: name)
    }
    
    func setupImage(_ image: UIImage) {
        zlImageView.image = image.resizeIamge_render(targetSize: CGSize(width: 80, height: 80))
    }
}

class ScaleCollectionLayout: UICollectionViewFlowLayout {
    var isZoom: Bool = false
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let attributes = super.layoutAttributesForElements(in: rect) ?? []
        if !self.isZoom {
            return attributes
        }
        
        let centerX = collectionView!.contentOffset.x + collectionView!.bounds.width / 2
        attributes.forEach({ (attr) in
            // 获取每个 cell 的中心点，并计算这俩个中心点的偏移值
            let pad = abs(centerX - attr.center.x)
            
            // 如何计算缩放比?我的思路是，距离越小，缩放比越小，缩放比最大是1，当俩个中心点的 x 坐标重合的时候，缩放比就为 1.
            
            // 缩放因子
            let factor = 0.0015
            // 计算缩放比
            let scale = 1 / (1 + pad * CGFloat(factor))
            attr.transform = CGAffineTransform(scaleX: scale, y: scale)
        })
        
        return attributes
    }
    
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
            var targetPoint = proposedContentOffset
            // 1.计算中心点的 x 值
            let centerX = proposedContentOffset.x + collectionView!.bounds.width / 2
            // 2.获取这个点可视范围内的布局属性
            let attrs = self.layoutAttributesForElements(in: CGRect(x: proposedContentOffset.x, y: proposedContentOffset.y, width: collectionView!.bounds.size.width, height: collectionView!.bounds.size.height))
            
            // 3. 需要移动的最小距离
            var moveDistance: CGFloat = CGFloat(MAXFLOAT)
            // 4.遍历数组找出最小距离
            attrs!.forEach { (attr) in
                if abs(attr.center.x - centerX) < abs(moveDistance) {
                    moveDistance = attr.center.x - centerX
                }
            }
            // 5.返回一个新的偏移点
            if targetPoint.x > 0 && targetPoint.x < collectionViewContentSize.width - collectionView!.bounds.width {
                targetPoint.x += moveDistance
            }
            
            return targetPoint
        }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
}
