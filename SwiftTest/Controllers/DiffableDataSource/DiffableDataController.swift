//
//  DiffableDataController.swift
//  SwiftTest
//
//  Created by zhangliang on 2020/9/27.
//  Copyright © 2020 zhangliang. All rights reserved.
//

import UIKit
import CoreData

@available(iOS 13.0, *)
class DiffableDataController: BaseViewController {
    
    enum Section: CaseIterable {
        case main
    }

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var tableButton: UIButton!
    @IBOutlet weak var collectionButton: UIButton!
    @IBOutlet weak var searchBar: UISearchBar!
    
    private let countryNames = ["Afghanistan",
    "Albania",
    "Algeria",
    "Andorra",
    "Angola",
    "Antigua and Barbuda",
    "Argentina",
    "Armenia",
    "Australia",
    "Austria",
    "Azerbaijan",
    "Bahamas",
    "Bahrain",
    "Bangladesh",
    "Barbados",
    "Belarus"]
    
    private var countries: [Country] = []
    private  var collectionCountries: [Country] = []
    private var tableSource: UITableViewDiffableDataSource<Section, Country>!
    private var collectionSource: UICollectionViewDiffableDataSource<Section, Country>!
    
    private var isTableViewShow: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableButton.isSelected = true
        setupTableDataSource()
        setupCollectionDataSource()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        performSearch(searchQuery: searchBar.text)
    }
    
    private func setupTableDataSource() {
        tableView.zl_registerCell(UITableViewCell.self)
        
        for name in countryNames {
            countries.append(Country(name: name))
        }

        tableSource = UITableViewDiffableDataSource
            <Section, Country>(tableView: tableView) {
                (tableView: UITableView, indexPath: IndexPath,
                country: Country) -> UITableViewCell? in
            let cell = tableView.zl_dequeueReusableCell(UITableViewCell.self, indexPath: indexPath)
                cell.textLabel?.text = country.name
                return cell
        }
        tableSource.defaultRowAnimation = .fade
    }
    
    private func setupCollectionDataSource() {
//        if #available(iOS 14.0, *) {
//            let config = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
//            collectionView.collectionViewLayout = UICollectionViewCompositionalLayout.list(using: config)
//        }
        
        collectionView.zl_registerCell(DiffableCollectionViewCell.self)
        
        for name in countryNames {
            collectionCountries.append(Country(name: name))
        }

        collectionSource = UICollectionViewDiffableDataSource
            <Section, Country>(collectionView: collectionView) {
                (collectionView: UICollectionView, indexPath: IndexPath,
                country: Country) -> UICollectionViewCell? in
            let cell = collectionView.zl_dequeueReusableCell(DiffableCollectionViewCell.self, indexPath: indexPath)
            cell.desLabel.text = country.name
            return cell
        }

        if let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
//            flowLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
            flowLayout.itemSize = CGSize(width: (kMainScreenWidth/2.0) - (2 * 16.0), height: 50)
        }
    }
    
    private func performSearch(searchQuery: String?) {
        let filteredCountries: [Country]
        if let searchQuery = searchQuery, !searchQuery.isEmpty {
            filteredCountries = countries.filter { $0.contains(query: searchQuery) }
        } else {
            filteredCountries = countries
        }
        var snapshot = NSDiffableDataSourceSnapshot<Section, Country>()
        snapshot.appendSections([.main])
        snapshot.appendItems(filteredCountries, toSection: .main)
        
        if isTableViewShow {
            tableSource.apply(snapshot, animatingDifferences: true)
        }else {
            collectionSource.apply(snapshot, animatingDifferences: true)
        }
    }

    //MARK: - action
    @IBAction func showTableView(_ button: UIButton) {
        tableButton.isSelected = true
        collectionButton.isSelected = false
        
        isTableViewShow = true
        tableView.isHidden = false
        collectionView.isHidden = true
    }
    
    @IBAction func showCollectionView(_ button: UIButton) {
        tableButton.isSelected = false
        collectionButton.isSelected = true
        
        isTableViewShow = false
        tableView.isHidden = true
        performSearch(searchQuery: searchBar.text)
        collectionView.isHidden = false
    }
}

@available(iOS 13.0, *)
extension DiffableDataController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        performSearch(searchQuery: searchText)
    }
}

@available(iOS 13.0, *)
extension DiffableDataController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        view.endEditing(true)
        
        let country = tableSource.itemIdentifier(for: indexPath)
        print("Selected country \(country?.name ?? "")")
        
        let sortVC = SortViewController()
        zl_pushViewController(sortVC)
    }
}

@available(iOS 13.0, *)
extension DiffableDataController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        view.endEditing(true)
        
        let country = collectionSource.itemIdentifier(for: indexPath)
        print("Selected country \(country?.name ?? "")")
    }
}

@available(iOS 13.0, *)
extension DiffableDataController: NSFetchedResultsControllerDelegate {
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChangeContentWith snapshot: NSDiffableDataSourceSnapshotReference) {
        guard let dataSource = collectionView.dataSource as? UICollectionViewDiffableDataSourceReference else {
            fatalError("The data source has not implemented snapshot support while it should")
        }
        dataSource.applySnapshot(snapshot, animatingDifferences: true)
    }
}

struct Country: Hashable {
    let name: String
    let identifier = UUID()

    func hash(into hasher: inout Hasher) {
        hasher.combine(identifier)
    }

    static func ==(lhs: Country, rhs: Country) -> Bool {
        return lhs.identifier == rhs.identifier
    }

    func contains(query: String?) -> Bool {
        guard let query = query else { return true }
        guard !query.isEmpty else { return true }
        let lowerCasedQuery = query.lowercased()
        return name.lowercased().contains(lowerCasedQuery)
    }
}


class DiffableCollectionViewCell: UICollectionViewCell {
    var desLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureViews()
        contentView.backgroundColor = UIColor.white
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureViews() {
        desLabel = CommonFunction.createLabel(font: UIFont.systemFont(ofSize: 15), text: "", textColor: UIColor.darkGray, textAlignment: .left)
        contentView.addSubview(desLabel)
        
        desLabel.snp.makeConstraints { (make) in
            make.left.equalTo(12)
            make.centerY.equalToSuperview()
        }
    }
}
