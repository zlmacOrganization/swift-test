//
//  MountainsViewController.swift
//  SwiftTest
//
//  Created by zhangliang on 2023/2/23.
//  Copyright © 2023 zhangliang. All rights reserved.
//

import UIKit

@available(iOS 14.0, *)
class MountainsViewController: BaseViewController {
    enum Section: CaseIterable {
        case main
    }
    
    let mountainsController = MountainsController()
    let searchBar = UISearchBar(frame: .zero)
    var collectionView: UICollectionView!
    var dataSource: UICollectionViewDiffableDataSource<Section, MountainsController.Mountain>!
    var nameFilter: String?

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "Mountains Search"
        
        configureHierarchy()
        configureDataSource()
        performQuery(with: nil)
    }
    
    func configureHierarchy() {
        view.backgroundColor = .systemBackground
        
        collectionView = UICollectionView(frame: CGRect(x: 0, y: 45, width: kMainScreenWidth, height: kMainScreenHeight - 40 - kNaviBarHeight), collectionViewLayout: createLayout())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .systemBackground
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.delegate = self
        view.addSubview(collectionView)
        
        searchBar.delegate = self
        view.addSubview(searchBar)
        
        searchBar.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(5)
            make.height.equalTo(40)
        }
    }
    
    func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { index, enviromnent in
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                  heightDimension: .fractionalHeight(1.0))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            let colunms = enviromnent.container.effectiveContentSize.width > 800 ? 3 : 2
            
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                   heightDimension: .absolute(32))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: colunms)
            group.interItemSpacing = .fixed(10)
            
            let section = NSCollectionLayoutSection(group: group)
            section.interGroupSpacing = 10
            section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
            
            return section
        }
        
        return layout
    }

    func configureDataSource() {
        let cellRegistration = UICollectionView.CellRegistration<LabelCell, MountainsController.Mountain> { cell, indexPath, mountain in
            cell.label.text = mountain.name
        }
        
        dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView, cellProvider: { (collectionView, indexPath, itemIdentifier) -> UICollectionViewCell? in
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: itemIdentifier)
        })
    }
    
    func performQuery(with filter: String?) {
        let mountains = mountainsController.filteredMountains(with: filter).sorted(by: { $0.name < $1.name })
        var snapshot = NSDiffableDataSourceSnapshot<Section, MountainsController.Mountain>()
        snapshot.appendSections([.main])
        snapshot.appendItems(mountains)
        dataSource.apply(snapshot)
    }
}

@available(iOS 14.0, *)
extension MountainsViewController: UISearchBarDelegate, UICollectionViewDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        performQuery(with: searchText)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        searchBar.resignFirstResponder()
    }
}
