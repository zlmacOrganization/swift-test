//
//  EmojiExplorerListViewController.swift
//  SwiftTest
//
//  Created by zhangliang on 2023/2/23.
//  Copyright © 2023 zhangliang. All rights reserved.
//

import UIKit

@available(iOS 14.0, *)
class EmojiExplorerListViewController: BaseViewController {
    typealias Section = Emoji.Category
    
    struct Item: Hashable {
        let title: String
        let emoji: Emoji
        init(emoji: Emoji, title: String) {
            self.emoji = emoji
            self.title = title
        }
        private let identifier = UUID()
    }
    
    var collectionView: UICollectionView!
    var dataSource: UICollectionViewDiffableDataSource<Section, Item>!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let indexPath = collectionView.indexPathsForSelectedItems?.first {
            if let coordinator = self.transitionCoordinator {
                coordinator.animate { context in
                    self.collectionView.deselectItem(at: indexPath, animated: true)
                } completion: { context in
                    if context.isCancelled {
                        self.collectionView.selectItem(at: indexPath, animated: false, scrollPosition: [])
                    }
                }

            }else {
                self.collectionView.deselectItem(at: indexPath, animated: true)
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "Emoji Explorer - List"
        
        configureViews()
        configureDataSource()
    }

    private func configureViews() {
        let configuration = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
        let layout = UICollectionViewCompositionalLayout.list(using: configuration)
        
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(collectionView)
        collectionView.delegate = self
    }

    private func configureDataSource() {
        let cellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, Emoji> { cell, indexPath, emoji in
            var contentConfig = UIListContentConfiguration.valueCell()
            contentConfig.text = emoji.text
            contentConfig.secondaryText = "\(emoji.category)"
            cell.contentConfiguration = contentConfig
            
            cell.accessories = [.disclosureIndicator()]
        }
        
        dataSource = UICollectionViewDiffableDataSource<Section, Item>(collectionView: collectionView, cellProvider: { collectionView, indexPath, item in
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: item.emoji)
        })
        
        for category in Emoji.Category.allCases.reversed() {
            var sectionSnapshot = NSDiffableDataSourceSectionSnapshot<Item>()
            let items = category.emojis.map {Item(emoji: $0, title: "\(category)")}
            sectionSnapshot.append(items)
            
            dataSource.apply(sectionSnapshot, to: category, animatingDifferences: false)
        }
    }
}

@available(iOS 14.0, *)
extension EmojiExplorerListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let emoji = self.dataSource.itemIdentifier(for: indexPath)?.emoji else {
            collectionView.deselectItem(at: indexPath, animated: true)
            return
        }
        let detailViewController = EmojiDetailViewController(with: emoji)
        self.navigationController?.pushViewController(detailViewController, animated: true)
    }
}
