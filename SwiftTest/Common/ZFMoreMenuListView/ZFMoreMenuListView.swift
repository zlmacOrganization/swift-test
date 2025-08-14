//
//  ZFMoreMenuListView.swift
//  ZFBaseModule_Example
//
//  Created by guzhiyang on 2018/7/18.
//  Copyright © 2018年 CocoaPods. All rights reserved.
//

// MARK: - 右上角更多弹出框

import UIKit

/// 显示的item个数及功能
enum MoreMenuType {
    case DefaultThreeItemType   /// 动态、首页、我的
    case ShareFourItemType      /// 动态、首页、我的，分享
    case ReportFiveItemType     /// 动态、首页、我的，分享，举报房源
}

/// 点击的类型
enum MoreMenuClickedItem {
    case DynamicItemClicked     /// 动态
    case DiscoverItemClicked    /// 首页
    case MineItemClicked        /// 我的
    case ShareItemClicked       /// 分享
    case ReportItemClicked      /// 举报
}

// MARK: - 动态回调Block
typealias DynamicItemClickedBlock = (ZFMoreMenuListView) -> ()
// MARK: - 首页回调Block
typealias DiscoverItemClickedBlock = (ZFMoreMenuListView) -> ()
// MARK: - 我的回调Block
typealias MineItemClickedBlock = (ZFMoreMenuListView) -> ()
// MARK: - 分享回调Block
typealias ShareItemClickedBlock = (ZFMoreMenuListView) -> ()
// MARK: - 举报回调Block
typealias ReportItemClickedBlock = (ZFMoreMenuListView) -> ()

// MARK: - 回调Block
typealias MoreMenuItemClickedBlock = (ZFMoreMenuListView, MoreMenuClickedItem) -> ()

class ZFMoreMenuListView: UIView {
    /// cell 高度
    private let MENU_CELL_HEIGHT : CGFloat = 45
    /// 视图总宽度
    private let MENU_VIEW_WIDTH : CGFloat = 120
    /// 三角形高度
    private let MENU_ARROW_HEIGHT : CGFloat = 7
    /// 三角形宽度
    private let MENU_ARROW_WIDTH : CGFloat = 12

    /// 标题
    private var titlesArray = [String]()
    /// 图标名称
    private var iconNamesArray = [String]()
    /// 菜单列表
    private var menuListTableView : UITableView?
    /// 主视图
    private var mainView : UIView?
    /// 背景视图
    private var backgroundView : UIView?
    /// 依赖视图
    private var relyOnView = UIView()
    ///
    private var arrowImgeView : UIImageView?
    /// 圆角
    private var cornerRadius : CGFloat = 3
    /// 三角中心左边距
    private var arrowCenterLeft : CGFloat?
    /// 偏移量
    private var verOffSet : CGFloat?
    
    /// 点击回调
    public var menuItemClickedBlock : MoreMenuItemClickedBlock?
    /// 点击回调
    public var dynamicClickedBlock : DynamicItemClickedBlock?
    /// 点击回调
    public var discoverClickedBlock : DiscoverItemClickedBlock?
    /// 点击回调
    public var mineClickedBlock : MineItemClickedBlock?
    /// 点击回调
    public var shareClickedBlock : ShareItemClickedBlock?
    /// 点击回调
    public var reportClickedBlock : ReportItemClickedBlock?

    /// 依赖
    private var relyonViewController : UIViewController?
    private let keyWindow = getKeyWindow()
    
    private func initMenuListView()  {
        let relyViewFrame = relyOnView.convert(relyOnView.bounds, to: keyWindow)
        
        let verticalOffSet = verOffSet ?? 0
        
        frame = CGRect.init(x: kMainScreenWidth - MENU_VIEW_WIDTH - 10,
                            y: relyViewFrame.maxY + verticalOffSet,
                            width: MENU_VIEW_WIDTH,
                            height: MENU_CELL_HEIGHT * CGFloat(titlesArray.count) + MENU_ARROW_HEIGHT)
        cornerRadius = 3
        arrowCenterLeft = relyViewFrame.origin.x - zl_left + relyViewFrame.width/2;
        
        alpha = 0
        layer.shadowOpacity = 0.5
        layer.shadowOffset = CGSize.zero
        layer.shadowRadius = 2.0
        
        mainView = UIView.init(frame: bounds)
        mainView?.backgroundColor = .white
        mainView?.layer.cornerRadius = 2
        mainView?.layer.masksToBounds = true
        
        menuListTableView = UITableView.init(frame: bounds,
                                             style: .plain)
        menuListTableView?.backgroundColor = .clear
        menuListTableView?.delegate = self
        menuListTableView?.dataSource = self
        menuListTableView?.tableFooterView = UIView()
        menuListTableView?.separatorStyle = .none
        menuListTableView?.center.y = (mainView?.center.y)! + MENU_ARROW_HEIGHT
        mainView?.addSubview(menuListTableView!)
        menuListTableView?.zl_registerCell(ZFMoreMenuCell.self)
        addSubview(mainView!)
        
        backgroundView = UIView(frame: UIScreen.main.bounds)
        backgroundView?.backgroundColor = UIColor.lightGray.withAlphaComponent(0.3)
        backgroundView?.alpha = 0
        let tapGesture = UITapGestureRecognizer.init(target: self,
                                                     action: #selector(dismiss))
        backgroundView?.addGestureRecognizer(tapGesture)
        
//        return self
    }
    
    /// 展示在依赖视图上
    ///
    /// - Parameters:
    ///   - relyView: 依赖视图
    ///   - menusType: 显示的菜单类型
    func showOnRelyView(relyView:UIView,
                               relyVC:UIViewController,
                               menusType:MoreMenuType) {
        showOnRelyView(relyView: relyView,
                       relyVC:relyVC,
                       menusType: menusType,
                       verticalOffset: 0)
    }
    
    /// 添加纠偏位移
    func showOnRelyView(relyView:UIView,
                               relyVC:UIViewController,
                               menusType:MoreMenuType,
                               verticalOffset:CGFloat)
    {
        relyonViewController = relyVC
//        let unreadNum = BaseTabBarController.shareTabBarController.unreadAllCount
        let dynamicIconName = "base_more_menu_dynamic"
//        if unreadNum > 0 {
//            dynamicIconName = "base_more_menu_dynamic_unread"
//        }
        self.relyOnView = relyView
        self.verOffSet = verticalOffset
        
        titlesArray = ["首页", "NBA", "我的"]
        iconNamesArray = [dynamicIconName,"base_more_menu_home","base_more_menu_my"]
//        if menusType == .ShareFourItemType {
//            titlesArray.append("分享")
//            iconNamesArray.append("base_more_menu_share")
//        }else if menusType == .ReportFiveItemType{
//            titlesArray.append("分享")
//            iconNamesArray.append("base_more_menu_share")
//            titlesArray.append("举报房源")
//            iconNamesArray.append("base_more_menu_report")
//        }
        
        initMenuListView()
        show()
    }
    
    private func show() {
        
        hideLastCellSeperateLine()
        
        mainView?.layer.mask = resetMainViewShape()
        
        let selfPoint = layer.position
        keyWindow?.addSubview(backgroundView!)
        keyWindow?.addSubview(self)
        layer.setAffineTransform(CGAffineTransform.init(scaleX: 0.1,
                                                        y: 0.1))
        layer.position = CGPoint.init(x: kMainScreenWidth - 22, y: 64)
        
        UIView.animate(withDuration: 0.25) {
            self.layer.setAffineTransform(CGAffineTransform.init(scaleX: 1,
                                                                 y: 1))
            self.alpha = 1
            self.layer.position = selfPoint
            self.backgroundView?.alpha = 1
        }
    }
    
    /// 注销
    @objc private func dismiss() {
        UIView.animate(withDuration: 0.25,
                       animations:
            {
                self.layer.setAffineTransform(CGAffineTransform.init(scaleX: 0.1,
                                                                     y: 0.1))
                self.layer.position = CGPoint.init(x: kMainScreenWidth - 22,
                                                   y: 64)
                self.alpha = 0
                self.backgroundView?.alpha = 0
        }) { (complete) in
            self.removeFromSuperview()
            self.backgroundView?.removeFromSuperview()
        }
    }
    
    /// 重画内容视图的边框
    private func resetMainViewShape() -> CAShapeLayer{
        let maskLayer = CAShapeLayer()
        maskLayer.frame = (mainView?.bounds)!
        
        /// 左上角圆心
        let topLeftCornerCenter = CGPoint.init(x: cornerRadius,
                                               y: cornerRadius + MENU_ARROW_HEIGHT)
        
        /// 右上角圆心
        let topRightCornerCenter = CGPoint.init(x:zl_width - cornerRadius,
                                                y: cornerRadius + MENU_ARROW_HEIGHT)
        /// 左下角圆心
        let bottomLeftCornerCenter = CGPoint.init(x: cornerRadius,
                                                  y: zl_height - cornerRadius)
        /// 右下角圆心
        let bottomRightCornerCenter = CGPoint.init(x: zl_width - cornerRadius,
                                                   y: zl_height - cornerRadius)
        
        /// 从左上角 圆角下方开始
        let layerPath = UIBezierPath()
        layerPath.move(to: CGPoint.init(x: 0,
                                        y: MENU_ARROW_WIDTH + cornerRadius))
        
        /// 划线到左下角 画圆角
        layerPath.addLine(to: CGPoint.init(x: 0,
                                           y: zl_height - cornerRadius))
        layerPath.addArc(withCenter: bottomLeftCornerCenter,
                         radius: cornerRadius,
                         startAngle: -.pi,
                         endAngle: -.pi - .pi/2,
                         clockwise: false)
        
        /// 划线到右下角 画圆角
        layerPath.addLine(to: CGPoint.init(x: bottomRightCornerCenter.x,
                                           y: zl_height))
        layerPath.addArc(withCenter: bottomRightCornerCenter,
                         radius: cornerRadius,
                         startAngle: -3/2 * .pi,
                         endAngle: -2 * .pi,
                         clockwise: false)
        
        /// 划线到右上角 画圆角
        layerPath.addLine(to: CGPoint.init(x: zl_width,
                                           y: topRightCornerCenter.y))
        layerPath.addArc(withCenter: topRightCornerCenter,
                         radius: cornerRadius,
                         startAngle: 0,
                         endAngle: -.pi/2,
                         clockwise: false)
        
        /// 画三角形
        layerPath.addLine(to: CGPoint.init(x: arrowCenterLeft! + MENU_ARROW_WIDTH/2,
                                           y: MENU_ARROW_HEIGHT))
        layerPath.addLine(to: CGPoint.init(x: arrowCenterLeft!,
                                           y: 0))
        layerPath.addLine(to: CGPoint.init(x: arrowCenterLeft! - MENU_ARROW_WIDTH/2,
                                           y: MENU_ARROW_HEIGHT))
        
        /// 划线到左上角 画圆角 合并
        layerPath.addLine(to: CGPoint.init(x: topLeftCornerCenter.x,
                                           y: MENU_ARROW_HEIGHT))
        layerPath.addArc(withCenter: topLeftCornerCenter,
                         radius: cornerRadius,
                         startAngle: -.pi/2,
                         endAngle: -.pi,
                         clockwise: false)
        layerPath.close()
        
        maskLayer.path = layerPath.cgPath
        
        return maskLayer;
    }
    
    /// 隐藏最下方的分割线
    private func hideLastCellSeperateLine() {
        let lastCell = menuListTableView?.cellForRow(at: IndexPath.init(row: titlesArray.count - 1,
                                                                        section: 0)) as! ZFMoreMenuCell
        lastCell.isHideSeperateLineView(hide: true)
    }
    
    /// 切换到对应的界面
    private func changeToTargetVC(index:Int) {
        let tabbarVC = getKeyWindow()?.rootViewController as? ZLTarBarViewController
        switch index {
//        /// 动态
//        case 0:
//            relyonViewController?.navigationController?.popToRootViewController(animated: false)
//            if let count = tabbarVC.viewControllers?.count, count > 2 {
//                tabbarVC.selectedIndex = count - 2
//            }

        /// 首页
        case 0:
            relyonViewController?.navigationController?.popToRootViewController(animated: false)
            tabbarVC?.selectedIndex = 0
          
        /// NBA
        case 1:
            relyonViewController?.navigationController?.popToRootViewController(animated: false)
            tabbarVC?.selectedIndex = 1
            
        /// 我的
        case 2:
            relyonViewController?.navigationController?.popToRootViewController(animated: false)
            tabbarVC?.selectedIndex = 2

        default:
            break
        }
    }
    
    private func isCurrentKindOfRootVC(rootClass:AnyClass) -> Bool {
        var isRootClass = false
        
        for viewControlelr in (relyonViewController?.navigationController?.viewControllers)! {
            if viewControlelr.isKind(of: rootClass){
                isRootClass = true
                break
            }
        }
        return isRootClass
    }
    
}

// MARK: - TableDataSource
extension ZFMoreMenuListView:UITableViewDataSource{
    /// Sections
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    /// Rows
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titlesArray.count
    }
    
    /// Height
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return MENU_CELL_HEIGHT
    }
    
    /// Cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let moreMenuCell = tableView.zl_dequeueReusableCell(ZFMoreMenuCell.self, indexPath: indexPath)
        moreMenuCell.setMenuContent(title: titlesArray[indexPath.row],
                                    iconName: iconNamesArray[indexPath.row])
        return moreMenuCell
    }
}

// MARK: - TableDelegate
extension ZFMoreMenuListView:UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            if dynamicClickedBlock != nil{
                dynamicClickedBlock!(self)
            }else{
                changeToTargetVC(index: indexPath.row)
            }
            
        case 1:
            if discoverClickedBlock != nil{
                discoverClickedBlock!(self)
            }else{
                changeToTargetVC(index: indexPath.row)
            }

        case 2:
            if mineClickedBlock != nil{
                mineClickedBlock!(self)
            }else{
                changeToTargetVC(index: indexPath.row)
            }

        case 3:
            if shareClickedBlock != nil{
                shareClickedBlock!(self)
            }
            
        case 4:
            if reportClickedBlock != nil{
                reportClickedBlock!(self)
            }
        default:
            break
        }
        
        dismiss()
    }
}

