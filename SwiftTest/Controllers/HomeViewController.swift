//
//  ViewController.swift
//  SwiftTest
//
//  Created by ZhangLiang on 16/12/11.
//  Copyright © 2016年 ZhangLiang. All rights reserved.
//

import UIKit
import Kingfisher
import ContactsUI

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    let image = UIImage(named: "Safari")
    var imageView: UIImageView!
    private var dataArray = [String]()
    private let transitionUtil = TransitionUtil()
    
    private var rightButton: UIButton!
    
    fileprivate lazy var listTableView: UITableView = {
        let tableView = UITableView(frame: CGRect(x: 0, y: 0, width: kMainScreenWidth, height: kMainScreenHeight - statusBarHeight() - kNaviBarHeight))
        tableView.delegate = self
        tableView.dataSource = self
        tableView.allowsMultipleSelection = false
        tableView.allowsMultipleSelectionDuringEditing = true
        tableView.zl_registerCell(UITableViewCell.self)
        return tableView
    }()
    
//    override var preferredStatusBarStyle: UIStatusBarStyle {
//        return UIStatusBarStyle.lightContent
//    }
    
    //MARK: -
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let rightButtonItem = UIBarButtonItem(title: "清除缓存", style: .plain, target: self, action: #selector(ViewController.clearCacheClick))
//        self.navigationItem.rightBarButtonItem = rightButtonItem
        
        setupNav()
        
        dataArray = ["PopoverTableViewController", "DiffableDataController", "TableRefreshViewController", "TestCollectionViewController", "LocationViewController", "NetWorkViewController", "ListViewController", "BlurViewController", "NameTableViewController", "AnimateViewController", "MyPostViewController", "CollectionDragViewController", "TableDragViewController", "ContactsViewController", "LayerAnimationController", "KeyboardLayoutViewController", "ReminderListViewController", "CompositionLayoutViewController", "MosaicViewController", "other"]
        
        self.view.addSubview(listTableView)
        listTableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 0)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if listTableView.isEditing {
            if let selectRow = listTableView.indexPathsForSelectedRows {
                debugPrint("select rows: \(selectRow.map{$0.row})")
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: -
    func setupNav() {
        self.navigationItem.title = "Swift"
//        if #available(iOS 11.0, *) {
//            self.navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedStringKey.font: UIFont(name: "PingFangSC-Medium", size: 25)!, NSAttributedStringKey.foregroundColor: UIColor.orange]
//            self.navigationController?.navigationBar.prefersLargeTitles = true;
//            self.navigationItem.largeTitleDisplayMode = .automatic;
//        }
        
        rightButton = CommonFunction.createButton(frame: CGRect(x: 0, y: 0, width: 60, height: 40), title: NSLocalizedString("Edit", comment: "home edit"), textColor: UIColor.purple, font: UIFont.systemFont(ofSize: 16), imageName: nil, isBackgroundImage: false, target: self, action: #selector(rightButtonClick(_:)))
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightButton)
    }
    
    //MARK: - action
    @IBAction func buttonPushClick(_ sender: UIButton) {
        
    }
    
    @objc private func rightButtonClick(_ button: UIButton) {
        button.isSelected.toggle()
        
        if button.isSelected {
            rightButton.setTitle(NSLocalizedString("Cancel", comment: "home cancel"), for: .normal)
        }else {
            rightButton.setTitle(NSLocalizedString("Edit", comment: "home edit"), for: .normal)
        }
        
        listTableView.setEditing(button.isSelected, animated: true)
    }
    
    @objc private func clearCacheClick() {
        KingfisherManager.shared.cache.calculateDiskStorageSize(completion: { result in
            switch result {
            case .success(let cachaSize):
                print("disk is: \(cachaSize)")
            case .failure(let error):
                print("error:  \(error.errorDescription ?? "")")
            }
        })
        
//        KingfisherManager.shared.cache.clearMemoryCache()
//        KingfisherManager.shared.cache.clearDiskCache()
    }
    
    func buttonISPressed(_ sender: UIButton)  {
        print("Button is pressed")
    }
    
    func segmentControlValueChanged(sender: UISegmentedControl)  {
        let selectedSegmentIndex = sender.selectedSegmentIndex
        let selectedSegmentText = sender.titleForSegment(at: selectedSegmentIndex)
        print("Segment \(selectedSegmentIndex) with text" + "of \(String(describing: selectedSegmentText)) is selected")
    }
    
    //MARK: - UITableViewDelegate, UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.zl_dequeueReusableCell(UITableViewCell.self, indexPath: indexPath)
        cell.textLabel?.text = dataArray[indexPath.row]
//        cell.selectionStyle = UITableViewCell.SelectionStyle.default
        
        cell.multipleSelectionBackgroundView = UIView()
        cell.tintColor = UIColor.red
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .insert
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let data = dataArray[sourceIndexPath.row]
        dataArray.remove(at: sourceIndexPath.row)
        dataArray.insert(data, at: destinationIndexPath.row)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if tableView.isEditing {
            
        }else {
            tableView.deselectRow(at: indexPath, animated: true)
            
//            if let controller = swiftClassFromString(className: dataArray[indexPath.row]) {
//                tableView.deselectRow(at: indexPath, animated: true)
//                
//                pushMyViewController(controller: controller)
//                return
//            }
            
            
            switch indexPath.row {
            case 0:
                let controller = PopoverTableViewController.init(style: UITableView.Style.plain)
                self.pushMyViewController(controller: controller)
            case 1:
                if #available(iOS 13.0, *) {
                    let oneController = DiffableDataController()
                    self.pushMyViewController(controller: oneController)
                }
            case 2:
                let refreshVc = TableRefreshViewController()
                //        refreshVc.testId = "1234"
                self.pushMyViewController(controller: refreshVc)
            case 3:
                let collectionVc = TestCollectionViewController.init(coder: NSCoder())
                self.pushMyViewController(controller: collectionVc!)
            case 4:
                let twoController = LocationViewController()
                self.pushMyViewController(controller: twoController)
                
//                if let dict = Bundle.main.object(forInfoDictionaryKey: "CFBundleIcons") as? [String: Any] {
//                    if let alternateIcons = dict["CFBundleAlternateIcons"] as? [String: Any] {
//                        debugPrint("icon keys: \(alternateIcons.keys)")
//                    }
//                }
//
//                // 更换应用图标
//                UIApplication.shared.setAlternateIconName("AppIcon_swift") { error in
//                    if error != nil {
//                        print("更换应用图标失败: \(error?.localizedDescription ?? "")")
//                    }
//                }
                
                // 恢复默认应用图标
//                UIApplication.shared.setAlternateIconName(nil)
            case 5:
                let netVc = UINavigationController(rootViewController: NetWorkViewController())
                netVc.modalPresentationStyle = .custom
//                netVc.transitioningDelegate = transitionUtil
                present(netVc, animated: true, completion: nil)
//                self.pushMyViewController(controller: netVc)
            case 6:
                let listVc = ListViewController()
                self.pushMyViewController(controller: listVc)
            case 7:
                let blurVC = BlurViewController()
                self.pushMyViewController(controller: blurVC)
            case 8:
                let nameTableVC = NameTableViewController(style: .plain)
                self.pushMyViewController(controller: nameTableVC)
            case 9:
                let animateVC = AnimateViewController()
                self.pushMyViewController(controller: animateVC)
            case 10:
                //            let testVC = MyTestViewController.init(name: "zhang")
                let testVC = MyPostViewController()
                self.pushMyViewController(controller: testVC)
            case 11:
                let collectionDragVC = CollectionDragViewController()
                self.pushMyViewController(controller: collectionDragVC)
            case 12:
                let tableDragVC = TableDragViewController()
                self.pushMyViewController(controller: tableDragVC)
            case 13:
//                let contactStore = CNContactStore()
//                    contactStore.requestAccess(for: CNEntityType.contacts) { (isAccess, error) in
//                        if isAccess {
//
//                        }else {
//
//                        }
//                    }
                
                CommonFunction.contactAuthorization(isAllow: {
                    let contactsVC = ContactsViewController()
                    self.pushMyViewController(controller: contactsVC)
                }, notAllow: {
                    CommonFunction.showAlertController(title: "提示", message: "未开启通讯录权限", controller: self, cancelAction: nil, sureAction: {
                        CommonFunction.goSystemSetting()
                    })
                }) {
                    let contactsVC = ContactsViewController()
                    self.pushMyViewController(controller: contactsVC)
                }
            case 14:
                let layerAnimationVC = LayerAnimationController()
                pushMyViewController(controller: layerAnimationVC)
            case 15:
                let keyboardVC = KeyboardLayoutViewController()
                pushMyViewController(controller: keyboardVC)
            case 16:
                if #available(iOS 15.0, *) {
                    let reminderVC = ReminderListViewController(reminders: [])
                    pushMyViewController(controller: reminderVC)
                }
            case 17:
                if #available(iOS 14.0, *) {
                    let layoutVC = CompositionListVC()
                    pushMyViewController(controller: layoutVC)
                }
            case 18:
                let mosaicVC = MosaicViewController()
                pushMyViewController(controller: mosaicVC)
            default:
//                if #available(iOS 17.0, *) {
//                    let featureVC = FeatureTestViewController(configType: .empty)
//                    pushMyViewController(controller: featureVC)
//                } else {
//                    
//                }
                
                let deviceName = UIDevice.current.phoneModel
                let model = UIDevice.current.model
                
                showNoticeOnlyText("name: \(deviceName), model: \(model)")
                
                break
            }
        }
    }
    
    func pushMyViewController(controller: UIViewController) {
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self as? UIGestureRecognizerDelegate
        
        controller.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(controller, animated: true)
    }
}

//MARK: - Action

extension HomeViewController {
    @objc func labelTapped() {
        print("_________ label Tapped!")
    }
}

