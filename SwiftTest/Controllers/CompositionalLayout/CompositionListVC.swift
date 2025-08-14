//
//  OutlineViewController.swift
//  SwiftTest
//
//  Created by zhangliang on 2023/2/23.
//  Copyright © 2023 zhangliang. All rights reserved.
//

import UIKit

//https://developer.apple.com/documentation/uikit/views_and_controls/collection_views/implementing_modern_collection_views
@available(iOS 14.0, *)
class CompositionListVC: BaseViewController {
    enum Section {
        case main
    }

    class OutlineItem: Hashable {
        let title: String
        let subitems: [OutlineItem]
        let outlineViewController: UIViewController.Type?

        init(title: String,
             viewController: UIViewController.Type? = nil,
             subitems: [OutlineItem] = []) {
            self.title = title
            self.subitems = subitems
            self.outlineViewController = viewController
        }
        func hash(into hasher: inout Hasher) {
            hasher.combine(identifier)
        }
        static func == (lhs: OutlineItem, rhs: OutlineItem) -> Bool {
            return lhs.identifier == rhs.identifier
        }
        private let identifier = UUID()
    }
    
    private var dataSource: UICollectionViewDiffableDataSource<Section, OutlineItem>!
    private var collectionView: UICollectionView!
    
    private lazy var menuItems: [OutlineItem] = {
        return [
            OutlineItem(title: "Compositional Layout", subitems: [
                OutlineItem(title: "Getting Started", subitems: [
                    OutlineItem(title: "Grid", viewController: CompositionCollectionController.self),
                    OutlineItem(title: "Per-Section Layout", subitems: [
                        OutlineItem(title: "Distinct Sections",
                                    viewController: DistinctSectionsViewController.self),
                        OutlineItem(title: "Adaptive Sections",
                                    viewController: AdaptiveSectionsViewController.self)
                        ])
                    ]),
                OutlineItem(title: "Advanced Layouts", subitems: [
                    OutlineItem(title: "Supplementary Views", subitems: [
                        OutlineItem(title: "Item Badges",
                                    viewController: ItemBadgeSupplementaryViewController.self),
                        OutlineItem(title: "Section Headers/Footers",
                                    viewController: SectionHeadersFootersViewController.self),
                        OutlineItem(title: "Pinned Section Headers",
                                    viewController: PinnedSectionHeaderFooterViewController.self)
                        ]),
                    OutlineItem(title: "Section Background Decoration",
                                viewController: SectionDecorationViewController.self),
                    OutlineItem(title: "Nested Groups",
                                viewController: NestedGroupsViewController.self),
                    OutlineItem(title: "Orthogonal Sections", subitems: [
                        OutlineItem(title: "Orthogonal Sections",
                                    viewController: OrthogonalScrollingViewController.self),
                        OutlineItem(title: "Orthogonal Section Behaviors",
                                    viewController: OrthogonalScrollBehaviorViewController.self)
                        ])
                    ]),
                OutlineItem(title: "Conference App", subitems: [
                    OutlineItem(title: "Videos",
                                viewController: ConferenceVideoSessionsViewController.self),
                    OutlineItem(title: "News", viewController: ConferenceNewsFeedViewController.self)
                    ])
            ]),
            OutlineItem(title: "Diffable Data Source", subitems: [
                OutlineItem(title: "Mountains Search", viewController: MountainsViewController.self),
                OutlineItem(title: "Settings: Wi-Fi", viewController: WiFiSettingsViewController.self),
                OutlineItem(title: "Insertion Sort Visualization",
                            viewController: InsertionSortViewController.self),
                OutlineItem(title: "UITableView: Editing",
                            viewController: TableViewEditingViewController.self)
                ]),
            OutlineItem(title: "Lists", subitems: [
                OutlineItem(title: "Simple List", viewController: SimpleListViewController.self),
                OutlineItem(title: "Reorderable List", viewController: ReorderableListViewController.self),
                OutlineItem(title: "List Appearances", viewController: ListAppearancesViewController.self),
                OutlineItem(title: "List with Custom Cells", viewController: CustomCellListViewController.self)
            ]),
            OutlineItem(title: "Outlines", subitems: [
                OutlineItem(title: "Emoji Explorer", viewController: EmojiExplorerViewController.self),
                OutlineItem(title: "Emoji Explorer - List", viewController: EmojiExplorerListViewController.self)
            ]),
            OutlineItem(title: "Cell Configurations", subitems: [
                OutlineItem(title: "Custom Configurations", viewController: CustomConfigurationViewController.self)
            ])
        ]
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "Modern Collection Views"
        configureCollectionView()
        configureDataSource()
    }
    
    private func configureCollectionView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: generateLayout())
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.delegate = self
        view.addSubview(collectionView)
    }
    
    private func configureDataSource() {
        let containerCell = UICollectionView.CellRegistration<UICollectionViewListCell, OutlineItem> { cell, indexPath, item in
            var contentConfig = cell.defaultContentConfiguration()
            contentConfig.text = item.title
            contentConfig.textProperties.font = .preferredFont(forTextStyle: .headline)
            cell.contentConfiguration = contentConfig
            
            let options = UICellAccessory.OutlineDisclosureOptions(style: .header)
            cell.accessories = [.outlineDisclosure(options: options)]
            cell.backgroundConfiguration = UIBackgroundConfiguration.clear()
        }
        
        let cellRegister = UICollectionView.CellRegistration<UICollectionViewListCell, OutlineItem> { cell, indexPath, item in
            var contentConfiguration = cell.defaultContentConfiguration()
            contentConfiguration.text = item.title
            cell.contentConfiguration = contentConfiguration
            cell.backgroundConfiguration = UIBackgroundConfiguration.clear()
        }
        
        dataSource = UICollectionViewDiffableDataSource<Section, OutlineItem>(collectionView: collectionView, cellProvider: {
            (collectionView, indexPath, item) -> UICollectionViewCell in
            if item.subitems.isEmpty {
                return collectionView.dequeueConfiguredReusableCell(using: cellRegister, for: indexPath, item: item)
            }else {
                return collectionView.dequeueConfiguredReusableCell(using: containerCell, for: indexPath, item: item)
            }
        })
        
        dataSource.apply(initialSnapshot(), to: .main)
    }

    private func generateLayout() -> UICollectionViewLayout {
        let listConfig = UICollectionLayoutListConfiguration(appearance: .sidebar)
        let layout = UICollectionViewCompositionalLayout.list(using: listConfig)
        return layout
    }
    
    private func initialSnapshot() -> NSDiffableDataSourceSectionSnapshot<OutlineItem> {
        var snapshot = NSDiffableDataSourceSectionSnapshot<OutlineItem>()
        
        func addItems(_ menuItems: [OutlineItem], to parent: OutlineItem?) {
            snapshot.append(menuItems, to: parent)
            
            for menuItem in menuItems where !menuItem.subitems.isEmpty {
                addItems(menuItem.subitems, to: menuItem)
            }
        }
        
        addItems(menuItems, to: nil)
        
        return snapshot
    }
}

@available(iOS 14.0, *)
extension CompositionListVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let menuItem = self.dataSource.itemIdentifier(for: indexPath) else { return }
        
        collectionView.deselectItem(at: indexPath, animated: true)
        
        if let viewController = menuItem.outlineViewController {
            navigationController?.pushViewController(viewController.init(), animated: true)
        }
    }
}
