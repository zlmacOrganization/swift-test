//
//  OutlineViewController.swift
//  SwiftTest
//
//  Created by zhangliang on 2021/9/3.
//  Copyright © 2021 zhangliang. All rights reserved.
//

import UIKit
import PDFKit

class OutlineViewController: BaseViewController {
    var outlineRoot: PDFOutline? {
        didSet {
            guard let outlineRoot = outlineRoot else { return }
            
            for i in 0..<outlineRoot.numberOfChildren {
                if let child = outlineRoot.child(at: i) {
                    child.isOpen = false
                    datas.append(child)
                }
            }
            tableView.reloadData()
        }
    }
    
    var selectOutlineBlock: ((PDFOutline) -> Void)?
    
    private var tableView = UITableView()
    private var datas: [PDFOutline] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "outline"
        configureViews()
    }
    
    private func configureViews() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = UIColor.white
        tableView.zl_registerCell(OutlineTableCell.self)
        tableView.tableFooterView = UIView()
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func insertOuline(with parent: PDFOutline) {
        let baseIndex = datas.firstIndex(of: parent) ?? 0
        for i in 0..<parent.numberOfChildren {
            if let tempOuline = parent.child(at: i) {
                tempOuline.isOpen = false
                datas.insert(tempOuline, at: baseIndex + i + 1)
            }
        }
    }
    
    private func removeOuline(with parent: PDFOutline) {
        if parent.numberOfChildren <= 0 {
            return
        }
        
        for i in 0..<parent.numberOfChildren {
            if let tempOuline = parent.child(at: i) {
                if tempOuline.numberOfChildren > 0 && tempOuline.isOpen {
                    removeOuline(with: tempOuline)
                    if let index = datas.firstIndex(of: tempOuline) {
                        datas.remove(at: index)
                    }
                }else {
                    if datas.contains(tempOuline) {
                        if let index = datas.firstIndex(of: tempOuline) {
                            datas.remove(at: index)
                        }
                    }
                }
            }
        }
    }
    
    private func findDepth(with outline: PDFOutline) -> Int {
        var depth = -1
        var tempOutline = outline
        while tempOutline.parent != nil {
            depth += 1
            tempOutline = tempOutline.parent!
        }
        return depth
    }
}

extension OutlineViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.zl_dequeueReusableCell(OutlineTableCell.self, indexPath: indexPath)
        cell.selectionStyle = .none
        
        let outline = datas[indexPath.row]
        cell.titleLabel.text = outline.label
        cell.pageLabel.text = outline.destination?.page?.label
        cell.arrowButton.isSelected = outline.isOpen
        
        if outline.numberOfChildren > 0 {
            let image = outline.isOpen ? UIImage(named: "arrow_down") : UIImage(named: "arrow_right")
            cell.arrowButton.setImage(image, for: .normal)
//            cell.arrowButton.isEnabled = true
        }else {
//            cell.arrowButton.isEnabled = false
            cell.arrowButton.setImage(nil, for: .normal)
        }
        
        cell.arrowClickBlock = {[weak self] button in
            self?.clickOutline(cell: cell, outline: outline)
//            if outline.numberOfChildren > 0 {
//                if button.isSelected {
//                    outline.isOpen = true
//                    self?.insertOuline(with: outline)
//                }else {
//                    outline.isOpen = false
//                    self?.removeOuline(with: outline)
//                }
//                tableView.reloadData()
//            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let outline = datas[indexPath.row]
        selectOutlineBlock?(outline)
        
//        guard let cell = tableView.cellForRow(at: indexPath) as? OutlineTableCell else { return }
//        cell.arrowButton.isSelected.toggle()
//        clickOutline(cell: cell, outline: outline)
    }
    
    private func clickOutline(cell: OutlineTableCell, outline: PDFOutline) {
        if outline.numberOfChildren > 0 {
            if cell.arrowButton.isSelected {
                outline.isOpen = true
                insertOuline(with: outline)
            }else {
                outline.isOpen = false
                removeOuline(with: outline)
            }
            tableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, indentationLevelForRowAt indexPath: IndexPath) -> Int {
        let outline = datas[indexPath.row]
        return findDepth(with: outline)
    }
}

class OutlineTableCell: UITableViewCell {
    var arrowButton: UIButton!
    var titleLabel: UILabel!
    var pageLabel: UILabel!
    
    var arrowClickBlock: ((UIButton) -> Void)?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configureViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureViews() {
        arrowButton = CommonFunction.createButton(frame: CGRect.zero, title: nil, textColor: nil, font: nil, imageName: "arrow_right", isBackgroundImage: false, target: self, action: #selector(arrowImageClick))
        contentView.addSubview(arrowButton)
        
        titleLabel = CommonFunction.createLabel(font: UIFont.systemFont(ofSize: 14), text: "", textColor: .darkGray, textAlignment: .left)
        contentView.addSubview(titleLabel)
        
        pageLabel = CommonFunction.createLabel(font: UIFont.systemFont(ofSize: 14), text: "", textColor: .darkGray, textAlignment: .right)
        contentView.addSubview(pageLabel)
        
        arrowButton.snp.makeConstraints { make in
            make.left.equalTo(12)
            make.centerY.equalToSuperview()
            make.size.equalTo(CGSize(width: 30, height: 30))
        }
        
        titleLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        titleLabel.snp.makeConstraints { make in
            make.left.equalTo(arrowButton.snp.right).offset(6)
            make.right.equalTo(pageLabel.snp.left).offset(-2)
            make.centerY.equalToSuperview()
        }
        
        pageLabel.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        pageLabel.snp.makeConstraints { make in
            make.right.equalTo(-15)
            make.centerY.equalToSuperview()
        }
    }
    
    @objc private func arrowImageClick() {
        arrowButton.isSelected.toggle()
        
        arrowClickBlock?(arrowButton)
    }
}
