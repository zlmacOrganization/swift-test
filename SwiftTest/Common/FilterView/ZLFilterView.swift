//
//  ZLFilterView.swift
//  SwiftTest
//
//  Created by zhangliang on 2021/1/5.
//  Copyright © 2021 zhangliang. All rights reserved.
//

import UIKit

typealias SelectedBlock = ([String:Any], String) -> Void

class ZLFilterView: UIView {
    private let filterHeight: CGFloat = 40
    /// 加载筛选的父视图
    private var baseView : UIView?
    /// 显示筛选项的View
    private var contentView : UIView?
    
    /// 筛选列表展开
    private var menuTableView : UITableView?
    private var moreView: FilterMoreView!
    
    private var selectBlock: SelectedBlock?
    
    private var buttons: [UIButton] = []
    private var titles: [String] = ["佣金", "区域", "更多"]
    /// 菜单数据数组
    private var menus: [String] = ["不限", "从低到高", "从高到低"]
    private var previousTag = -1;
    private var isContentShow: Bool = false

    init(baseView: UIView, selectBlock: @escaping SelectedBlock) {
        super.init(frame: CGRect.zero)
        
        self.baseView = baseView
        self.selectBlock = selectBlock
        
        self.frame = CGRect(x: 0, y: 0, width: kMainScreenWidth, height: filterHeight)
        baseView.addSubview(self)
        
        configureViews()
        setupContentView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureViews() {
        let width: CGFloat = kMainScreenWidth/CGFloat(titles.count)
        
        for (i, item) in titles.enumerated() {
            let button = CommonFunction.createButton(frame: CGRect(x: CGFloat(i)*width, y: 0, width: width, height: filterHeight), title: item, textColor: UIColor.darkGray, font: UIFont.systemFont(ofSize: 15), imageName: "filter_arrow_down", target: self, action: #selector(filterButtonClick(_:)))
            button.setImage(UIImage(named: "filter_arrow_up"), for: .selected)
            button.imagePosition(at: .right, space: 6)
            button.tag = i
            buttons.append(button)
            addSubview(button)
        }
    }
    
    private func setupContentView() {
//        if contentView != nil {
//            contentView?.removeFromSuperview()
//            contentView = nil
//        }
        
        let rootView = baseView?.superview
//        let orignY = baseView?.frame.maxY ?? kNaviBarHeight - kNaviBarHeight
//        let viewHeight = kMainScreenHeight - orignY
        
//        contentView = UIView(frame: CGRect(x: 0, y: orignY, width: kMainScreenWidth, height: viewHeight))
        contentView = UIView()
        contentView?.backgroundColor = UIColor.init(white: 0, alpha: 0.35)
        contentView?.isHidden = true
//        CommonFunction.addTapGesture(with: contentView!, target: self, action: #selector(hideMenuView))
        rootView?.addSubview(contentView!)
        
        contentView?.snp.makeConstraints({ (make) in
            make.top.equalTo(baseView!.snp.bottom)
            make.left.right.bottom.equalTo(0)
        })
        
        menuTableView = UITableView(frame: CGRect(x: 0, y: 0, width: kMainScreenWidth, height: 40))
        menuTableView?.backgroundColor = UIColor.white
        menuTableView?.rowHeight = 40
        menuTableView?.delegate = self
        menuTableView?.dataSource = self
        menuTableView?.zl_registerCell(UITableViewCell.self)
        contentView?.addSubview(menuTableView!)
        
        moreView = FilterMoreView()
        moreView.isHidden = true
        contentView?.addSubview(moreView)
        
        moreView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    @objc private func filterButtonClick(_ btn: UIButton) {
        
        for button in buttons {
            if button.tag == btn.tag {
                if previousTag != button.tag && isContentShow {
                    isContentShow = false
                }
                button.isSelected.toggle()
            }else {
                button.isSelected = false
            }
        }
        
        previousTag = btn.tag
        isContentShow.toggle()
        contentView?.isHidden = !isContentShow
        
        moreView.isHidden = true
        menuTableView?.isHidden = false
        
        if btn.tag == 0 {
            menus = ["不限", "从低到高", "从高到低"]
        }else if btn.tag == 1 {
            menus = ["不限", "柳城县", "柳东新区", "融水苗族自治县", "柳江区", "鹿寨县", "城中区"]
        }else if btn.tag == 2 {
//            menus = ["商业贷款", "公积金贷款", "组合贷款", "首付分期"]
            moreView.isHidden = false
            menuTableView?.isHidden = true
        }
        
        menuTableView?.zl_height = CGFloat(menus.count*40)
        menuTableView?.reloadData()
    }
    
    @objc private func hideMenuView() {
        for button in buttons {
            button.isSelected = false
        }
        
        isContentShow = false
        contentView?.isHidden = true
    }
}

extension ZLFilterView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menus.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.zl_dequeueReusableCell(UITableViewCell.self, indexPath: indexPath)
        cell.textLabel?.text = menus[indexPath.row]
        cell.textLabel?.textColor = UIColor.darkGray
        cell.textLabel?.font = UIFont.systemFont(ofSize: 14)
        cell.textLabel?.textAlignment = .center
        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        colorWithRGB(r: 53, g: 192, b: 149)
        hideMenuView()
    }
}
