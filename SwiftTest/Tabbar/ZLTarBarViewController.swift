//
//  ZLTarBarViewController.swift
//  SupvpSwift
//
//  Created by bfgjs on 2019/5/24.
//  Copyright © 2019 bfgjs. All rights reserved.
//

import UIKit
import Combine

class ZLTarBarViewController: UITabBarController {
    
    private let kClassKey: String = "rootVCClassString"
    private let kTitleKey: String = "TabBarTitle"
    private let kImgKey: String = "imageName"
    private let kSelImgKey: String = "selectedImageName"
    
//    private var panGesture = UIPanGestureRecognizer()
    private let transitionUtil = TransitionUtil()
    
    private var vcCount: Int {
        guard let vcs = self.viewControllers else { return 0 }
        return vcs.count
    }
    var cancellable: Cancellable?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        cancellable = NotificationCenter.default.publisher(for: Notification.Name("changeModel")).compactMap({ $0.object as? MyFansModel }).sink(receiveCompletion: { _ in
            print("receiveCompletion")
        }, receiveValue: { model in
            print("nick: \(model.userNickName ?? "no name"), img: \(model.userHeadImg ?? "no img")")
        })

        let itemsArray = [[self.kClassKey: "HomeViewController",
                           self.kTitleKey: "首页",
                           self.kImgKey: "grzx_icon_zx",
                           self.kSelImgKey: "grzx_icon_nor"],
                          
                         [self.kClassKey: "TeamViewController",
                         self.kTitleKey: "NBA",
                         self.kImgKey: "grzx_icon_gwd",
                         self.kSelImgKey: "grzx_icon_gw"],
                        
                         [self.kClassKey: "MineViewController",
                         self.kTitleKey: "我的",
                         self.kImgKey: "grzx_wd_sel",
                         self.kSelImgKey: "grzx_icon_wd"]
        ]
        
        for dict in itemsArray {
            
            if let className = dict[self.kClassKey], let controller = swiftClassFromString(className: className) {
                let navController = BaseNavigationController(rootViewController: controller)
                
                let item = navController.tabBarItem
                item?.image = UIImage(named: dict[self.kImgKey]!)?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
                
                item?.selectedImage = UIImage(named: dict[self.kSelImgKey]!)?.withRenderingMode(.alwaysOriginal)
                item?.title = dict[self.kTitleKey]
                
                self.addChild(navController)
            }else {
                print("no controller")
            }
        }
        
//        if #available(iOS 10.0, *) {
//            tabBar.unselectedItemTintColor = UIColor.colorWith(hex: "0x858585")
//        }
        
        tabBar.tintColor = UIColor.colorWith(hex: "0x1b1a1a")
        tabBar.backgroundColor = UIColor.white
        tabBar.selectionIndicatorImage = UIImage()
        tabBar.backgroundImage = UIImage()
        tabBar.shadowImage = UIImage()
        
        //适配iOS15
//        if #available(iOS 13.0, *) {
//            let appearance = UITabBarAppearance()
//            appearance.stackedLayoutAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor.darkGray]
//            appearance.stackedLayoutAppearance.selected.titleTextAttributes = [.foregroundColor: UIColor.red]
//            tabBarItem.standardAppearance = appearance
//            if #available(iOS 15.0, *) {
//                tabBarItem.scrollEdgeAppearance = appearance
//            }
//        }
        
//        self.delegate = transitionUtil
//        view.addPanGesture(target: self, action: #selector(panHandle(_:)))
    }
    
    @objc func panHandle(_ panGesture: UIPanGestureRecognizer) {
        if tabBar.isHidden {
            return
        }
        let translationX = panGesture.translation(in: view).x
        let absX = abs(translationX)
        let progress = absX / view.frame.width

        switch panGesture.state {
        case .began:
            transitionUtil.interactive = true
            //速度
            let velocityX = panGesture.velocity(in: view).x
            if velocityX < 0 {
                if selectedIndex < vcCount - 1 {
                    selectedIndex += 1
                }
            }else {
                if selectedIndex > 0 {
                    selectedIndex -= 1
                }
            }

        case .changed:
            //更新转场进度，进度数值范围为0.0~1.0。
            transitionUtil.interactionTransition.update(progress)

        case .cancelled, .ended:
            /*
             这里有个小问题，转场结束或是取消时有很大几率出现动画不正常的问题.
             解决手段是修改交互控制器的 completionSpeed 为1以下的数值，这个属性用来控制动画速度，我猜测是内部实现在边界判断上有问题。
             这里其修改为0.99，既解决了 Bug 同时尽可能贴近原来的动画设定.
             */
            if progress > 0.3 {
                transitionUtil.interactionTransition.completionSpeed = 0.99
                //.finish()方法被调用后，转场动画从当前的状态将继续进行直到动画结束，转场完成
                transitionUtil.interactionTransition.finish()
            }else {
                //转场取消后，UITabBarController 自动恢复了 selectedIndex 的值，不需要我们手动恢复。
                transitionUtil.interactionTransition.completionSpeed = 0.99
                //.cancel()被调用后，转场动画从当前的状态回拨到初始状态，转场取消。
                transitionUtil.interactionTransition.cancel()
            }
            //无论转场的结果如何，恢复为非交互状态。
            transitionUtil.interactive = false

        default:
            break
        }
    }
}

extension UINavigationController {
    open override var childForStatusBarStyle: UIViewController? {
        return viewControllers.last
    }
}

