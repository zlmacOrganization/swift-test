//
//  SearchTableViewController.swift
//  SwiftTest
//
//  Created by bfgjs on 2020/1/3.
//  Copyright © 2020 ZhangLiang. All rights reserved.
//

import UIKit

class SearchTableViewController: UITableViewController {
    
    private enum ExpressionKeys: String {
        case title
        case yearIntroduced
        case introPrice
    }
    
    private let identifier: String = "searchTableCell"
    
    private var searchController: UISearchController!
    private var resultsController: ResultsViewController!
    private var datas: [SearchModel] = [SearchModel]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.backgroundColor = UIColor.white
        navigationItem.title = "Table Search"
        
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        
        if #available(iOS 11.0, *) {
//            self.navigationController?.navigationBar.prefersLargeTitles = true;
//            self.navigationItem.largeTitleDisplayMode = .automatic;
            
            tableView.contentInsetAdjustmentBehavior = .never
        }else {
            automaticallyAdjustsScrollViewInsets = false
        }

        tableView.register(UITableViewCell.self, forCellReuseIdentifier: identifier)
        setupSearchController()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
//        navigationController?.navigationBar.isTranslucent = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
//        navigationController?.navigationBar.isTranslucent = false
    }
    
    private func setupSearchController() {
        
        let titles = ["Ginger", "Gladiolus", "Orchid", "Poinsettia", "Red Rose", "White Rose", "Tulip", "Carnation", "Sunflower", "Gardenia"]
        
        for title in titles {
            let model = SearchModel(title: title)
            datas.append(model)
        }
        
        resultsController = ResultsViewController()
        resultsController.tableView.delegate = self
        
        searchController = UISearchController(searchResultsController: resultsController)
        searchController.searchResultsUpdater = self
        searchController.searchBar.autocapitalizationType = .none
        
//        if #available(iOS 11.0, *) {
//            navigationItem.searchController = searchController
//            navigationItem.hidesSearchBarWhenScrolling = false
//        }else {
            tableView.tableHeaderView = searchController.searchBar
//        }
        
        searchController.delegate = self
        searchController.searchBar.delegate = self
        searchController.obscuresBackgroundDuringPresentation = false
        
        definesPresentationContext = true
    }

}

// MARK: - Table view data source / delegate
extension SearchTableViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return datas.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath)
        cell.textLabel?.text = datas[indexPath.row].title
        
        return cell
    }
}

// MARK: - UISearchResultsUpdating
extension SearchTableViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let searchResults = datas

        // Strip out all the leading and trailing spaces.
        let whitespaceCharacterSet = CharacterSet.whitespaces
        let strippedString =
            searchController.searchBar.text!.trimmingCharacters(in: whitespaceCharacterSet)
        let searchItems = strippedString.components(separatedBy: " ") as [String]

        // Build all the "AND" expressions for each value in searchString.
        let andMatchPredicates: [NSPredicate] = searchItems.map { searchString in
            findMatches(searchString: searchString)
        }

        // Match up the fields of the Product object.
        let finalCompoundPredicate =
            NSCompoundPredicate(andPredicateWithSubpredicates: andMatchPredicates)

        let filteredResults = searchResults.filter { finalCompoundPredicate.evaluate(with: $0) }

        // Apply the filtered results to the search results table.
        if let resultsController = searchController.searchResultsController as? ResultsViewController {
            resultsController.resultDatas = filteredResults
            resultsController.keyword = searchController.searchBar.text!
            resultsController.tableView.reloadData()
        }
    }
    
    private func findMatches(searchString: String) -> NSCompoundPredicate {
        /** Each searchString creates an OR predicate for: name, yearIntroduced, introPrice.
            Example if searchItems contains "Gladiolus 51.99 2001":
                name CONTAINS[c] "gladiolus"
                name CONTAINS[c] "gladiolus", yearIntroduced ==[c] 2001, introPrice ==[c] 51.99
                name CONTAINS[c] "ginger", yearIntroduced ==[c] 2007, introPrice ==[c] 49.98
        */
        var searchItemsPredicate = [NSPredicate]()
        
        /** Below we use NSExpression represent expressions in our predicates.
            NSPredicate is made up of smaller, atomic parts:
            two NSExpressions (a left-hand value and a right-hand value).
        */
        
        // Name field matching.
        let titleExpression = NSExpression(forKeyPath: ExpressionKeys.title.rawValue)
        let searchStringExpression = NSExpression(forConstantValue: searchString)
        
        let titleSearchComparisonPredicate =
            NSComparisonPredicate(leftExpression: titleExpression,
                                  rightExpression: searchStringExpression,
                                  modifier: .direct,
                                  type: .contains,
                                  options: [.caseInsensitive, .diacriticInsensitive])
        
        searchItemsPredicate.append(titleSearchComparisonPredicate)
        
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .none
        numberFormatter.formatterBehavior = .default
        
        // The `searchString` may fail to convert to a number.
//        if let targetNumber = numberFormatter.number(from: searchString) {
//            // Use `targetNumberExpression` in both the following predicates.
//            let targetNumberExpression = NSExpression(forConstantValue: targetNumber)
//
//            // The `yearIntroduced` field matching.
//            let yearIntroducedExpression = NSExpression(forKeyPath: ExpressionKeys.yearIntroduced.rawValue)
//            let yearIntroducedPredicate =
//                NSComparisonPredicate(leftExpression: yearIntroducedExpression,
//                                      rightExpression: targetNumberExpression,
//                                      modifier: .direct,
//                                      type: .equalTo,
//                                      options: [.caseInsensitive, .diacriticInsensitive])
//
//            searchItemsPredicate.append(yearIntroducedPredicate)
//
//            // The `price` field matching.
//            let lhs = NSExpression(forKeyPath: ExpressionKeys.introPrice.rawValue)
//
//            let finalPredicate =
//                NSComparisonPredicate(leftExpression: lhs,
//                                      rightExpression: targetNumberExpression,
//                                      modifier: .direct,
//                                      type: .equalTo,
//                                      options: [.caseInsensitive, .diacriticInsensitive])
//
//            searchItemsPredicate.append(finalPredicate)
//        }
        
        let orMatchPredicate = NSCompoundPredicate(orPredicateWithSubpredicates: searchItemsPredicate)
        
        return orMatchPredicate
    }
}

// MARK: - UISearchControllerDelegate
extension SearchTableViewController: UISearchControllerDelegate {
    
}

// MARK: - UISearchBarDelegate
extension SearchTableViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}
