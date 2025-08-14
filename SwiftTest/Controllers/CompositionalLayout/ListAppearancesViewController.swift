//
//  ListAppearancesViewController.swift
//  SwiftTest
//
//  Created by zhangliang on 2023/2/23.
//  Copyright © 2023 zhangliang. All rights reserved.
//

import UIKit

@available(iOS 14.0, *)
class ListAppearancesViewController: BaseViewController {
    private struct Item: Hashable {
        let title: String?
        private let identifier = UUID()
    }
    
    private var collectionView: UICollectionView!
    private var dataSource: UICollectionViewDiffableDataSource<Int, Item>!
    private var appearance = UICollectionLayoutListConfiguration.Appearance.plain

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "List Appearances"
        
        configureHierarchy()
        configureDataSource()
        updateBarButtonItem()
    }
    
    @objc private func changeListAppearance() {
        switch appearance {
        case .plain:
            appearance = .sidebarPlain
        case .sidebarPlain:
            appearance = .sidebar
        case .sidebar:
            appearance = .grouped
        case .grouped:
            appearance = .insetGrouped
        case .insetGrouped:
            appearance = .plain
        default:
            break
        }
        let selectedIndexPath = collectionView.indexPathsForSelectedItems?.first
        dataSource.apply(dataSource.snapshot(), animatingDifferences: false)
        collectionView.selectItem(at: selectedIndexPath, animated: false, scrollPosition: [])
        updateBarButtonItem()
    }
    
    private func updateBarButtonItem() {
        var title: String? = nil
        switch appearance {
        case .plain: title = "Plain"
        case .sidebarPlain: title = "Sidebar Plain"
        case .sidebar: title = "Sidebar"
        case .grouped: title = "Grouped"
        case .insetGrouped: title = "Inset Grouped"
        default: break
        }
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: title, style: .plain, target: self, action: #selector(changeListAppearance))
    }

    func configureHierarchy() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createLayout())
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(collectionView)
    }
    
    func createLayout() -> UICollectionViewLayout {
        return UICollectionViewCompositionalLayout {[unowned self] section, environment in
            
            var config = UICollectionLayoutListConfiguration(appearance: self.appearance)
            config.headerMode = .firstItemInSection
            return NSCollectionLayoutSection.list(using: config, layoutEnvironment: environment)
        }
    }

    func configureDataSource() {
        let headerRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, Item> { cell, indexPath, item in
            var content = cell.defaultContentConfiguration()
            content.text = item.title
            cell.contentConfiguration = content
            
            cell.accessories = [.outlineDisclosure()]
        }
        
        let cellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, Item> {[weak self] cell, indexPath, item in
            guard let self = self else { return }
            
            var content = cell.defaultContentConfiguration()
            content.text = item.title
            cell.contentConfiguration = content
            
            switch self.appearance {
            case .sidebar, .sidebarPlain:
                cell.accessories = []
            default:
                cell.accessories = [.disclosureIndicator()]
            }
        }
        
        dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView, cellProvider: { collectionView, indexPath, item -> UICollectionViewCell? in
            if indexPath.item == 0 {
                return collectionView.dequeueConfiguredReusableCell(using: headerRegistration, for: indexPath, item: item)
            }else {
                return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: item)
            }
        })
        
        var snapshot = NSDiffableDataSourceSnapshot<Int, Item>()
        let sections = Array(0..<5)
        snapshot.appendSections(sections)
        dataSource.apply(snapshot, animatingDifferences: false)
        
        for section in sections {
            var secSnapshot = NSDiffableDataSourceSectionSnapshot<Item>()
            let headerItem = Item(title: "Section: \(section)")
            secSnapshot.append([headerItem])
            
            let items = Array(0..<3).map { Item(title: "Item \($0)") }
            secSnapshot.append(items, to: headerItem)
            secSnapshot.expand([headerItem])
            dataSource.apply(secSnapshot, to: section)
        }
    }
}
