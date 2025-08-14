//
//  ReminderDetailController.swift
//  SwiftTest
//
//  Created by zhangliang on 2022/6/22.
//  Copyright © 2022 zhangliang. All rights reserved.
//

import Foundation
import UIKit
import SQLite

@available(iOS 15.0, *)
class ReminderDetailController: UICollectionViewController {
//    private typealias DataSource = UICollectionViewDiffableDataSource<Int, Row>
//    private typealias Snapshot = NSDiffableDataSourceSnapshot<Int, Row>
    
    var reminder: Reminder
    private var dataSource: UICollectionViewDiffableDataSource<Int, Row>!

    init(reminder: Reminder) {
        self.reminder = reminder
        
        var listConfiguration = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
        listConfiguration.showsSeparators = false
        let layout = UICollectionViewCompositionalLayout.list(using: listConfiguration)
        
        super.init(collectionViewLayout: layout)
    }
    
    required init?(coder: NSCoder) {
        fatalError("Always initialize ReminderViewController using init(reminder:)")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let cellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, Row> {[weak self] cell, indexPath, row in
            guard let self = self else { return }
            
            var contentConfiguration = cell.defaultContentConfiguration()
            contentConfiguration.text = self.text(for: row)
            contentConfiguration.textProperties.font = UIFont.preferredFont(forTextStyle: row.textStyle)
            contentConfiguration.image = row.image
            cell.contentConfiguration = contentConfiguration
            cell.tintColor = .todayPrimaryTint
        }
        
        dataSource = UICollectionViewDiffableDataSource<Int, Row>(collectionView: collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: itemIdentifier)
        })
        
        updateSnapshot()
    }
    
    //UICollectionView.CellRegistration里不要用，会循环引用 不能释放
    private func cellRegistrationHandler(cell: UICollectionViewListCell, indexPath: IndexPath, row: Row) {
        var contentConfiguration = cell.defaultContentConfiguration()
        contentConfiguration.text = text(for: row)
        contentConfiguration.textProperties.font = UIFont.preferredFont(forTextStyle: row.textStyle)
        contentConfiguration.image = row.image
        cell.contentConfiguration = contentConfiguration
        cell.tintColor = .todayPrimaryTint
    }
    
    private func updateSnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<Int, Row>()
        snapshot.appendSections([0])
        snapshot.appendItems([.title, .date, .time, .notes], toSection: 0)
        dataSource.apply(snapshot)
    }
    
    private func text(for row: Row) -> String? {
        switch row {
            case .date: return reminder.dueDate.dayText
            case .notes: return reminder.notes
            case .time: return reminder.dueDate.formatted(date: .omitted, time: .shortened)
            case .title: return reminder.title
        }
    }
    
}

@available(iOS 15.0, *)
extension ReminderDetailController {
    enum Row: Hashable {
        case date
        case notes
        case time
        case title
        
        var imageName: String? {
            switch self {
                case .date: return "calendar.circle"
                case .notes: return "square.and.pencil"
                case .time: return "clock"
                default: return nil
            }
        }
        
        var image: UIImage? {
            guard let imageName = imageName else { return nil }
            let configuration = UIImage.SymbolConfiguration(textStyle: .headline)
            return UIImage(systemName: imageName, withConfiguration: configuration)
        }
        
        var textStyle: UIFont.TextStyle {
            switch self {
                case .title: return .headline
                default: return .subheadline
            }
        }
    }
}
