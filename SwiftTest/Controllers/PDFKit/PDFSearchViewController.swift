//
//  PDFSearchViewController.swift
//  SwiftTest
//
//  Created by zhangliang on 2021/9/6.
//  Copyright © 2021 zhangliang. All rights reserved.
//

import UIKit
import PDFKit

class PDFSearchViewController: UIViewController {
    var pdfDocument: PDFDocument?
    var selectSearchBlock: ((PDFSelection) -> Void)?
    
    private var searchBar: UISearchBar!
    private var tableView = UITableView()
    private var datas: [PDFSelection] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white

        configureViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        searchBar.becomeFirstResponder()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        searchBar.resignFirstResponder()
    }
    
    private func configureViews() {
        searchBar = UISearchBar()
        searchBar.delegate = self
        searchBar.showsCancelButton = true
        searchBar.searchBarStyle = .minimal
        navigationItem.titleView = searchBar
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 150
        tableView.tableFooterView = UIView()
        tableView.backgroundColor = UIColor.white
        tableView.zl_registerCell(SearchCell.self)
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

extension PDFSearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.zl_dequeueReusableCell(SearchCell.self, indexPath: indexPath)
        
        let selection = datas[indexPath.row]
        let page = selection.pages[0]
        let outline = pdfDocument?.outlineItem(for: selection)
        let destination = "\(outline?.label ?? "") PAGE: \(page.label ?? "")"
        
        cell.desLabel.text = destination
        
        let extendSelection = selection.copy() as! PDFSelection
        extendSelection.extend(atStart: 10)
        extendSelection.extend(atEnd: 90)
        extendSelection.extendForLineBoundaries()
        
        let range = extendSelection.string?.nsRange(of: selection.string ?? "", options: .caseInsensitive) ?? NSRange(location: 0, length: 0)
        cell.resultLabel.setAttributeColor(with: extendSelection.string ?? "", changeColor: UIColor.orange, range: range)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selection = datas[indexPath.row]
        selectSearchBlock?(selection)
        
        dismiss(animated: true, completion: nil)
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        searchBar.resignFirstResponder()
    }
}

extension PDFSearchViewController: UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        pdfDocument?.cancelFindString()
        dismiss(animated: true, completion: nil)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.count < 2 {
            return
        }
        
        datas.removeAll()
        tableView.reloadData()
        
        pdfDocument?.cancelFindString()
        pdfDocument?.delegate = self
        pdfDocument?.beginFindString(searchText, withOptions: .caseInsensitive)
    }
}

extension PDFSearchViewController: PDFDocumentDelegate {
    func didMatchString(_ instance: PDFSelection) {
        datas.append(instance)
        tableView.reloadData()
    }
}

fileprivate class SearchCell: UITableViewCell {
    var resultLabel: UILabel!
    var desLabel: UILabel!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configureViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureViews() {
        desLabel = CommonFunction.createLabel(font: UIFont.systemFont(ofSize: 14), text: "", textColor: .darkGray, textAlignment: .right)
        contentView.addSubview(desLabel)
        
        resultLabel = CommonFunction.createLabel(font: UIFont.systemFont(ofSize: 14), text: "", textColor: .blue, textAlignment: .left)
        resultLabel.numberOfLines = 0
        contentView.addSubview(resultLabel)
        
        desLabel.snp.makeConstraints { make in
            make.top.left.equalTo(7)
            make.right.equalTo(-7)
        }
        
        resultLabel.snp.makeConstraints { make in
            make.left.equalTo(7)
            make.right.bottom.equalTo(-7)
            make.top.equalTo(desLabel.snp.bottom).offset(7)
        }
    }
}
