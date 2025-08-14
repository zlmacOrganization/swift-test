//
//  SectionDecorationViewController.swift
//  SwiftTest
//
//  Created by zhangliang on 2023/2/23.
//  Copyright © 2023 zhangliang. All rights reserved.
//

import UIKit

@available(iOS 14.0, *)
class SectionDecorationViewController: BaseViewController {
    static let sectionBackgroundDecorationElementKind = "section-background-element-kind"

    var currentSnapshot: NSDiffableDataSourceSnapshot<Int, Int>!
    var dataSource: UICollectionViewDiffableDataSource<Int, Int>!
    var collectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "Section Background Decoration View"
        
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createLayout())
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.backgroundColor = .systemBackground
        view.addSubview(collectionView)
        collectionView.delegate = self
        
        configureDataSource()
    }
    
    private func createLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(44))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 5
        section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
        
        let decoration = NSCollectionLayoutDecorationItem.background(elementKind: SectionDecorationViewController.sectionBackgroundDecorationElementKind)
        decoration.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
        
        section.decorationItems = [decoration]
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        layout.register(SectionBackgroundDecorationView.self, forDecorationViewOfKind: SectionDecorationViewController.sectionBackgroundDecorationElementKind)
        
        return layout
    }

    private func configureDataSource() {
        let cellRegistration = UICollectionView.CellRegistration<ListCell, Int> {[weak self] cell, indexPath, itemIdentifier in
            guard let self else { return }
            let sectionIdentifier = self.currentSnapshot.sectionIdentifiers[indexPath.section]
            let numOfItems = self.currentSnapshot.numberOfItems(inSection: sectionIdentifier)
            let isLastCell = indexPath.item + 1 == numOfItems
            
            cell.seperatorView.isHidden = isLastCell
            cell.label.text = "\(indexPath.section), \(indexPath.item)"
        }
        
        dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView, cellProvider: { (collectionView, indexPath, itemIdentifier) -> UICollectionViewCell? in
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: itemIdentifier)
        })
        
        currentSnapshot = NSDiffableDataSourceSnapshot<Int, Int>()
        let itemsPerSection = 5
        let sections = Array(0..<5)
        var itemOffset = 0
        
        sections.forEach{
            currentSnapshot.appendSections([$0])
            let items = Array(itemOffset..<itemOffset + itemsPerSection)
            currentSnapshot.appendItems(items)
            itemOffset += itemsPerSection
        }
        dataSource.apply(currentSnapshot, animatingDifferences: false)
    }
}

@available(iOS 14.0, *)
extension SectionDecorationViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
    }
}
