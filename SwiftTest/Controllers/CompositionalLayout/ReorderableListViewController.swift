//
//  ReorderableListViewController.swift
//  SwiftTest
//
//  Created by zhangliang on 2023/2/23.
//  Copyright © 2023 zhangliang. All rights reserved.
//

import UIKit

@available(iOS 14.0, *)
class ReorderableListViewController: BaseViewController {
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
    lazy var backingStore: [Section: [Item]] = { initialBackingStore() }()

    enum ReorderingMethod: CustomStringConvertible {
        case finalSnapshot, collectionDifference
    }
    
    var reorderingMethod: ReorderingMethod = .collectionDifference

    override func viewDidLoad() {
        super.viewDidLoad()

        configureNavItem()
        configureHierarchy()
        configureDataSource()
        applySnapshotsFromBackingStore()
    }
    
    func configureNavItem() {
        navigationItem.title = "Reorderable List"
        navigationItem.largeTitleDisplayMode = .always
        
        func createMenu() -> UIMenu {
            let refreshAction = UIAction(title: "Reload backingStore", image: UIImage(systemName: "arrow.counterclockwise")) { [weak self] _ in
                guard let self = self else { return }
                // update from our source of truth: our backing store.
                // This shows us that the backing store was properly updated from any
                // reordering operation
                self.applySnapshotsFromBackingStore(animated: true)
            }
            
            let restoreAction = UIAction(title: "Reload initialStore", image: UIImage(systemName: "arrow.counterclockwise")) { [weak self] _ in
                guard let self = self else { return }
                self.applyInitialBackingStore(animated: true)
            }
            
            let finalSnapshotAction = UIAction(
                title: String(describing: ReorderingMethod.finalSnapshot),
                image: UIImage(systemName: "function")) { [weak self] action in
                guard let self = self else { return }
                self.reorderingMethod = .finalSnapshot
//                if let barButtonItem = action.sender as? UIBarButtonItem {
//                    barButtonItem.menu = createMenu()
//                }
            }
                
            let collectionDifferenceAction = UIAction(
                title: String(describing: ReorderingMethod.collectionDifference),
                image: UIImage(systemName: "function")) { [weak self] action in
                guard let self = self else { return }
                self.reorderingMethod = .collectionDifference
//                if let barButtonItem = action.sender as? UIBarButtonItem {
//                    barButtonItem.menu = createMenu()
//                }
            }
            
            if self.reorderingMethod == .collectionDifference {
                collectionDifferenceAction.state = .on
            } else if self.reorderingMethod == .finalSnapshot {
                finalSnapshotAction.state = .on
            }
            
            let reorderingMethodMenu = UIMenu(title: "", options: .displayInline, children: [finalSnapshotAction, collectionDifferenceAction])
            let menu = UIMenu(title: "", children: [refreshAction, restoreAction, reorderingMethodMenu])
            return menu
        }
        let navItem = UIBarButtonItem(image: UIImage(systemName: "gear"), menu: createMenu())
        navigationItem.rightBarButtonItem = navItem
    }
    
    func configureHierarchy() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createLayout())
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.backgroundColor = .systemGroupedBackground
        view.addSubview(collectionView)
    }
    
    func createLayout() -> UICollectionViewLayout {
        let configuration = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
        return UICollectionViewCompositionalLayout.list(using: configuration)
    }
    
    func configureDataSource() {
        let cellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, Emoji> { cell, indexPath, emoji in
            var content = UIListContentConfiguration.valueCell()
            content.text = emoji.text
            content.secondaryText = String(describing: emoji.category)
            cell.contentConfiguration = content
            
            cell.accessories = [.disclosureIndicator(), .reorder(displayed: .always)]
        }
        
        dataSource = UICollectionViewDiffableDataSource<Section, Item>(collectionView: collectionView, cellProvider: { myCollectionView, indexPath, item -> UICollectionViewCell? in
            return myCollectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: item.emoji)
        })
        
        dataSource.reorderingHandlers.canReorderItem = { item in
            return true
        }
        
        dataSource.reorderingHandlers.didReorder = {[weak self] transaction in
            guard let self = self else { return }
            
            if self.reorderingMethod == .collectionDifference {
                
                for sectionTransaction in transaction.sectionTransactions {
                    let sectionIdentifier = sectionTransaction.sectionIdentifier
                    if let previousSectionItems = self.backingStore[sectionIdentifier],
                       let updatedSectionItems = previousSectionItems.applying(sectionTransaction.difference) {
                        self.backingStore[sectionIdentifier] = updatedSectionItems
                    }
                }
            }else if self.reorderingMethod == .finalSnapshot {
                
                for sectionTransaction in transaction.sectionTransactions {
                    let sectionIdentifier = sectionTransaction.sectionIdentifier
                    self.backingStore[sectionIdentifier] = sectionTransaction.finalSnapshot.items
                }
            }
        }
    }
    
    func initialBackingStore() -> [Section: [Item]] {
        var allItems = [Section: [Item]]()
        for category in Emoji.Category.allCases.reversed() {
            let items = category.emojis.map { Item(emoji: $0, title: String(describing: category)) }
            allItems[category] = items
        }
        return allItems
    }
    
    func applyInitialBackingStore(animated: Bool = false) {
        for (section, items) in initialBackingStore() {
            var sectionSnapshot = NSDiffableDataSourceSectionSnapshot<Item>()
            sectionSnapshot.append(items)
            dataSource.apply(sectionSnapshot, to: section, animatingDifferences: animated)
        }
    }
    
    func applySnapshotsFromBackingStore(animated: Bool = false) {
        for (section, items) in backingStore {
            var sectionSnapshot = NSDiffableDataSourceSectionSnapshot<Item>()
            sectionSnapshot.append(items)
            dataSource.apply(sectionSnapshot, to: section, animatingDifferences: animated)
        }
    }
}

@available(iOS 14.0, *)
extension ReorderableListViewController.ReorderingMethod {
    var description: String {
        switch self {
        case .collectionDifference: return "Collection Difference"
        case .finalSnapshot: return "Final Snapshot Items"
        }
    }
}
