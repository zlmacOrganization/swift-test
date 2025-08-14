//
//  WiFiSettingsViewController.swift
//  SwiftTest
//
//  Created by zhangliang on 2023/2/23.
//  Copyright © 2023 zhangliang. All rights reserved.
//

import UIKit

@available(iOS 14.0, *)
class WiFiSettingsViewController: BaseViewController {
    enum Section: CaseIterable {
        case config, networks
    }

    enum ItemType {
        case wifiEnabled, currentNetwork, availableNetwork
    }
    
    struct Item: Hashable {
        let title: String
        let type: ItemType
        let network: WiFiController.Network?
        private let identifier: UUID
        
        func hash(into hasher: inout Hasher) {
            hasher.combine(self.identifier)
        }
        
        init(title: String, type: ItemType) {
            self.title = title
            self.type = type
            self.network = nil
            self.identifier = UUID()
        }
        
        init(network: WiFiController.Network) {
            self.title = network.name
            self.type = .availableNetwork
            self.network = network
            self.identifier = network.identifier
        }
        
        var isConfig: Bool {
            let configItems: [ItemType] = [.currentNetwork, .wifiEnabled]
            return configItems.contains(type)
        }
        
        var isNetwork: Bool {
            return type == .availableNetwork
        }
    }
    
    let tableView = UITableView(frame: .zero, style: .insetGrouped)
    var dataSource: UITableViewDiffableDataSource<Section, Item>! = nil
    var currentSnapshot: NSDiffableDataSourceSnapshot<Section, Item>! = nil
    var wifiController: WiFiController! = nil
    lazy var configurationItems: [Item] = {
        return [Item(title: "Wi-Fi", type: .wifiEnabled),
                Item(title: "breeno-net", type: .currentNetwork)]
    }()
    
    static let reuseIdentifier = "reuse-identifier"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "Wi-Fi"
        configTableView()
        configDataSource()
    }
    
    //MARK: -
    private func configTableView() {
        view.addSubview(tableView)
        tableView.zl_registerCell(UITableViewCell.self, identifier: WiFiSettingsViewController.reuseIdentifier)
        
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func configDataSource() {
        wifiController = WiFiController(updateHandler: { [weak self] controller in
            guard let self = self else { return }
            self.updateUI()
        })
        wifiController.scanForNetworks = true
        
        dataSource = UITableViewDiffableDataSource<Section, Item>(tableView: tableView, cellProvider: { [weak self] (tableView, indexPath, item) -> UITableViewCell? in
            guard let self = self, let wifiController = self.wifiController else { return nil }
            
            let cell = tableView.dequeueReusableCell(withIdentifier: WiFiSettingsViewController.reuseIdentifier, for: indexPath)
            var content = cell.defaultContentConfiguration()
            
            if item.isNetwork {
                content.text = item.title
                cell.accessoryType = .detailDisclosureButton
                cell.accessoryView = nil
            }else if item.isConfig {
                content.text = item.title
                if item.type == .wifiEnabled {
                    let wifiSwitch = UISwitch()
                    wifiSwitch.isOn = wifiController.wifiEnabled
                    wifiSwitch.addTarget(self, action: #selector(self.toggleWifi(_:)), for: .touchUpInside)
                    cell.accessoryView = wifiSwitch
                }else {
                    cell.accessoryType = .detailDisclosureButton
                    cell.accessoryView = nil
                }
            }else {
                fatalError("Unknown item type!")
            }
            
            cell.contentConfiguration = content
            return cell
        })
        
        dataSource.defaultRowAnimation = .fade
    }
    
    private func updateUI(_ animated: Bool = true) {
        guard let wifiController = wifiController else { return }
        let configItems = configurationItems.filter { !($0.type == .currentNetwork && !wifiController.wifiEnabled) }
        
        currentSnapshot = NSDiffableDataSourceSnapshot<Section, Item>()
        currentSnapshot.appendSections([.config])
        currentSnapshot.appendItems(configItems, toSection: .config)
        
        if wifiController.wifiEnabled {
            let sortedNetworks = wifiController.availableNetworks.sorted(by: { $0.name < $1.name })
            let networkItems = sortedNetworks.map { Item(network: $0) }
            currentSnapshot.appendSections([.networks])
            currentSnapshot.appendItems(networkItems, toSection: .networks)
        }
        
        dataSource.apply(currentSnapshot, animatingDifferences: animated)
    }
    
    @objc func toggleWifi(_ wifiSwitch: UISwitch) {
        wifiController.wifiEnabled = wifiSwitch.isOn
        updateUI()
    }
}
