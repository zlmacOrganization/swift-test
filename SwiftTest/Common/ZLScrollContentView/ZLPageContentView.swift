//
//  ZLPageContentView.swift
//  SwiftTest
//
//  Created by bfgjs on 2020/1/3.
//  Copyright © 2020 ZhangLiang. All rights reserved.
//

import UIKit

protocol ZLPageContentDelegate: AnyObject {
    func zlContentViewWillBeginDragging()
    func zlContentViewDidScroll(contentView: ZLPageContentView, startIndex: Int, endIndex: Int, progress: CGFloat, scrollView: UIScrollView)
    func zlContenViewDidEndDecelerating(contentView: ZLPageContentView, startIndex: Int, endIndex: Int)
    func zlContenViewDidEndDragging()
}

class ZLPageContentView: UIView {
    
    private var collectionView: UICollectionView!
    private let childVCs: [UIViewController]
    private weak var parentVC: UIViewController?
    private weak var delegate: ZLPageContentDelegate?
    
    private var startOffsetX: CGFloat = 0
    private var contentIsScroll: Bool = false //是否是滑动
    
    var contentViewCanScroll: Bool = true {
        didSet {
            collectionView.isScrollEnabled = contentViewCanScroll
        }
    }
    
    var currentIndex: Int = 0 {
        didSet {
            if (currentIndex < 0 || currentIndex > self.childVCs.count-1 || self.childVCs.count == 0) {
                return;
            }
            
            contentIsScroll = true
            collectionView.scrollToItem(at: IndexPath(item: currentIndex, section: 0), at: .left, animated: false)
        }
    }

    init(frame: CGRect, childVCs: [UIViewController], parentVC: UIViewController, delegate: ZLPageContentDelegate?) {
        self.childVCs = childVCs
        self.parentVC = parentVC
        self.delegate = delegate
        
        super.init(frame: frame)
        
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        configureCollectionView()
        
        for controller in self.childVCs {
            self.parentVC?.addChild(controller)
        }
        
        collectionView.reloadData()
    }
    
    private func configureCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = self.bounds.size
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .horizontal
//        layout.sectionInset = UIEdgeInsets(top: 11, left: 12, bottom: 5, right: 12)
        
        collectionView = UICollectionView(frame: self.bounds, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.bounces = false
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.zl_registerCell(UICollectionViewCell.self)
        
        CommonFunction.setDynamicColor(defaultColor: .white, darkColor: .black) { (dynamic) in
            self.collectionView.backgroundColor = dynamic
        }
        
        addSubview(collectionView)
    }
}

extension ZLPageContentView: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.childVCs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.zl_dequeueReusableCell(UICollectionViewCell.self, indexPath: indexPath)
        
        for view in cell.contentView.subviews {
            view.removeFromSuperview()
        }

        let childVC = self.childVCs[indexPath.item]
        childVC.view.frame = cell.contentView.bounds
        cell.contentView.addSubview(childVC.view)
        
        return cell
    }
}

extension ZLPageContentView: UIScrollViewDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        contentIsScroll = false
        startOffsetX = scrollView.contentOffset.x
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if contentIsScroll {
            return
        }
        
        let width = scrollView.bounds.size.width
        let offsetX = scrollView.contentOffset.x
        let startIndex = Int(floor(startOffsetX/width))
        var endIndex: Int = 0, progress: CGFloat = 0
        
        if offsetX > startOffsetX {//左滑
            progress = (offsetX - startOffsetX)/width
            
            endIndex = startIndex + 1
            if endIndex > childVCs.count - 1 {
                endIndex = childVCs.count - 1
            }
        }else if Int(offsetX) == startIndex {
            progress = 0
            endIndex = startIndex
        }else {//右滑
            progress = (startOffsetX - offsetX)/width
            
            endIndex = startIndex - 1
            if endIndex < 0 {
                endIndex = 0
            }
        }
        
        delegate?.zlContentViewDidScroll(contentView: self, startIndex: startIndex, endIndex: endIndex, progress: progress, scrollView: scrollView)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let width = scrollView.bounds.size.width
        let offsetX = scrollView.contentOffset.x
        let startIndex = Int(floor(startOffsetX/width))
        let endIndex = Int(floor(offsetX/width))
        
        delegate?.zlContenViewDidEndDecelerating(contentView: self, startIndex: startIndex, endIndex: endIndex)
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        delegate?.zlContenViewDidEndDragging()
    }
}
