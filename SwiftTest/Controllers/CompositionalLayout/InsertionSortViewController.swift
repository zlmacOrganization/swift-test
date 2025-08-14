//
//  InsertionSortViewController.swift
//  SwiftTest
//
//  Created by zhangliang on 2023/2/23.
//  Copyright © 2023 zhangliang. All rights reserved.
//

import UIKit

@available(iOS 14.0, *)
class InsertionSortViewController: BaseViewController {
    static let nodeSize = CGSize(width: 16, height: 34)
    
    var collectionView: UICollectionView!
    var dataSource: UICollectionViewDiffableDataSource
        <InsertionSortArray, InsertionSortArray.SortNode>!
    
    var isSorting = false
    var isSorted = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavItem()
        
        configureViews()
        configureDataSource()
    }
    
    func configureNavItem() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: isSorting ? "Stop" : "Sort",
                                                            style: .plain, target: self,
                                                            action: #selector(toggleSort))
    }
    
    private func configureViews() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout())
        collectionView.backgroundColor = .black
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(collectionView)
    }
    
    private func layout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { sectionIndex, environment -> NSCollectionLayoutSection? in
            let contentSize = environment.container.effectiveContentSize
            let columns = Int(contentSize.width / InsertionSortViewController.nodeSize.width)
            let rowHeight = InsertionSortViewController.nodeSize.height
            let size = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
            let item = NSCollectionLayoutItem(layoutSize: size)
            
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(rowHeight))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: columns)
            
            return NSCollectionLayoutSection(group: group)
        }
        
        return layout
    }

    private func configureDataSource() {
        let cellRegistration = UICollectionView.CellRegistration<UICollectionViewCell, InsertionSortArray.SortNode> { cell, indexPath, sortNode in
            cell.backgroundColor = sortNode.color
        }
        
        dataSource = UICollectionViewDiffableDataSource<InsertionSortArray, InsertionSortArray.SortNode>(collectionView: collectionView, cellProvider: { collectionView, indexPath, sortNode -> UICollectionViewCell? in
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: sortNode)
        })
        
        let snapshot = randomSanpshot(for: collectionView.bounds)
        dataSource.apply(snapshot)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        if dataSource != nil {
            let snapshot = randomSanpshot(for: collectionView.bounds)
            dataSource.apply(snapshot)
        }
    }
    
    func randomSanpshot(for bounds: CGRect) -> NSDiffableDataSourceSnapshot<InsertionSortArray, InsertionSortArray.SortNode> {
        var snapshot = NSDiffableDataSourceSnapshot<InsertionSortArray, InsertionSortArray.SortNode>()
        let rowCount = rows(for: bounds)
        let columnCount = columns(for: bounds)
        
        for _ in 0..<rowCount {
            let section = InsertionSortArray(count: columnCount)
            snapshot.appendSections([section])
            snapshot.appendItems(section.values)
        }
        
        return snapshot
    }
    
    func rows(for bounds: CGRect) -> Int {
        return Int(bounds.height / InsertionSortViewController.nodeSize.height)
    }
    
    func columns(for bounds: CGRect) -> Int {
        return Int(bounds.width / InsertionSortViewController.nodeSize.width)
    }
    
    @objc func toggleSort() {
        isSorting.toggle()
        
        if isSorting {
            performSortStep()
        }
        configureNavItem()
    }
    
    private func performSortStep() {
        if !isSorting {
            return
        }
        
        var sectionCountNeedingSort = 0

        // Get the current state of the UI from the data source.
        var updatedSnapshot = dataSource.snapshot()

        // For each section, if needed, step through and perform the next sorting step.
        updatedSnapshot.sectionIdentifiers.forEach {
            let section = $0
            if !section.isSorted {

                // Step the sort algorithm.
                section.sortNext()
                let items = section.values

                // Replace the items for this section with the newly sorted items.
                updatedSnapshot.deleteItems(items)
                updatedSnapshot.appendItems(items, toSection: section)

                sectionCountNeedingSort += 1
            }
        }

        var shouldReset = false
        var delay = 100
        if sectionCountNeedingSort > 0 {
            dataSource.apply(updatedSnapshot)
        } else {
            delay = 300
            shouldReset = true
        }
        
        let bounds = collectionView.bounds
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(delay)) {
            if shouldReset {
                let snapshot = self.randomSanpshot(for: bounds)
                self.dataSource.apply(snapshot, animatingDifferences: false)
            }
            self.performSortStep()
        }
    }
}


class InsertionSortArray: Hashable {
    struct SortNode: Hashable {
        let value: Int
        let color: UIColor

        init(value: Int, maxValue: Int) {
            self.value = value
            let hue = CGFloat(value) / CGFloat(maxValue)
            self.color = UIColor(hue: hue, saturation: 1.0, brightness: 1.0, alpha: 1.0)
        }
        
        private let identifier = UUID()
        func hash(into hasher: inout Hasher) {
            hasher.combine(identifier)
        }
        
        static func == (lhs: SortNode, rhs: SortNode) -> Bool {
            return lhs.identifier == rhs.identifier
        }
    }
    
    var values: [SortNode] {
        return nodes
    }
    
    var isSorted: Bool {
        return isSortedInternal
    }
    
    func sortNext() {
        performNextSortStep()
    }
    
    init(count: Int) {
        nodes = (0..<count).map { SortNode(value: $0, maxValue: count) }.shuffled()
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(identifier)
    }
    
    static func == (lhs: InsertionSortArray, rhs: InsertionSortArray) -> Bool {
        return lhs.identifier == rhs.identifier
    }
    
    private var identifier = UUID()
    private var currentIndex = 1
    private var isSortedInternal = false
    private var nodes: [SortNode]
}

extension InsertionSortArray {
    fileprivate func performNextSortStep() {
        if isSortedInternal {
            return
        }
        
        if nodes.count == 1 {
            isSortedInternal = true
            return
        }

        var index = currentIndex
        let currentNode = nodes[index]
        index -= 1
        while index >= 0 && currentNode.value < nodes[index].value {
            let tmp = nodes[index]
            nodes[index] = currentNode
            nodes[index + 1] = tmp
            index -= 1
        }
        currentIndex += 1
        if currentIndex >= nodes.count {
            isSortedInternal = true
        }
    }
}
