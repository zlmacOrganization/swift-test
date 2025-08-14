//
//  TableDragViewController.swift
//  SwiftTest
//
//  Created by ZhangLiang on 2017/12/17.
//  Copyright © 2017年 ZhangLiang. All rights reserved.
//

import UIKit

private let reuseIdentifier = "DragAndDropCell"

class TableDragViewController: UIViewController, UITableViewDragDelegate, UITableViewDropDelegate{
    
    var dragIndexPath: IndexPath?
    
    //    var collectionView: UICollectionView?
    fileprivate lazy var tableView: UITableView = {
        
        let table = UITableView(frame: CGRect(x: 0, y: 0, width: kMainScreenWidth, height: kMainScreenHeight - statusBarHeight() - kNaviBarHeight))
        table.register(DragTableViewCell.classForCoder(), forCellReuseIdentifier: reuseIdentifier)
        table.backgroundColor = UIColor.white
        table.delegate = self
        table.dataSource = self
        if #available(iOS 11.0, *) {
            table.dragDelegate = self
            table.dropDelegate = self
            table.dragInteractionEnabled = true
            table.isSpringLoaded =  true
        }
        
        return table
    }()
    
    fileprivate lazy var dataSource: [UIImage] = {
        var dataArray = [UIImage]()
        for i in 0...5 {
            var nameString = "image\(i)"
            let image = UIImage(named: nameString)
            dataArray.append(image!)
        }
        return dataArray
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        
        view.addSubview(tableView)
        
        if #available(iOS 14.0, *) {
            let share = UIAction(title: "Share", image: UIImage(systemName: "square.and.arrow.up")) { (action) in
                CommonFunction.showBundleID(self)
            }
            
            let file = UIAction(title: "open file", image: UIImage(systemName: "folder")) { (action) in
                let documentsUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!

                if let sharedUrl = URL(string: "shareddocuments://\(documentsUrl.path)") {
                    if UIApplication.shared.canOpenURL(sharedUrl) {
                        UIApplication.shared.open(sharedUrl, options: [:])
                    }
                }
            }
            
            let detect = UIAction(title: "detect", image: UIImage(systemName: "ellipsis.circle")) { (action) in
                self.dataDetect()
            }
            
            let menu = UIMenu(title: "list", children: [share, file, detect])
            navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "list.number"), menu: menu)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc private func rightItemClick() {
        
    }
    
    private func dataDetect() {
        let exampleText = "this is a string has link https://www.baidu.com and phone number 13404040404"
        
        do {
            let detector = try NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue | NSTextCheckingResult.CheckingType.phoneNumber.rawValue)
            
            let matchs = detector.matches(in: exampleText, options: [], range: NSRange(location: 0, length: exampleText.utf16.count))
            print("matchs: \(matchs)")
            
            detector.enumerateMatches(in: exampleText, range: NSRange(location: 0, length: exampleText.utf16.count)) { result, flags, has in
                
                switch result?.resultType {
                case NSTextCheckingResult.CheckingType.address:
                    guard let range = result?.range else { return }
                    print("Found email address: \(exampleText[range])")
                case NSTextCheckingResult.CheckingType.phoneNumber:
                    guard let _ = result?.range else { return }
                    print("Found phone number: \(result?.phoneNumber ?? "")")
                case NSTextCheckingResult.CheckingType.link:
                    guard let _ = result?.range else { return }
                    print("Found link: \(result?.url?.absoluteString ?? "")")
                default:
                    break
                }
            }
        } catch {
            
        }
    }
    
    //MARK: - UITableViewDragDelegate
    @available(iOS 11.0, *)
    func tableView(_ tableView: UITableView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        let itemProvider = NSItemProvider(object: self.dataSource[indexPath.row])
        let item = UIDragItem(itemProvider: itemProvider)
        self.dragIndexPath = indexPath
        return [item]
    }
    
    @available(iOS 11.0, *)
    func tableView(_ tableView: UITableView, itemsForAddingTo session: UIDragSession, at indexPath: IndexPath, point: CGPoint) -> [UIDragItem] {
        let itemProvider = NSItemProvider(object: self.dataSource[indexPath.row])
        let item = UIDragItem(itemProvider: itemProvider)
        return [item]
    }
    
    @available(iOS 11.0, *)
    func tableView(_ tableView: UITableView, dragPreviewParametersForRowAt indexPath: IndexPath) -> UIDragPreviewParameters? {
        let parameters = UIDragPreviewParameters()
        let rect = CGRect(x: 0, y: 0, width: kMainScreenWidth, height: drapTableHeight)
        parameters.visiblePath = UIBezierPath(roundedRect: rect, cornerRadius: 15)
        return parameters
    }
    
    //MARK: - UITableViewDropDelegate
    @available(iOS 11.0, *)
    func tableView(_ tableView: UITableView, performDropWith coordinator: UITableViewDropCoordinator) {
        let destinationIndexPath = coordinator.destinationIndexPath
        if self.dragIndexPath?.section == destinationIndexPath?.section && self.dragIndexPath?.row == destinationIndexPath?.row {
            return
        }
        
        tableView.performBatchUpdates({
            let image = self.dataSource[(self.dragIndexPath?.row)!]
            self.dataSource.remove(at: (self.dragIndexPath?.row)!)
            self.dataSource.insert(image, at: (destinationIndexPath?.row)!)
            
            tableView.deleteRows(at: [self.dragIndexPath!], with: .fade)
            tableView.insertRows(at: [destinationIndexPath!], with: .none)
        }) { (finished: Bool) in
            
        }
    }
    
    @available(iOS 11.0, *)
    func tableView(_ tableView: UITableView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UITableViewDropProposal {
        let dropProposal: UITableViewDropProposal
        if (session.localDragSession != nil) {
            dropProposal = UITableViewDropProposal(operation: .move, intent: .insertAtDestinationIndexPath)
        }else{
            dropProposal = UITableViewDropProposal(operation: .copy, intent: .insertAtDestinationIndexPath)
        }
        
        return dropProposal
    }
}

extension TableDragViewController: UITableViewDelegate, UITableViewDataSource {
    // MARK: - UITableViewDelegate, UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataSource.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return drapTableHeight
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! DragTableViewCell
        cell.targetImageView?.image = self.dataSource[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let transparentVC = TransparentNavController()
        navigationController?.pushViewController(transparentVC, animated: true)
    }
}
