//
//  ChatListViewController.swift
//  SwiftTest
//
//  Created by zhangliang on 2020/9/24.
//  Copyright © 2020 zhangliang. All rights reserved.
//

import UIKit

@available(iOS 13.0, *)
class ChatListViewController: BaseViewController {
    
    private let tableView = UITableView(frame: .zero, style: .insetGrouped)
    private var collectionView: UICollectionView!

    private var dataSource: UITableViewDiffableDataSource<ChatSection, ChatMessage>?
    private var currentSnapshot = NSDiffableDataSourceSnapshot<ChatSection, ChatMessage>()
    private var chatController = ChatViewController()
    private var hodler: Any?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "ChatRoom"
        configureTableView()
        configureDataSource()
        updateUI()
    }
    
    //MARK: - tableView
    private func configureTableView() {
        view.addSubview(tableView)
//        tableView.translatesAutoresizingMaskIntoConstraints = false
//        NSLayoutConstraint.activate([
//            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
//            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
//            tableView.topAnchor.constraint(equalTo: view.topAnchor),
//            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
//            ])
        
        tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        tableView.zl_registerCell(UITableViewCell.self)
    }
    
    private func configureDataSource() {
        
        hodler = chatController.didChange.sink { [weak self] value in
            guard let self = self else { return }
            self.updateUI()
        }
        
        self.dataSource = UITableViewDiffableDataSource
            <ChatSection, ChatMessage>(tableView: tableView) {
                (tableView: UITableView, indexPath: IndexPath, item: ChatMessage) -> UITableViewCell? in
                
            let cell = tableView.zl_dequeueReusableCell(UITableViewCell.self, indexPath: indexPath)
                let name = item.isME ? item.userName : "\(item.userName)\(indexPath.row)"
                cell.textLabel?.text = "\(name): \(item.msgContent)"
                cell.textLabel?.numberOfLines = 0
                return cell
        }
        
        self.dataSource?.defaultRowAnimation = .fade
    }
    
    private func updateUI(animated: Bool = true) {
        
        currentSnapshot = NSDiffableDataSourceSnapshot<ChatSection, ChatMessage>()
        
        let items = chatController.displayMsg
        currentSnapshot.appendSections([.socket])
        currentSnapshot.appendItems(items, toSection: .socket)
        
        self.dataSource?.apply(currentSnapshot, animatingDifferences: animated)
        self.tableView.scrollToRow(at: IndexPath(row: currentSnapshot.numberOfItems(inSection: .socket) - 1, section: 0), at: .bottom, animated: true)
    }

    //MARK: - collectionView
    private func configureCollectionView() {
        
    }
}
