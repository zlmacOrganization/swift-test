//
//  FilterViewController.swift
//  SwiftTest
//
//  Created by zhangliang on 2021/1/5.
//  Copyright © 2021 zhangliang. All rights reserved.
//

import UIKit

class FilterViewController: BaseViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var lineView: UIView!
    @IBOutlet weak var pageCenterX: NSLayoutConstraint!
    
    private let topTitles = ["客户", "报备盘源", "带客经纪人"]
    private var userInfos: [String] = []
    private var estates: [String] = []
    
    private var isAddAgent: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "客户报备"
        configureViews()
    }
    
    private func configureViews() {
        tableView.rowHeight = 82
        tableView.sectionHeaderHeight = 40
        tableView.sectionFooterHeight = 40
        tableView.zl_registerCell(ReportInfoTableCell.self)
        tableView.zl_registerHeaderFooterView(ReportHeaderView.self)
        tableView.zl_registerHeaderFooterView(ReportAddView.self)
    }
    
    deinit {
        print("FilterViewController deinit ++++")
    }
    
    //MARK: - action
    @IBAction func sectionButtonClick(_ sender: UIButton) {
        let indexPath = IndexPath(row: 0, section: sender.tag)
        let rect = tableView.rect(forSection: indexPath.section)
        tableView.setContentOffset(rect.origin, animated: true)
    }
    
    @IBAction func submitClick(_ sender: Any) {
        let smallVC = UINavigationController(rootViewController: SmallViewController())
        smallVC.modalPresentationStyle = .custom
        smallVC.transitioningDelegate = self
        present(smallVC, animated: true, completion: nil)
    }
}

extension FilterViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return topTitles.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        if section == 0 {
//            return userInfos.count
//        }else if section == 1 {
//            return estates.count
//        }else {
//            if isAddAgent {
//                return 1
//            }
//        }
        return 7
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.zl_dequeueReusableCell(ReportInfoTableCell.self, indexPath: indexPath)
        cell.selectionStyle = .none
        
        switch indexPath.section {
        case 0:
//            cell.deleteBlock = {[weak self] in
//                guard let self = self else { return }
//            }
            break
            
        case 2:
            cell.deleteBlock = {[weak self] in
                guard let self = self else { return }
                
                self.isAddAgent = false
                tableView.reloadData()
            }
            
        default:
            break
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.zl_dequeueHeaderFooterView(ReportHeaderView.self)
        
        if #available(iOS 14.0, *) {
            let config = ReportContentConfiguration(title: topTitles[section])
            header.contentConfiguration = config
        }else {
            header.titleLabel?.text = topTitles[section]
        }
        
        return header
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footer = tableView.zl_dequeueHeaderFooterView(ReportAddView.self)
//
//        footer.addBlock = {[weak self] in
//            guard let self = self else { return }
//
//            if section == 0 {
//
//            }else if section == 1 {
//
//            }else {
//                self.isAddAgent = true
//            }
//
//            tableView.reloadData()
//        }
        
        return footer
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 40
    }
}

extension FilterViewController {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        view.endEditing(true)
        
//        let offset = scrollView.contentOffset
//        let sectionOneHeight: CGFloat = (82*7 + 40)
//        let headerHeight: CGFloat = 40
//        print("offsetY: \(offset.y)")
        
        if let indexPath = tableView.indexPathForRow(at: CGPoint(x: tableView.contentOffset.x, y: tableView.contentOffset.y + 40)) {
            let section = indexPath.section
            
            pageCenterX.constant = CGFloat(section*80)
        }
        
//        if offset.y >= 0 && offset.y <= headerHeight {
//            tableView.contentInset = UIEdgeInsets(top: -offset.y, left: 0, bottom: -headerHeight, right: 0)
//        }else if offset.y >= headerHeight && offset.y <= tableView.contentSize.height - tableView.zl_height - headerHeight {
//            tableView.contentInset = UIEdgeInsets(top: -headerHeight, left: 0, bottom: 0, right: 0)
//        }else if offset.y >= tableView.contentSize.height - tableView.zl_height - headerHeight && offset.y <= tableView.contentSize.height - tableView.zl_height {
//            tableView.contentInset = UIEdgeInsets(top: -headerHeight, left: 0, bottom: -(tableView.contentSize.height - tableView.zl_height - headerHeight), right: 0)
//        }
    }
}

//MARK: - UIViewControllerTransitioningDelegate
extension FilterViewController: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return SmallTransition(type: .present)
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return SmallTransition(type: .dismiss)
    }
}

class SmallViewController: BaseViewController {
    private var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "smallVC"
        
        tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.zl_registerCell(UITableViewCell.self)
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

extension SmallViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.zl_dequeueReusableCell(UITableViewCell.self, indexPath: indexPath)
        cell.textLabel?.text = "item \(indexPath.row)"
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let otherVC = NameTableViewController(style: .plain)
        navigationController?.pushViewController(otherVC, animated: true)
    }
}
