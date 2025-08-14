//
//  PopoverTableViewController.swift
//  SwiftTest
//
//  Created by ZhangLiang on 16/12/7.
//  Copyright © 2016年 ZhangLiang. All rights reserved.
//

import UIKit
import Compression

struct FoldModel {
    var isFolding: Bool
}

fileprivate enum AnimateDirection: Int {
    case upToDown
    case leftToRight
}

class PopoverTableViewController: UITableViewController, UIPopoverPresentationControllerDelegate {
    
    struct TableViewValues {
        static let identifier = "popoverCell"
    }
    
    fileprivate lazy var items: [String] = {
        var value = [String]()
        for counter in 1...15 {
            value.append("Item \(counter)")
        }
        return value
    }()
    
    fileprivate lazy var modelArray: [FoldModel] = {
        var array = [FoldModel]()
        
        for i in 0..<15 {
            let model = FoldModel(isFolding: false)
            array.append(model)
        }
        
        return array
    }()
    
    var isFolding: Bool = false
//    var rightButtonItem: UIBarButtonItem!
    var rightButton: UIButton!
    var observer: NSKeyValueObservation?
//    var popoverController: UIPopoverPresentationController!
    
    fileprivate var direction: AnimateDirection = .upToDown
    private var compressedData = Data()
    var selectionHandler: ((_ selectedItem: String) -> Void?)?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(style: UITableView.Style) {
        super.init(style: style)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
//        self.title = "Popover"
        
        if #available(iOS 14.0, *) {
            navigationItem.backButtonTitle = "hahah"
            navigationItem.backButtonDisplayMode = .minimal
        }

        configureViews()
        
        if #available(iOS 11.0, *) {
            tableView.contentInsetAdjustmentBehavior = .never
        } else {
            automaticallyAdjustsScrollViewInsets = false
        }
        
        //swift4 KVO
//        let _ = tableView.observe(\.contentOffset, options: [.initial, .old]) {[weak self] (myTableView, change) in
//            guard let self = self else { return }
//            if let value = change.oldValue {
//                print("value = \(value)")
//            }
//        }
//        print("++++ \(items.subscript(safe: 17) ?? "nil")")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        startAnimation(direction)
        
//        if #available(iOS 11.0, *) {
//            self.navigationController?.navigationBar.prefersLargeTitles = true;
//        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
//        if #available(iOS 11.0, *) {
//            self.navigationController?.navigationBar.prefersLargeTitles = false;
//        }
    }
    
    deinit {
//        observer?.invalidate()
    }
    
    //MARK: -
    private func configureViews() {
//        let cancelBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(PopoverTableViewController.performCancel))
//        navigationItem.leftBarButtonItem = cancelBarButtonItem
        
        rightButton = CommonFunction.createButton(frame: CGRect(x: 0, y: 0, width: 60, height: 44), title: "Animate", textColor: UIColor.purple, font: UIFont.systemFont(ofSize: 15), imageName: nil, isBackgroundImage: false, target: self, action: #selector(PopoverTableViewController.rightButtonItemClick))
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightButton)
        
        tableView.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: TableViewValues.identifier)
    }
    
    private func startAnimation(_ direction: AnimateDirection) {
        
        self.tableView.reloadData()
        
        let cells = tableView.visibleCells
        let tableHeight: CGFloat = tableView.bounds.size.height
        let transform: CGAffineTransform
        
        switch direction {
        case .upToDown:
            transform = CGAffineTransform(translationX: 0, y: tableHeight)
        case .leftToRight:
            transform = CGAffineTransform(translationX: kMainScreenWidth, y: 0)
        }
        
        var index = 0
        
        cells.forEach { (cell) in
            cell.transform = transform
            
            UIView.animate(withDuration: 1.3, delay: 0.08 * Double(index), usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: [], animations: {
                cell.transform = CGAffineTransform(translationX: 0, y: 0);
                
            }, completion: nil)
            
            index += 1
        }
    }
    
    @objc private func performCancel() {
        if (self.presentingViewController != nil) {
            dismiss(animated: true, completion: nil)
        }else{
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    @objc private func rightButtonItemClick() {
        
        let popVC = PopoverVC()
        popVC.modalPresentationStyle = .popover
        popVC.preferredContentSize = CGSize(width: 100, height: 150)
        
        popVC.clickBlock = {[weak self] tag in
            
            guard let self = self else { return }
            if tag == 0 {
                self.changeAnimate()
            }else if tag == 1 {
                self.compressData()
            }else {
                self.decompressData(compressedData: self.compressedData)
            }
        }
        
        let popover = popVC.popoverPresentationController
        popover?.delegate = self
        popover?.sourceRect = rightButton.bounds
        popover?.sourceView = rightButton
        popover?.permittedArrowDirections = .up
        popover?.backgroundColor = UIColor.colorWith(r: 245, g: 245, b: 245)
        present(popVC, animated: true, completion: nil)
    }
    
    private func changeAnimate() {
        rightButton.isSelected.toggle()
        direction = rightButton.isSelected ? .leftToRight : .upToDown

        startAnimation(direction)
    }
    
    private func compressData() {
        let sourceData = """
            Lorem ipsum dolor sit amet consectetur adipiscing elit mi
            nibh ornare proin blandit diam ridiculus, faucibus mus
            dui eu vehicula nam donec dictumst sed vivamus bibendum
            aliquet efficitur. Felis imperdiet sodales dictum morbi
            vivamus augue dis duis aliquet velit ullamcorper porttitor,
            lobortis dapibus hac purus aliquam natoque iaculis blandit
            montes nunc pretium.
            """.data(using: .utf8)!
        let pageSize = 128
        
        do {
            if #available(iOS 13, *) {
                let outputFilter = try OutputFilter(.compress, using: .lzfse, writingTo: { data in
                    if let data = data {
                        self.compressedData.append(data)
                    }
                })
                
                let bufferSize = sourceData.count
                ZFPrint("origin Size: \(bufferSize)")
                var index = 0
                
                while true {
                    let rangeLength = min(pageSize, bufferSize - index)
                    let subdata = sourceData.subdata(in: index..<index+rangeLength)
                    index += rangeLength
                    try outputFilter.write(subdata)
                    
                    if rangeLength == 0 {
                        break
                    }
                }
                ZFPrint("compressedData: \(compressedData.count)")
            }
        } catch  {
            ZFPrint("Error occurred during encoding: \(error.localizedDescription).")
        }
    }
    
    private func decompressData(compressedData: Data) {
        var decompressedData = Data()
        let comBufferSize = compressedData.count
        let pageSize = 128
        var deIndex = 0
        
        do {
            if #available(iOS 13, *) {
                let inputFilter = try InputFilter(.decompress, using: .lzfse, readingFrom: { (length) -> Data? in
                    let rangeLength = min(length, comBufferSize - deIndex)
                    let subdata = compressedData.subdata(in: deIndex ..< deIndex + rangeLength)
                    deIndex += rangeLength
                    
                    return subdata
                })
                
                while let page = try inputFilter.readData(ofLength: pageSize) {
                    decompressedData.append(page)
                    let decompressedString = String(data: decompressedData, encoding: .utf8)
                    ZFPrint("decompressedString: \(decompressedString ?? "")")
                }
            }
            
        } catch  {
            
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - UIPopoverPresentationControllerDelegate
    func popoverPresentationControllerShouldDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) -> Bool {
        return true
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return modelArray.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let model = modelArray[indexPath.row]
        if model.isFolding {
            return 100
        }else {
            return 55
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: TableViewValues.identifier, for: indexPath) as UITableViewCell
        
        cell.textLabel?.text = "item\(indexPath.row)"

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
//        tableView.beginUpdates()
//        tableView.endUpdates()
        
        if #available(iOS 14.0, *) {
            let newFeatureVC = NewFeatureViewController()
            navigationController?.pushViewController(newFeatureVC, animated: true)
        }
    }
}

