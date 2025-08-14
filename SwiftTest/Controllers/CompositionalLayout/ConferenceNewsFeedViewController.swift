//
//  ConferenceNewsFeedViewController.swift
//  SwiftTest
//
//  Created by zhangliang on 2023/2/23.
//  Copyright © 2023 zhangliang. All rights reserved.
//

import UIKit

@available(iOS 14.0, *)
class ConferenceNewsFeedViewController: BaseViewController {
    enum Section {
        case main
    }

    var collectionView: UICollectionView!
    var dataSource: UICollectionViewDiffableDataSource<Section, ConferenceNewsController.NewsFeedItem>!

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "Conference News Feed"
        configureHierarchy()
        configureDataSource()
    }
    
    func configureHierarchy() {
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(collectionView)
        collectionView.backgroundColor = .systemBackground
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            collectionView.topAnchor.constraint(equalTo: view.topAnchor)
        ])
    }
    
    func createLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .estimated(100))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: itemSize, subitem: item, count: 1)
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 10
        section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
        
        return UICollectionViewCompositionalLayout(section: section)
    }

    func configureDataSource() {
        let newsController = ConferenceNewsController()
        
        let cellRegistration = UICollectionView.CellRegistration<ConferenceNewsFeedCell, ConferenceNewsController.NewsFeedItem> { cell, indexPath, newsItem in
            cell.titleLabel.text = newsItem.title
            cell.bodyLabel.text = newsItem.body
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .short
            cell.dateLabel.text = dateFormatter.string(from: newsItem.date)
            cell.showsSeparator = indexPath.item != newsController.items.count - 1
        }
        
        dataSource = UICollectionViewDiffableDataSource<Section, ConferenceNewsController.NewsFeedItem>(collectionView: collectionView, cellProvider: { (collectionView, indexPath, item) -> UICollectionViewCell? in
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: item)
        })
        
        var snapshot = NSDiffableDataSourceSnapshot<Section, ConferenceNewsController.NewsFeedItem>()
        snapshot.appendSections([.main])
        snapshot.appendItems(newsController.items)
        dataSource.apply(snapshot)
    }
}

@available(iOS 14.0, *)
extension ConferenceNewsFeedViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
    }
}
