//
//  ZLCollectionViewFlowLayout.swift
//  SwiftTest
//
//  Created by zhangliang on 2021/12/6.
//  Copyright © 2021 zhangliang. All rights reserved.
//

import UIKit

protocol ZLCollectionViewFlowLayoutDelegate: AnyObject {
//    func collectionView(_ collectionView: UICollectionView, sizeForItemAt indexPath: IndexPath) -> CGSize
    func collectionView(_ collectionView: UICollectionView, heightForItemAt indexPath: IndexPath) -> CGFloat
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: ZLCollectionViewFlowLayout, referenceSizeForHeaderInSection section: Int) -> CGSize
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: ZLCollectionViewFlowLayout, referenceSizeForFooterInSection section: Int) -> CGSize
}

extension ZLCollectionViewFlowLayoutDelegate {
    func collectionView(_ collectionView: UICollectionView, layout: ZLCollectionViewFlowLayout, referenceSizeForHeaderInSection: Int) -> CGSize {
        return .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout: ZLCollectionViewFlowLayout, referenceSizeForFooterInSection: Int) -> CGSize {
        return .zero
    }
}

class ZLCollectionViewFlowLayout: UICollectionViewLayout {
    private var itemSpacing: CGFloat
    private var lineSpacing: CGFloat
    private var colCount: Int
    private var sectionInset: UIEdgeInsets = .zero
    
    weak var delegate: ZLCollectionViewFlowLayoutDelegate?
    
//    private var attributes: [UICollectionViewLayoutAttributes] = []
    private var dict: [CGFloat: CGFloat] = [:]
    
    init(itemSpacing: CGFloat = 0, lineSpacing: CGFloat = 0, delegate: ZLCollectionViewFlowLayoutDelegate, colCount: Int = 2) {
        self.itemSpacing = itemSpacing
        self.lineSpacing = lineSpacing
        self.delegate = delegate
        self.colCount = colCount
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    
    override func prepare() {
        super.prepare()
    }
    
    override var collectionViewContentSize: CGSize {
        var maxCol: CGFloat = 0
        for (key, value) in dict {
            if let num = dict[maxCol], value > num {
                maxCol = key
            }
        }
        
        return CGSize(width: 0, height: dict[maxCol] ?? 0)
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var attributes = [UICollectionViewLayoutAttributes]()
        let section = collectionView?.numberOfSections ?? 0
        
        for i in 0..<colCount {
            let col = CGFloat(i)
            dict[col] = 0
        }
        
        for i in 0..<section {
            if let headerAtt = layoutAttributesForSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, at: IndexPath(item: 0, section: i)) {
                attributes.append(headerAtt)
            }
            
            let itemCount = collectionView?.numberOfItems(inSection: i) ?? 0
            for j in 0..<itemCount {
                if let att = layoutAttributesForItem(at: IndexPath(item: j, section: i)) {
                    attributes.append(att)
                }
            }
            
            if let footerAtt = layoutAttributesForSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, at: IndexPath(item: 0, section: i)) {
                attributes.append(footerAtt)
            }
        }
        
        return attributes
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let layoutAttributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
        
        guard let collectionView = collectionView else { return layoutAttributes }
        
        var minCol: CGFloat = 0
        for (key, value) in dict {
            if let num = dict[minCol], value < num {
                minCol = key
            }
        }
        
        let spacings = CGFloat(colCount - 1) * itemSpacing
        let width = (collectionView.frame.size.width - sectionInset.left - sectionInset.right - spacings)/CGFloat(colCount)
        var height: CGFloat = 0
        if let delegate = delegate {
            height = delegate.collectionView(collectionView, heightForItemAt: indexPath)
        }
        
        let x = sectionInset.left + (width + itemSpacing)*minCol
        let y = dict[minCol] ?? 0 + lineSpacing
        
        dict[minCol] = y + height + lineSpacing
        
        layoutAttributes.frame = CGRect(x: x, y: y, width: width, height: height)
        
        return layoutAttributes
    }
    
    override func layoutAttributesForDecorationView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        super.layoutAttributesForDecorationView(ofKind: elementKind, at: indexPath)
        
        var maxCol: CGFloat = 0
        for (key, value) in dict {
            if let num = dict[maxCol], value > num {
                maxCol = key
            }
        }
        
        let layoutAttributes = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: elementKind, with: indexPath)
        guard let collectionView = collectionView else { return layoutAttributes }
        
        if elementKind == UICollectionView.elementKindSectionHeader {
            let size = delegate?.collectionView(collectionView, layout: self, referenceSizeForHeaderInSection: indexPath.section) ?? .zero
            let x = sectionInset.left
            let y = dict[maxCol] ?? 0 + sectionInset.top
            
            for key in dict.keys {
                dict[key] = y + size.height
            }
            
            layoutAttributes.frame = CGRect(x: x, y: y, width: size.width, height: size.height)
            
            return layoutAttributes
        }
        
        if elementKind == UICollectionView.elementKindSectionFooter {
            let size = delegate?.collectionView(collectionView, layout: self, referenceSizeForHeaderInSection: indexPath.section) ?? .zero
            let x = sectionInset.left
            let y = dict[maxCol] ?? 0
            
            for key in dict.keys {
                dict[key] = y + size.height + sectionInset.bottom
            }
            
            layoutAttributes.frame = CGRect(x: x, y: y, width: size.width , height: size.height)
            
            return layoutAttributes
        }
        
        return layoutAttributes
    }
}

/*
 - (nullable UICollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath{
     
     __block NSString * maxCol = @"0";
     //遍历找出最高的列
     [self.colunMaxYDic enumerateKeysAndObjectsUsingBlock:^(NSString * column, NSNumber *maxY, BOOL *stop) {
         if ([maxY floatValue] > [self.colunMaxYDic[maxCol] floatValue]) {
             maxCol = column;
         }
     }];
     
     //header
     if ([UICollectionElementKindSectionHeader isEqualToString:elementKind]) {
         UICollectionViewLayoutAttributes *attri = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader withIndexPath:indexPath];
         //size
         CGSize size = CGSizeZero;
         if ([self.delegate respondsToSelector:@selector(collectionView:layout:referenceSizeForHeaderInSection:)]) {
             size = [self.delegate collectionView:self.collectionView layout:self referenceSizeForHeaderInSection:indexPath.section];
         }
         CGFloat x = self.sectionInset.left;
         CGFloat y = [[self.colunMaxYDic objectForKey:maxCol] floatValue] + self.sectionInset.top;
         
         //    跟新所有对应列的高度
         for(NSString *key in self.colunMaxYDic.allKeys)
         {
             self.colunMaxYDic[key] = @(y + size.height);
         }
         
         attri.frame = CGRectMake(x , y, size.width, size.height);
         return attri;
     }
     
     //footer
     else{
         UICollectionViewLayoutAttributes *attri = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionFooter withIndexPath:indexPath];
         //size
         CGSize size = CGSizeZero;
         if ([self.delegate respondsToSelector:@selector(collectionView:layout:referenceSizeForFooterInSection:)]) {
             size = [self.delegate collectionView:self.collectionView layout:self referenceSizeForFooterInSection:indexPath.section];
         }
         CGFloat x = self.sectionInset.left;
         CGFloat y = [[self.colunMaxYDic objectForKey:maxCol] floatValue];
         
         //    跟新所有对应列的高度
         for(NSString *key in self.colunMaxYDic.allKeys)
         {
             self.colunMaxYDic[key] = @(y + size.height + self.sectionInset.bottom);
         }
         
         attri.frame = CGRectMake(x , y, size.width, size.height);
         return attri;
     }
 }
 */
