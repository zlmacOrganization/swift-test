//
//  TestReusableView.swift
//  SwiftTest
//
//  Created by ZhangLiang on 2019/11/10.
//  Copyright © 2019 ZhangLiang. All rights reserved.
//

import UIKit

protocol SectionBgCollectionViewDelegate: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    backgroundColorForSectionAt section: Int) -> UIColor
    
    func collectionView(_ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    cornerRadiusForSectionAt section: Int) -> CGFloat
}


class TestReusableView: UICollectionReusableView {
        
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        super.apply(layoutAttributes)
        
        guard let attribute = layoutAttributes as? SectionBgAttributes else {
            return
        }
         
        if attribute.backgroundColor != nil {
            self.backgroundColor = attribute.backgroundColor
        }
        
        if attribute.cornerRadius > 0 {
            layer.cornerRadius = attribute.cornerRadius
            clipsToBounds = true
        }
    }
}

private class SectionBgAttributes: UICollectionViewLayoutAttributes {
//    var backgroundColor = UIColor.white
    
//    override func copy(with zone: NSZone? = nil) -> Any {
//        let copy = super.copy(with: zone) as! SectionBgAttributes
//        copy.backgroundColor = backgroundColor
//        return copy
//    }
//
//    override class func isEqual(_ object: Any?) -> Bool {
//        guard let rhs = object as? SectionBgAttributes else {
//            return false
//        }
//
//        if !self.isEqual(rhs.backgroundColor) {
//            return false
//        }
//
//
//        return super.isEqual(object)
//    }
    
    /// 添加组背景
    var backgroundColor: UIColor?
    /// 添加组圆角
    var cornerRadius: CGFloat = 0
}

class SectionBgFlowLayout: UICollectionViewFlowLayout {
    
    private var attributes = [UICollectionViewLayoutAttributes]()
    private let decorationKind = "TestReusableView"
    
    override init() {
        super.init()
        
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        register(TestReusableView.self, forDecorationViewOfKind: decorationKind)
    }
    
    override func prepare() {
        super.prepare()
        
        guard let numberOfSections = self.collectionView?.numberOfSections,
            let delegate = self.collectionView?.delegate
                as? SectionBgCollectionViewDelegate
            else {
                return
        }
         
        //先删除原来的section背景的布局属性
        attributes.removeAll()
        
        //分别计算每个section背景的布局属性
        for section in 0..<numberOfSections {
            //获取该section下第一个，以及最后一个item的布局属性
            guard let numberOfItems = self.collectionView?.numberOfItems(inSection:
                section),
                numberOfItems > 0,
                let firstItem = self.layoutAttributesForItem(at:
                    IndexPath(item: 0, section: section)),
                let lastItem = self.layoutAttributesForItem(at:
                    IndexPath(item: numberOfItems - 1, section: section))
                else {
                    continue
            }
             
            //获取该section的内边距
            var sectionInset = self.sectionInset
            
            if let collection = collectionView {
                if let inset = delegate.collectionView?(collection, layout: self, insetForSectionAt: section) {
                    sectionInset = inset
                }
            }
             
            //计算得到该section实际的位置
            var sectionFrame = firstItem.frame.union(lastItem.frame)
            sectionFrame.origin.x = 0
            sectionFrame.origin.y -= sectionInset.top
             
            //计算得到该section实际的尺寸
            if self.scrollDirection == .horizontal {
                sectionFrame.size.width += sectionInset.left + sectionInset.right
                sectionFrame.size.height = self.collectionView!.frame.height
            } else {
                sectionFrame.size.width = self.collectionView!.frame.width
                sectionFrame.size.height += sectionInset.top + sectionInset.bottom
            }
             
            //更具上面的结果计算section背景的布局属性
            let attr = SectionBgAttributes(
                forDecorationViewOfKind: decorationKind,
                with: IndexPath(item: 0, section: section))
            attr.frame = sectionFrame
            attr.zIndex = -1
            //通过代理方法获取该section背景使用的颜色
            attr.backgroundColor = delegate.collectionView(self.collectionView!,
                           layout: self, backgroundColorForSectionAt: section)
            
            attr.cornerRadius = delegate.collectionView(self.collectionView!, layout: self, cornerRadiusForSectionAt: section)
             
            //将该section背景的布局属性保存起来
            attributes.append(attr)
        }
    }
    
    //返回rect范围下所有元素的布局属性（这里我们将自定义的section背景视图的布局属性也一起返回）
    override func layoutAttributesForElements(in rect: CGRect)
        -> [UICollectionViewLayoutAttributes]? {
        var attrs = super.layoutAttributesForElements(in: rect)
        attrs?.append(contentsOf: attributes.filter {
            return rect.intersects($0.frame)
        })
        return attrs
    }
    
    //返回对应于indexPath的位置的Decoration视图的布局属性
    override func layoutAttributesForDecorationView(ofKind elementKind: String,
                at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        //如果是我们自定义的Decoration视图（section背景），则返回它的布局属性
        if elementKind == decorationKind {
            return attributes[indexPath.section]
        }
        return super.layoutAttributesForDecorationView(ofKind: elementKind,
                                                       at: indexPath)
    }
}
