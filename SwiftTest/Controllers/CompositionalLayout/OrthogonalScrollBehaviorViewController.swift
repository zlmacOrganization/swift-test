//
//  OrthogonalScrollBehaviorViewController.swift
//  SwiftTest
//
//  Created by zhangliang on 2023/2/23.
//  Copyright © 2023 zhangliang. All rights reserved.
//

import UIKit

@available(iOS 14.0, *)
class OrthogonalScrollBehaviorViewController: BaseViewController {
    static let headerElementKind = "header-element-kind"
    
    var dataSource: UICollectionViewDiffableDataSource<Int, Int>!
    var collectionView: UICollectionView!
    
    enum SectionKind: Int, CaseIterable {
        case continuous, continuousGroupLeadingBoundary, paging, groupPaging, groupPagingCentered, none
        
        func orthogonalScrollBehavior() -> UICollectionLayoutSectionOrthogonalScrollingBehavior {
            switch self {
            case .none:
                return UICollectionLayoutSectionOrthogonalScrollingBehavior.none
            case .continuous:
                return UICollectionLayoutSectionOrthogonalScrollingBehavior.continuous
            case .continuousGroupLeadingBoundary:
                return UICollectionLayoutSectionOrthogonalScrollingBehavior.continuousGroupLeadingBoundary
            case .paging:
                return UICollectionLayoutSectionOrthogonalScrollingBehavior.paging
            case .groupPaging:
                return UICollectionLayoutSectionOrthogonalScrollingBehavior.groupPaging
            case .groupPagingCentered:
                return UICollectionLayoutSectionOrthogonalScrollingBehavior.groupPagingCentered
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "Orthogonal Sections Behaviors"
        
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createLayout())
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.backgroundColor = .systemBackground
        view.addSubview(collectionView)
        collectionView.delegate = self
        
        configureDataSource()
    }
    
    private func createLayout() -> UICollectionViewLayout {
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = 20
        
        let layout = UICollectionViewCompositionalLayout(sectionProvider: { (sectionIndex, environment) -> NSCollectionLayoutSection? in
            guard let kind = SectionKind(rawValue: sectionIndex) else { return nil }
            let leadingIetm = NSCollectionLayoutItem(
                layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.65),
                                                   heightDimension: .fractionalHeight(1.0)))
            leadingIetm.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
            
            let traillingItem = NSCollectionLayoutItem(
                layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                   heightDimension: .fractionalHeight(0.3)))
            traillingItem.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
            
            let traillingGroup = NSCollectionLayoutGroup.vertical(
                layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.35),
                                                   heightDimension: .fractionalHeight(1.0)),
                subitem: traillingItem, count: 2)
            
            let orthScrolls = kind.orthogonalScrollBehavior() != .none
            let containerGroupWidth = orthScrolls ? CGFloat(0.85) : CGFloat(1.0)
            
            let containerGroup = NSCollectionLayoutGroup.horizontal(
                layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(containerGroupWidth),
                                                   heightDimension: .fractionalHeight(0.4)),
                subitems: [leadingIetm, traillingGroup])
            
            let section = NSCollectionLayoutSection(group: containerGroup)
            section.orthogonalScrollingBehavior = kind.orthogonalScrollBehavior()
            
            let header = NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                   heightDimension: .absolute(44)),
                elementKind: OrthogonalScrollBehaviorViewController.headerElementKind,
                alignment: .top)
            section.boundarySupplementaryItems = [header]
            
            return section
            
        }, configuration: config)
        
        return layout
    }

    private func configureDataSource() {
        let cellRegistration = UICollectionView.CellRegistration<TextCell, Int> { (cell, indexPath, identifier) in
            cell.label.text = "\(indexPath.section), \(indexPath.item)"
            cell.contentView.backgroundColor = .cornflowerBlue
            cell.contentView.layer.borderColor = UIColor.black.cgColor
            cell.contentView.layer.borderWidth = 1
            cell.contentView.layer.cornerRadius = 8
            cell.label.textAlignment = .center
            cell.label.font = UIFont.preferredFont(forTextStyle: .title1)
        }
        
        dataSource = UICollectionViewDiffableDataSource<Int, Int>(collectionView: collectionView) {
            (collectionView: UICollectionView, indexPath: IndexPath, identifier: Int) -> UICollectionViewCell? in
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: identifier)
        }
        
        let headerRegistration = UICollectionView.SupplementaryRegistration<TitleSupplementaryView>(elementKind: OrthogonalScrollBehaviorViewController.headerElementKind) { supplementaryView, elementKind, indexPath in
            let kind = SectionKind(rawValue: indexPath.section) ?? .none
            supplementaryView.label.text = ".\(kind)"
        }

        dataSource.supplementaryViewProvider = {(collectionView, elementKind, indexPath) -> UICollectionReusableView in
            return collectionView.dequeueConfiguredReusableSupplementary(using: headerRegistration, for: indexPath)
        }
        
        var snapshot = NSDiffableDataSourceSnapshot<Int, Int>()
        var identifierOffset = 0
        let itemsPerSection = 18
        SectionKind.allCases.forEach {
            snapshot.appendSections([$0.rawValue])
            let maxIdentifier = identifierOffset + itemsPerSection
            snapshot.appendItems(Array(identifierOffset..<maxIdentifier))
            identifierOffset += itemsPerSection
        }
        dataSource.apply(snapshot, animatingDifferences: false)
    }
}

@available(iOS 14.0, *)
extension OrthogonalScrollBehaviorViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
    }
}
