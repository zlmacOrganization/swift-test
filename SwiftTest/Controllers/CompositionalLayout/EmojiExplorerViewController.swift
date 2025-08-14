//
//  EmojiExplorerViewController.swift
//  SwiftTest
//
//  Created by zhangliang on 2023/2/23.
//  Copyright © 2023 zhangliang. All rights reserved.
//

import UIKit

@available(iOS 14.0, *)
class EmojiExplorerViewController: BaseViewController {
    enum Section: Int, Hashable, CaseIterable, CustomStringConvertible {
        case recents, outline, list
        
        var description: String {
            switch self {
            case .recents: return "Recents"
            case .outline: return "Outline"
            case .list: return "List"
            }
        }
    }
    
    struct Item: Hashable {
        let title: String?
        let emoji: Emoji?
        let hasChildren: Bool
        init(emoji: Emoji? = nil, title: String? = nil, hasChildren: Bool = false) {
            self.emoji = emoji
            self.title = title
            self.hasChildren = hasChildren
        }
        private let identifier = UUID()
    }
    
    var starredEmojis = Set<Item>()
    
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
        
        navigationItem.title = "Emoji Explorer"
        navigationItem.largeTitleDisplayMode = .always

        configureViews()
        configureDataSource()
    }
    
    private func configureViews() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createLayout())
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(collectionView)
        collectionView.delegate = self
    }
    
    func createLayout() -> UICollectionViewLayout {
        return UICollectionViewCompositionalLayout { sectionIndex, environment in
            guard let sectionKind = Section(rawValue: sectionIndex) else { return nil }
            var section: NSCollectionLayoutSection
            
            if sectionKind == .recents {
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
                
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.28), heightDimension: .fractionalWidth(0.2))
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
                
                section = NSCollectionLayoutSection(group: group)
                section.interGroupSpacing = 10
                section.orthogonalScrollingBehavior = .continuousGroupLeadingBoundary
                section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
            }else if sectionKind == .outline {
                section = NSCollectionLayoutSection.list(using: .init(appearance: .sidebar), layoutEnvironment: environment)
                section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 0, trailing: 10)
            }else if sectionKind == .list {
                var config = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
                config.leadingSwipeActionsConfigurationProvider = {[weak self] indexPath in
                    guard let self = self else { return nil }
                    guard let item = self.dataSource.itemIdentifier(for: indexPath) else { return nil }
                    return self.leadingSwipeActionConfigurationForListCellItem(item)
                }
                section = NSCollectionLayoutSection.list(using: config, layoutEnvironment: environment)
            }else {
                return nil
            }
            
            return section
        }
    }
    
    func accessoriesForListCellItem(_ item: Item) -> [UICellAccessory] {
        let isStarred = starredEmojis.contains(item)
        var accesories: [UICellAccessory] = [.disclosureIndicator()]
        if isStarred {
            let star = UIImageView(image: UIImage(systemName: "star.fill"))
            accesories.append(.customView(configuration: .init(customView: star, placement: .trailing())))
        }
        
        return accesories
    }
    
    func leadingSwipeActionConfigurationForListCellItem(_ item: Item) -> UISwipeActionsConfiguration? {
        let isStarred = starredEmojis.contains(item)
        let starAction = UIContextualAction(style: .normal, title: nil) {[weak self] _, _, completion in
            guard let self = self else {
                completion(false)
                return
            }
            
            if isStarred {
                self.starredEmojis.remove(item)
            }else {
                self.starredEmojis.insert(item)
            }
            
            if let currentIndexPath = self.dataSource.indexPath(for: item), let cell = self.collectionView.cellForItem(at: currentIndexPath) as? UICollectionViewListCell {
                UIView.animate(withDuration: 0.2) {
                    cell.accessories = self.accessoriesForListCellItem(item)
                }
            }
            
            completion(true)
        }
        
        starAction.image = UIImage(systemName: isStarred ? "star.slash" : "star.fill")
        starAction.backgroundColor = .systemBlue
        
        return UISwipeActionsConfiguration(actions: [starAction])
    }
    
    private func configureDataSource() {
        let gridCellRegistration = UICollectionView.CellRegistration<UICollectionViewCell, Emoji> { cell, indexPath, item in
            var content = UIListContentConfiguration.cell()
            content.text = item.text
            content.textProperties.font = .boldSystemFont(ofSize: 38)
            content.textProperties.alignment = .center
            content.directionalLayoutMargins = .zero
            cell.contentConfiguration = content
            
            var background = UIBackgroundConfiguration.listPlainCell()
            background.cornerRadius = 8
            background.strokeColor = .systemGray3
            background.strokeWidth = 1.0/cell.traitCollection.displayScale
            
            cell.backgroundConfiguration = background
        }
        
        let headerCellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, String> { cell, indexPath, title in
            var content = cell.defaultContentConfiguration()
            content.text = title
            cell.contentConfiguration = content
            cell.accessories = [.outlineDisclosure(options: .init(style: .header))]
        }
        
        let outlineCellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, Emoji> { cell, indexPath, item in
            var content = cell.defaultContentConfiguration()
            content.text = item.text
            content.secondaryText = item.title
            cell.contentConfiguration = content
            cell.accessories = [.disclosureIndicator()]
        }
        
        let listCellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, Item> {[weak self] cell, indexPath, item in
            guard let self = self, let emoji = item.emoji else { return }
            
            var content = UIListContentConfiguration.valueCell()
            content.text = emoji.text
            content.secondaryText = "\(emoji.category)"
            cell.contentConfiguration = content
            cell.accessories = self.accessoriesForListCellItem(item)
        }
        
        dataSource = UICollectionViewDiffableDataSource<Section, Item>(collectionView: collectionView, cellProvider: { collectionView, indexPath, item in
            guard let section = Section(rawValue: indexPath.section) else { fatalError("Unknown section") }
            switch section {
            case .recents:
                return collectionView.dequeueConfiguredReusableCell(using: gridCellRegistration, for: indexPath, item: item.emoji)
            case .list:
                return collectionView.dequeueConfiguredReusableCell(using: listCellRegistration, for: indexPath, item: item)
            case .outline:
                if item.hasChildren {
                    return collectionView.dequeueConfiguredReusableCell(using: headerCellRegistration, for: indexPath, item: item.title)
                }else {
                    return collectionView.dequeueConfiguredReusableCell(using: outlineCellRegistration, for: indexPath, item: item.emoji)
                }
            }
        })
        
        applySnapshots()
    }
    
    private func applySnapshots() {
        let sections = Section.allCases
        var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
        snapshot.appendSections(sections)
        dataSource.apply(snapshot, animatingDifferences: false)
        
        let recentItems = Emoji.Category.recents.emojis.map {Item(emoji: $0)}
        var recentsSnapshot = NSDiffableDataSourceSectionSnapshot<Item>()
        recentsSnapshot.append(recentItems)
        dataSource.apply(recentsSnapshot, to: .recents, animatingDifferences: false)
        
        var allSnapshot = NSDiffableDataSourceSectionSnapshot<Item>()
        var outlineSnapshot = NSDiffableDataSourceSectionSnapshot<Item>()
        
        for category in Emoji.Category.allCases where category != .recents {
            let allSnapshotItems = category.emojis.map {Item(emoji: $0)}
            allSnapshot.append(allSnapshotItems)
            
            let rootItem = Item(title: "\(category)", hasChildren: true)
            outlineSnapshot.append([rootItem])
            
            let outlineItems = category.emojis.map {Item(emoji: $0)}
            outlineSnapshot.append(outlineItems, to: rootItem)
        }
        
        dataSource.apply(recentsSnapshot, to: .recents, animatingDifferences: false)
        dataSource.apply(allSnapshot, to: .list, animatingDifferences: false)
        dataSource.apply(outlineSnapshot, to: .outline, animatingDifferences: false)
        
        for _ in 0..<5 {
            if let item = allSnapshot.items.randomElement() {
                self.starredEmojis.insert(item)
            }
        }
    }
}

@available(iOS 14.0, *)
extension EmojiExplorerViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let emoji = self.dataSource.itemIdentifier(for: indexPath)?.emoji else {
            collectionView.deselectItem(at: indexPath, animated: true)
            return
        }
        let detailViewController = EmojiDetailViewController(with: emoji)
        self.navigationController?.pushViewController(detailViewController, animated: true)
    }
}
