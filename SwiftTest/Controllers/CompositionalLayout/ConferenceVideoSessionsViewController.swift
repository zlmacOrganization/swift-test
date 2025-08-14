//
//  ConferenceVideoSessionsViewController.swift
//  SwiftTest
//
//  Created by zhangliang on 2023/2/23.
//  Copyright © 2023 zhangliang. All rights reserved.
//

import UIKit

@available(iOS 14.0, *)
class ConferenceVideoSessionsViewController: BaseViewController {
    static let titleElementKind = "title-element-kind"
    
    let videosController = ConferenceVideoController()
    var collectionView: UICollectionView!
    var dataSource: UICollectionViewDiffableDataSource
        <ConferenceVideoController.VideoCollection, ConferenceVideoController.Video>!
    var currentSnapshot: NSDiffableDataSourceSnapshot
        <ConferenceVideoController.VideoCollection, ConferenceVideoController.Video>!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "Conference Videos"
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .systemBackground
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ])
        
        configureDataSource()
    }
    
    private func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { (sectionIndex, environment) -> NSCollectionLayoutSection? in
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            
            let groupWidth = CGFloat(environment.container.effectiveContentSize.width > 500 ? 0.425 : 0.85)
            let group = NSCollectionLayoutGroup.horizontal(
                layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(groupWidth), heightDimension: .absolute(250)),
                subitems: [item])
            
            let section = NSCollectionLayoutSection(group: group)
            section.orthogonalScrollingBehavior = .continuous
            section.interGroupSpacing = 20
            section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20)
            
            let titleSupplementary = NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                   heightDimension: .estimated(44)),
                elementKind: ConferenceVideoSessionsViewController.titleElementKind,
                alignment: .top)
            
            section.boundarySupplementaryItems = [titleSupplementary]
            
            return section
        }
        
        return layout
    }
    
    private func configureDataSource() {
        let cellRegistration = UICollectionView.CellRegistration<ConferenceVideoCell, ConferenceVideoController.Video> { (cell, indexPath, video) in
            cell.titleLabel.text = video.title
            cell.categoryLabel.text = video.category
        }
        
        dataSource = UICollectionViewDiffableDataSource<ConferenceVideoController.VideoCollection, ConferenceVideoController.Video>(collectionView: collectionView, cellProvider: { (collectionView, indexPath, video) -> UICollectionViewCell? in
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: video)
        })
        
        let supplementaryRegistration = UICollectionView.SupplementaryRegistration<TitleSupplementaryView>(elementKind: ConferenceVideoSessionsViewController.titleElementKind) {[weak self] supplementaryView, elementKind, indexPath in
            if let snapshot = self?.currentSnapshot {
                let video = snapshot.sectionIdentifiers[indexPath.section]
                supplementaryView.label.text = video.title
            }
        }
        
        dataSource.supplementaryViewProvider = { [weak self] (view, kind, indexPath) in
            return self?.collectionView.dequeueConfiguredReusableSupplementary(using: supplementaryRegistration, for: indexPath)
        }
        
        currentSnapshot = NSDiffableDataSourceSnapshot
        <ConferenceVideoController.VideoCollection, ConferenceVideoController.Video>()
        videosController.collections.forEach {
            currentSnapshot.appendSections([$0])
            currentSnapshot.appendItems($0.videos)
        }
        
        dataSource.apply(currentSnapshot, animatingDifferences: false)
    }
}

@available(iOS 14.0, *)
extension ConferenceVideoSessionsViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
    }
}
