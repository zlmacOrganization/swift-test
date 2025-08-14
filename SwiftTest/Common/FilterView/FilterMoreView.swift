//
//  FilterMoreView.swift
//  SwiftTest
//
//  Created by zhangliang on 2021/3/17.
//  Copyright © 2021 zhangliang. All rights reserved.
//

import UIKit

class FilterMoreView: UIView {
    private var collectionView: UICollectionView!
    private var selectIndexs: [Int]
    private let sectionTitles = ["付款方式", "地铁", "均价", "装修情况", "建筑类别", "物业类型", "房型"]
    private let items = [["商业贷款", "公积金贷款", "组合贷款", "首付分期"],
                         ["1号线", "2号线"],
                         ["1万-2万", "2万-3万", "3万-4万", "4万-5万", "5万-6万", "6万-7万", "7万-8万", "8万-9万", "9万-10万", "10万-11万", "11万-12万"],
                         ["全部", "毛坯", "简装", "精装", "豪装"],
                         ["全部", "低层", "多层", "小高层", "高层"],
                         ["全部", "公寓", "洋房", "别墅", "商住楼", "酒店", "土地", "商业", "产业园", "车库", "厂房"],
                         ["1房", "2房", "3房", "4房", "5房以上"]]

    init() {
        self.selectIndexs = Array(repeating: -1, count: sectionTitles.count)
        super.init(frame: CGRect.zero)
        
        configureViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureViews() {
        //https://juejin.cn/post/6942356138960617508#heading-3
        
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 12
        layout.sectionHeadersPinToVisibleBounds = true
        layout.sectionFootersPinToVisibleBounds = true
        layout.headerReferenceSize = CGSize(width: kMainScreenWidth, height: 40)
//        layout.footerReferenceSize = CGSize(width: kMainScreenWidth, height: 15)
        layout.itemSize = CGSize(width: (kMainScreenWidth - 60)/4, height: 26)
        
        layout.register(UICollectionReusableView.self, forDecorationViewOfKind: "MoreDecorationView")
        
        collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 12)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.showsVerticalScrollIndicator = false
        collectionView.zl_registerCell(FilterMoreCollectionCell.self)
        collectionView.zl_registerSupplementaryView(kind: UICollectionView.elementKindSectionHeader, HeaderReusableView.self)
        collectionView.zl_registerSupplementaryView(kind: UICollectionView.elementKindSectionFooter, UICollectionReusableView.self)
        collectionView.zl_registerSupplementaryView(kind: UICollectionView.elementKindSectionFooter, FooterReusableView.self)
        
        collectionView.backgroundColor = UIColor.white
        addSubview(collectionView)
        
        collectionView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
}

extension FilterMoreView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sectionTitles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items[section].count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.zl_dequeueReusableCell(FilterMoreCollectionCell.self, indexPath: indexPath)
        cell.titleLabel.text = items[indexPath.section][indexPath.item]
        
        if selectIndexs[indexPath.section] == indexPath.item {
            cell.contentView.backgroundColor = colorWithRGB(r: 254, g: 233, b: 233)
            cell.titleLabel.textColor = colorWithRGB(r: 49, g: 193, b: 147)
        }else {
            cell.contentView.backgroundColor = UIColor.clear
            cell.titleLabel.textColor = UIColor.darkGray
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectIndexs[indexPath.section] = indexPath.item
        collectionView.reloadData()
    }
    
    //
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            let header = collectionView.zl_dequeueSupplementaryView(kind: kind, HeaderReusableView.self, indexPath: indexPath)
            header.titleLabel.text = sectionTitles[indexPath.section]
            header.backgroundColor = UIColor.white
            
            return header
        }else {
            if indexPath.section == sectionTitles.count - 1 {
                let foot = collectionView.zl_dequeueSupplementaryView(kind: kind, FooterReusableView.self, indexPath: indexPath)
                
                foot.resetBlock = {[weak self] in
                    guard let self = self else { return }
                    
                    self.selectIndexs = Array(repeating: -1, count: self.sectionTitles.count)
                    collectionView.reloadData()
                }
                foot.backgroundColor = UIColor.white
                
                return foot
            }
            
            let footer = collectionView.zl_dequeueSupplementaryView(kind: kind, UICollectionReusableView.self, indexPath: indexPath)
            return footer
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        if section == sectionTitles.count - 1 {
            return CGSize(width: kMainScreenWidth, height: 61)
        }
        
        return CGSize(width: kMainScreenWidth, height: 15)
    }
}

fileprivate class FilterMoreCollectionCell: UICollectionViewCell {
    var titleLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureViews()
        
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = colorWithRGB(r: 230, g: 230, b: 230).cgColor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureViews() {
        titleLabel = CommonFunction.createLabel(font: UIFont.systemFont(ofSize: 13), text: "", textColor: UIColor.darkGray, textAlignment: .center)
        contentView.addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
        }
    }
}

fileprivate class HeaderReusableView: UICollectionReusableView {
    var titleLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureViews() {
        titleLabel = CommonFunction.createLabel(font: UIFont.systemFont(ofSize: 14), text: "", textColor: UIColor.black, textAlignment: .center)
        addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(10)
            make.left.equalTo(0)
        }
    }
}

fileprivate class FooterReusableView: UICollectionReusableView {
    var resetBlock: (() -> Void)?
    var commitBlock: (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureViews() {
        let lineView1 = UIView()
        lineView1.backgroundColor = colorWithRGB(r: 230, g: 230, b: 230)
        addSubview(lineView1)
        
        lineView1.snp.makeConstraints { (make) in
            make.top.equalTo(14)
            make.height.equalTo(1)
            make.left.right.equalTo(0)
        }
        
        let resetButton = CommonFunction.createButton(frame: CGRect.zero, title: "重置", textColor: UIColor.white, font: UIFont.systemFont(ofSize: 13), imageName: nil, target: self, action: #selector(resetAction))
        resetButton.backgroundColor = colorWithRGB(r: 49, g: 193, b: 147)
        addSubview(resetButton)
        
        resetButton.snp.makeConstraints { (make) in
            make.left.equalTo(0)
            make.top.equalTo(lineView1.snp.bottom).offset(6)
            make.size.equalTo(CGSize(width: 90, height: 34))
        }
        
        
        let commitButton = CommonFunction.createButton(frame: CGRect.zero, title: "提交", textColor: UIColor.white, font: UIFont.systemFont(ofSize: 13), imageName: nil, target: self, action: #selector(resetAction))
        commitButton.backgroundColor = colorWithRGB(r: 49, g: 193, b: 147)
        addSubview(commitButton)
        
        commitButton.snp.makeConstraints { (make) in
            make.left.equalTo(resetButton.snp.right).offset(20)
            make.right.equalTo(0)
            make.centerY.equalTo(resetButton)
            make.height.equalTo(34)
        }
        
        
        let lineView2 = UIView()
        lineView2.backgroundColor = colorWithRGB(r: 230, g: 230, b: 230)
        addSubview(lineView2)
        
        lineView2.snp.makeConstraints { (make) in
            make.height.equalTo(1)
            make.bottom.equalTo(0)
            make.left.right.equalTo(0)
        }
    }
    
    @objc private func resetAction() {
        resetBlock?()
    }
    
    @objc private func commitAction() {
        commitBlock?()
    }
}
