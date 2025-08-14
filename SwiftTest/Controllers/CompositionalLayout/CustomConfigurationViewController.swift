//
//  CustomConfigurationViewController.swift
//  SwiftTest
//
//  Created by zhangliang on 2023/2/23.
//  Copyright © 2023 zhangliang. All rights reserved.
//

import UIKit

@available(iOS 14.0, *)
class CustomConfigurationViewController: BaseViewController {
    private var dataSource: UICollectionViewDiffableDataSource<Section, Item>!
    private var collectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "Custom Configurations"
        
        configureViews()
        configureDataSource()
    }

    private func configureViews() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createLayout())
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.backgroundColor = .systemBackground
        view.addSubview(collectionView)
    }
    
    private func createLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .estimated(44), heightDimension: .estimated(44))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(44))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        group.interItemSpacing = .flexible(10)
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 10
        section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
        
        return UICollectionViewCompositionalLayout(section: section)
    }
    
    private func configureDataSource() {
        let cellRegistration = UICollectionView.CellRegistration<CustomConfigurationCell, Item> { cell, indexPath, item in
            cell.image = item.image
        }
        
        dataSource = UICollectionViewDiffableDataSource<Section, Item>(collectionView: collectionView, cellProvider: { collectionView, indexPath, item in
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: item)
        })
        
        var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
        snapshot.appendSections([.main])
        snapshot.appendItems(Item.all)
        dataSource.apply(snapshot, animatingDifferences: false)
    }
}

private enum Section: Hashable {
    case main
}

@available(iOS 14.0, *)
private struct Item: Hashable {
    let image: UIImage?
    init(imageName: String) {
        self.image = UIImage(systemName: imageName)
    }
    private let identifier = UUID()
    
    static let all = Array(repeating: [
        "trash", "folder", "paperplane", "book", "tag", "camera", "pin",
        "lock.shield", "cube.box", "gift", "eyeglasses", "lightbulb"
    ], count: 25).flatMap { $0 }.shuffled().map { Item(imageName: $0) }
}

@available(iOS 14.0, *)
class CustomConfigurationCell: UICollectionViewCell {
    var image: UIImage? {
        didSet {
            setNeedsUpdateConfiguration()
        }
    }
    
    override func updateConfiguration(using state: UICellConfigurationState) {
        backgroundConfiguration = CustomBackgroundConfiguration.configuration(for: state)
        
        var content = CustomContentConfiguration().updated(for: state)
        content.image = image
        contentConfiguration = content
    }
}

@available(iOS 14.0, *)
struct CustomBackgroundConfiguration {
    static func configuration(for state: UICellConfigurationState) -> UIBackgroundConfiguration {
        var background = UIBackgroundConfiguration.clear()
        background.cornerRadius = 10
        if state.isHighlighted || state.isSelected {
            // Set nil to use the inherited tint color of the cell when highlighted or selected
            background.backgroundColor = nil
            
            if state.isHighlighted {
                // Reduce the alpha of the tint color to 30% when highlighted
                background.backgroundColorTransformer = .init { $0.withAlphaComponent(0.3) }
            }
        }
        return background
    }
}

@available(iOS 14.0, *)
struct CustomContentConfiguration: UIContentConfiguration, Hashable {
    var image: UIImage? = nil
    var tintColor: UIColor? = nil
    
    func makeContentView() -> UIView & UIContentView {
        return CustomContentView(configuration: self)
    }
    
    func updated(for state: UIConfigurationState) -> Self {
        guard let state = state as? UICellConfigurationState else { return self }
        var updatedConfig = self
        if state.isSelected || state.isHighlighted {
            updatedConfig.tintColor = .white
        }
        return updatedConfig
    }
}

@available(iOS 14.0, *)
class CustomContentView: UIView, UIContentView {
    init(configuration: CustomContentConfiguration) {
        super.init(frame: .zero)
        setupInternalViews()
        apply(configuration: configuration)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var configuration: UIContentConfiguration {
        get { appliedConfiguration }
        set {
            guard let newConfig = newValue as? CustomContentConfiguration else { return }
            apply(configuration: newConfig)
        }
    }
    
    private let imageView = UIImageView()
    
    private func setupInternalViews() {
        addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor),
            imageView.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: layoutMarginsGuide.bottomAnchor)
        ])
        imageView.preferredSymbolConfiguration = .init(font: .preferredFont(forTextStyle: .body), scale: .large)
        imageView.isHidden = true
    }
    
    private var appliedConfiguration: CustomContentConfiguration!
    
    private func apply(configuration: CustomContentConfiguration) {
        guard appliedConfiguration != configuration else { return }
        appliedConfiguration = configuration
        
        imageView.isHidden = configuration.image == nil
        imageView.image = configuration.image
        imageView.tintColor = configuration.tintColor
    }
}
