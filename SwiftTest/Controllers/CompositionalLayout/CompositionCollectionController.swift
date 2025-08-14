//
//  CompositionCollectionController.swift
//  SwiftTest
//
//  Created by ZhangLiang on 2020/6/29.
//  Copyright © 2020 ZhangLiang. All rights reserved.
//

import UIKit

@available(iOS 13.0, *)
class CompositionCollectionController: BaseViewController {
    
    enum Section {
        case main
        case second
    }
    
    enum MenuItem: String, CaseIterable {
        case list = "List"
        case edgedList = "Edged List"
        case estimatedList = "Estimated List"
        case estimatedGrid = "Estimated Grid"
        case complexGroup = "Complex Group"
        case ortho = "Orthogonal Collection"
        case checkMarkGrid = "Checkmark Grid"
        case headerFooter = "Header & Footer"
        case backgroundSection = "Background Section"
    }
    
    private var collectionView: UICollectionView!
    private var dataSource: UICollectionViewDiffableDataSource<Section, ItemData>!
    private var dataArray : [[ItemData]] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        setAlignmentCollectionView()
        loadData()
        initCollectionView()
        createDataSource()
    }
    
    private func setAlignmentCollectionView() {
        collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: CollectionAlignmentFlowLayout(.left, 5))
            collectionView.zl_registerCell(AlignmentCollectionCell.self)
            collectionView.delegate = self
            collectionView.dataSource = self
            collectionView.backgroundColor = UIColor.white
            
            view.addSubview(collectionView)
            
            collectionView.snp.makeConstraints { (make) in
                make.edges.equalTo(view)
        }
    }
    
    private func initCollectionView() {
        
        let layout = createLayout()
        collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.zl_registerCell(AlignmentCollectionCell.self)
        collectionView.delegate = self
        collectionView.backgroundColor = UIColor.white
        
        view.addSubview(collectionView)
        
        collectionView.snp.makeConstraints { (make) in
            make.edges.equalTo(view)
        }
    }
    
    func loadData() {
        for _ in 0 ... 1 {
            var dataArrayTemp = [ItemData]()
            for index in 0 ..< 30 {
                let n = arc4random() % 10 + 1
                let itemData = ItemData()
                itemData.content = "\(index + 1)"
                itemData.size = CGSize(width: CGFloat((n * 5)) + 50.0, height: 30)
                dataArrayTemp.append(itemData)
            }
            dataArray.append(dataArrayTemp)
        }
    }
    
    //MARK: - CollectionViewCompositionalLayout
    @available(iOS 13.0, *)
    private func createLayout() -> UICollectionViewCompositionalLayout {
//        let width = (kMainScreenWidth - 30)/4
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.25), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalWidth(0.25))
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
//        let spacing = CGFloat(10)
//        group.interItemSpacing = .fixed(spacing)
        
//        let section = NSCollectionLayoutSection(group: group)
//        section.orthogonalScrollingBehavior = .continuous
//        section.interGroupSpacing = spacing
//        section.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
        
        let layout = UICollectionViewCompositionalLayout(section: NSCollectionLayoutSection(group: group))
        return layout
    }
    
    private func createDataSource() {
        dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView, cellProvider: { (collection, indexPath, item) -> UICollectionViewCell? in
            let cell = collection.zl_dequeueReusableCell(AlignmentCollectionCell.self, indexPath: indexPath)
//            cell.contentView.backgroundColor = UIColor.randomColor()
            cell.label.text = item.content
            
            return cell
        })
        
        var snpashot = NSDiffableDataSourceSnapshot<Section, ItemData>()
        snpashot.appendSections([.main])
        snpashot.appendItems(dataArray[0])
        
        dataSource.apply(snpashot)
    }
}

@available(iOS 13.0, *)
extension CompositionCollectionController: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return dataArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataArray[section].count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.zl_dequeueReusableCell(UICollectionViewCell.self, indexPath: indexPath)
//        cell.backgroundColor = UIColor.purple
        
        let cell = collectionView.zl_dequeueReusableCell(AlignmentCollectionCell.self, indexPath: indexPath)
        
        let dataTemp = dataArray[indexPath.section]
        let itemData = dataTemp[indexPath.item]
        cell.label.text = itemData.content
        
        return cell
    }
}

@available(iOS 13.0, *)
extension CompositionCollectionController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let dataTemp = dataArray[indexPath.section]
        let itemData = dataTemp[indexPath.item]
        return itemData.size
    }
}


class ItemData: NSObject {
    var content : String = ""
    var size : CGSize = CGSize.zero
}
