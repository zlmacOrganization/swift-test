//
//  TestCollectionViewController.swift
//  SwiftTest
//
//  Created by ZhangLiang on 16/12/13.
//  Copyright © 2016年 ZhangLiang. All rights reserved.
//

import UIKit

private let reuseIdentifier = "moveCollectionCell"

class TestCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {

    private var longPressedEnabled = false
    let allSectionColors = [UIColor.red, UIColor.green, UIColor.blue]
    
    override init(collectionViewLayout layout: UICollectionViewLayout) {
        super.init(collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor.white
        collectionView.register(ShakeCollectionCell.self, forCellWithReuseIdentifier: reuseIdentifier)
    }
    
    convenience required init?(coder aDecoder: NSCoder) {
        let flowLayout = SectionBgFlowLayout()
        flowLayout.minimumLineSpacing = 20
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.itemSize = CGSize(width: 80, height: 80)
        flowLayout.scrollDirection = .vertical
        flowLayout.sectionInset = UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20)
        
        self.init(collectionViewLayout: flowLayout)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.showsVerticalScrollIndicator = false
        
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(collectionLongPress(_:)))
        collectionView.isUserInteractionEnabled = true
        collectionView.addGestureRecognizer(longPress)
        
        let rightButton = CommonFunction.createButton(frame: CGRect(x: 0, y: 0, width: 60, height: 40), title: "Shake", textColor: UIColor.purple, font: UIFont.systemFont(ofSize: 16), imageName: nil, isBackgroundImage: false, target: self, action: #selector(doneButtonClick))
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightButton)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - action
    
    @objc private func collectionLongPress(_ gesture: UIGestureRecognizer) {
        switch gesture.state {
        case .began:
            guard let selectedIndexPath = collectionView.indexPathForItem(at: gesture.location(in: collectionView)) else {
                return
            }
            
            collectionView.beginInteractiveMovementForItem(at: selectedIndexPath)
            
        case .changed:
            collectionView.updateInteractiveMovementTargetPosition(gesture.location(in: gesture.view))
            
        case .ended:
            longPressedEnabled = true
            collectionView.endInteractiveMovement()
            collectionView.reloadData()
        default:
            collectionView.cancelInteractiveMovement()
        }
    }
    
    @objc private func doneButtonClick() {
        longPressedEnabled.toggle()
        collectionView.reloadData()
    }
    
    // MARK: - UICollectionViewDataSource
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return allSectionColors.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return Int.random(in: 1...7) + 10
        return 14
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! ShakeCollectionCell
        
        cell.backgroundColor = allSectionColors[indexPath.section]
        
        if longPressedEnabled {
            cell.startAnimate()
        }else {
            cell.stopAnimate()
        }
        
        return cell
    }

    // MARK: - UICollectionViewDelegate

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedCell = collectionView.cellForItem(at: indexPath)! as UICollectionViewCell
        
        UIView.animate(withDuration: 1.0) {
            selectedCell.alpha = 0
        } completion: { finished in
            UIView.animate(withDuration: 0.3) {
                selectedCell.alpha = 1
            }
        }
    }

    override func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        let selectedCell = collectionView.cellForItem(at: indexPath)! as UICollectionViewCell
        UIView.animate(withDuration: 1.0, animations: {
            selectedCell.transform = CGAffineTransform(scaleX: 3, y: 3)
        })
    }

    override func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
        let selectedCell = collectionView.cellForItem(at: indexPath)! as UICollectionViewCell
        UIView.animate(withDuration: 1.0, animations: {
            selectedCell.transform = CGAffineTransform.identity
        })
    }

    override func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        
    }
    
    //MARK: -
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        let numberOfItems = collectionView.numberOfItems(inSection: section)
        return numberOfItems > 0 ? UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10) :
            UIEdgeInsets.zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: kMainScreenWidth, height: 15)
    }
}

extension TestCollectionViewController: SectionBgCollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, backgroundColorForSectionAt section: Int) -> UIColor {
        
        if section == 0 {
            return UIColor.lightGray
        }else if section == 1 {
            return UIColor.purple
        }else {
            return UIColor.red
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, cornerRadiusForSectionAt section: Int) -> CGFloat {
        return 12
    }
}
