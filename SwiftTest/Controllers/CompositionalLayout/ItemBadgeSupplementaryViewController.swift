//
//  ItemBadgeSupplementaryViewController.swift
//  SwiftTest
//
//  Created by zhangliang on 2023/2/23.
//  Copyright © 2023 zhangliang. All rights reserved.
//

import UIKit

@available(iOS 14.0, *)
class ItemBadgeSupplementaryViewController: BaseViewController {
    static let badgeElementKind = "badge-element-kind"
    enum Section {
        case main
    }

    struct Model: Hashable {
        let title: String
        let badgeCount: Int

        let identifier = UUID()
        func hash(into hasher: inout Hasher) {
            hasher.combine(identifier)
        }
    }

    var dataSource: UICollectionViewDiffableDataSource<Section, Model>!

    var collectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Item Badges"

        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createLayout())
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.backgroundColor = .systemBackground
        view.addSubview(collectionView)
        
        configureDataSource()
    }

    func createLayout() -> UICollectionViewLayout {
        let badgeAnchor = NSCollectionLayoutAnchor(edges: [.top, .trailing], fractionalOffset: CGPoint(x: 0.3, y: -0.3))
        let badgeSize = NSCollectionLayoutSize(widthDimension: .absolute(20),
                                              heightDimension: .absolute(20))
        let badgeItem = NSCollectionLayoutSupplementaryItem(layoutSize: badgeSize, elementKind: BadgeSupplementaryView.reuseIdentifier, containerAnchor: badgeAnchor)
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.25), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize, supplementaryItems: [badgeItem])
        item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .fractionalWidth(0.2))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 20, leading: 20, bottom: 20, trailing: 20)
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
    
    func configureDataSource() {
        let cellRegistration = UICollectionView.CellRegistration<TextCell, Model> { (cell, indexPath, model) in
            cell.label.text = model.title
            cell.contentView.backgroundColor = .cornflowerBlue
            cell.contentView.layer.borderColor = UIColor.black.cgColor
            cell.contentView.layer.borderWidth = 1
            cell.contentView.layer.cornerRadius = 8
            cell.label.textAlignment = .center
            cell.label.font = UIFont.preferredFont(forTextStyle: .title1)
        }
        
        let supplementaryRegistration = UICollectionView.SupplementaryRegistration<BadgeSupplementaryView>(elementKind: BadgeSupplementaryView.reuseIdentifier) {[weak self] supplementaryView, elementKind, indexPath in
            guard let self = self, let model = self.dataSource.itemIdentifier(for: indexPath) else { return }
            let hasBadgeCount = model.badgeCount > 0
            supplementaryView.label.text = "\(model.badgeCount)"
            supplementaryView.isHidden = !hasBadgeCount
        }
        
        dataSource = UICollectionViewDiffableDataSource<Section, Model>(collectionView: collectionView, cellProvider: { (collectionView, indexPath, model) -> UICollectionViewCell? in
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: model)
        })
        
        dataSource.supplementaryViewProvider = {[weak self] collectionView, elementKind, indexPath in
            return self?.collectionView.dequeueConfiguredReusableSupplementary(using: supplementaryRegistration, for: indexPath)
        }
        
        var snapshot = NSDiffableDataSourceSnapshot<Section, Model>()
        snapshot.appendSections([.main])
        let models = (0..<50).map { Model(title: "\($0)", badgeCount: Int.random(in: 0..<5)) }
        snapshot.appendItems(models)
        dataSource.apply(snapshot, animatingDifferences: false)
    }
}

@available(iOS 14.0, *)
extension ItemBadgeSupplementaryViewController {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
    }
}

extension UIColor {
    static var cornflowerBlue: UIColor {
        return UIColor(displayP3Red: 100.0 / 255.0, green: 149.0 / 255.0, blue: 237.0 / 255.0, alpha: 1.0)
    }
}
