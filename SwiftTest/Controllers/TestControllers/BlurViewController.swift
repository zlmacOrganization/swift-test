//
//  BlurViewController.swift
//  SwiftTest
//
//  Created by ZhangLiang on 2017/7/9.
//  Copyright © 2017年 ZhangLiang. All rights reserved.
//

import UIKit
import Vision
import Alamofire
import QuickLookThumbnailing

class BlurViewController: BaseViewController {
    
    private var imageView = UIImageView()
    private var startY: CGFloat = 240
    private var beginPoint: CGPoint?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white

        setupViews()
        
        addMenuInteraction()
        threadSyncTest()
        
        if #available(iOS 14.0, *) {
            let rightButton = UIBarButtonItem(menu: UIMenu(children: [
                UIAction(title: "first", state: .on, handler: { _ in
                    print("first")
                }),
                
                UIAction(title: "second", handler: { _ in
                    print("second")
                }),
                
                UIAction(title: "third", handler: { _ in
                    print("third")
                })
            ]))
            if #available(iOS 15.0, *) {
                rightButton.changesSelectionAsPrimaryAction = true
            }
            navigationItem.rightBarButtonItem = rightButton
        }
    }
    
    private func setupViews() {
        imageView.image = UIImage(named: "thumb15")
        imageView.isUserInteractionEnabled = true
        view.addSubview(imageView)
        imageView.frame = CGRect(x: (kMainScreenWidth - 200)/2, y: (kMainScreenHeight - 200)/2 - kNaviBarHeight, width: 200, height: 200)
        
//        imageView.snp.makeConstraints { (make) in
//            make.centerX.equalTo(view.snp.centerX)
//            make.centerY.equalTo(view.snp.centerY)
//            make.width.height.equalTo(200)
//        }
        
//        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.dark)
//        let blurView = UIVisualEffectView(effect: blurEffect)
//        blurView.frame = imageView.bounds
//        imageView.addSubview(blurView)
        
//        CommonFunction.addTapGesture(with: imageView, target: self, action: #selector(faceDetect))
        CommonFunction.addPanGesture(with: imageView, target: self, action: #selector(panGesture(_:)))
    }
    
    //MARK: - panGesture
    @objc private func panGesture(_ gesture: UIPanGestureRecognizer) {
        //translationInView : 手指在视图上移动的位置（x,y）向下和向右为正，向上和向左为负。
        //locationInView ： 手指在视图上的位置（x,y）就是手指在视图本身坐标系的位置。
        //velocityInView： 手指在视图上移动的速度（x,y）, 正负也是代表方向，值得一提的是在绝对值上|x| > |y| 水平移动， |y|>|x| 竖直移动。

        let point = gesture.translation(in: view)
        let touchPoint = gesture.location(in: view)
        print("point: \(point), touchPoint: \(touchPoint)")
        
        switch gesture.state {
        case .began:
            startY = (gesture.view?.frame.origin.y)!
            panTouchesBegin(point: touchPoint)
        case .changed:
            panTouchesMoved(point: touchPoint)
        case .ended:
            panTouchesEnd(point: touchPoint)
//        ZFPrint("ended")
        default:
            break
        }
            
//        if gesture.state == .began {
//            startY = (gesture.view?.frame.origin.y)!
//        }else if gesture.state == .changed {
//
//            var frame = gesture.view?.frame
//            frame!.origin.y = startY + point.y
//
//            if frame!.origin.y < kNavBarAndStatusBarHeight {
//                frame!.origin.y = kNavBarAndStatusBarHeight
//            }
//
//            if frame!.maxY > kMainScreenHeight - kNavBarAndStatusBarHeight {
//                frame!.origin.y = kMainScreenHeight - kNavBarAndStatusBarHeight - 200
//            }
////                frame!.size.height = kMainScreenHeight - frame!.origin.y
//
//            gesture.view?.frame = frame!
//
//        }else if gesture.state == .ended {
//            if gesture.velocity(in: view).y < 0 {//向上
//                UIView.animate(withDuration: 0.3) {
//                    var frame = gesture.view?.frame
//                    frame?.origin.y = kNavBarAndStatusBarHeight
////                        frame!.size.height = kMainScreenHeight - frame!.origin.y
//                    gesture.view?.frame = frame!
//                }
//            }else {//向下
//                UIView.animate(withDuration: 0.3) {
//                    var frame = gesture.view?.frame
//                    frame?.origin.y = kMainScreenHeight - kNavBarAndStatusBarHeight - 200
////                        frame!.size.height = kMainScreenHeight - frame!.origin.y
//                    gesture.view?.frame = frame!
//                }
//            }
//        }
    }
    
    func panTouchesBegin(point: CGPoint){
        beginPoint = imageView.convert(point, to: imageView.superview)
    }

    func panTouchesMoved(point: CGPoint){
        var frame = imageView.frame
        frame.origin.x = point.x - imageView.zl_width/2
        frame.origin.y = point.y - imageView.zl_height/2
        imageView.frame = frame
    }

    func panTouchesEnd(point: CGPoint){
        let viewWidth = imageView.zl_width
        let viewHeight = imageView.zl_height
        var frame = self.imageView.frame
        
        if frame.maxX > kMainScreenWidth || frame.origin.x < 0 {
            frame.origin.x = (kMainScreenWidth - viewWidth)/2
        }
        
        if frame.maxY > kMainScreenHeight || frame.origin.y < 0 {
            frame.origin.y = (kMainScreenHeight - viewHeight)/2
        }

        UIView.animate(withDuration: 0.2) {
            self.imageView.frame = frame
        }
    }
    
    //MARK: -
    @objc private func threadSyncTest() {
        let funcs: [Selector] = [#selector(semaphoreTest), #selector(enterAndLeave), #selector(barrierOperate), #selector(groupOperation), #selector(syncQueue)]
        
        let font = UIFont.systemFont(ofSize: 15)
        var buttonX: CGFloat = 10
        var buttonY: CGFloat = 50
        let width: CGFloat = (kMainScreenWidth - 40)/3
        
        for (index, item) in funcs.enumerated() {
            if index > 2 {
                buttonX = 10 + (width + 10)*CGFloat(index - 3)
                buttonY = 95
            }else {
                buttonX = 10 + (width + 10)*CGFloat(index)
            }
            
            let button = CommonFunction.createButton(frame: CGRect(x: buttonX, y: buttonY, width: width, height: 40), title: item.description, textColor: UIColor.purple, font: font, target: self, action: item)
            if #available(iOS 14.0, *), index == funcs.count - 1 {
                button.showsMenuAsPrimaryAction = true
                button.menu = UIMenu(children: [
                    UIAction(title: "first", handler: { _ in
                        print("first")
                    }),
                    
                    UIAction(title: "second", handler: { _ in
                        print("second")
                    }),
                    
                    UIAction(title: "third", handler: { _ in
                        print("third")
                    })
                ])
            }
            view.addSubview(button)
        }
        
//        semaphoreTest()
//        enterAndLeave()
//        barrierOperate()
//        groupOperation()
//        syncQueue()
        
        //10 为迭代次数(并发执行)
//        DispatchQueue.concurrentPerform(iterations: 10) { (index) in
//            print("iteration index: \(index)")
//        }
    }
    
    @objc private func semaphoreTest() {
        let semaphore = DispatchSemaphore(value: 1)
        let queue = DispatchQueue(label: "", attributes: .concurrent)
        
        queue.async {
            semaphore.wait()
            DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                semaphore.signal()
                print("signal +1")
            }
        }
        
        queue.async {
            semaphore.wait()
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                semaphore.signal()
                print("signal +2")
            }
        }

        // create
//        dispatch_semaphore_t semaphore = dispatch_semaphore_create(1);
//
//        // thread A
//        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//            dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
//            // execute task A
//            NSLog(@"task A");
//            sleep(10);
//            dispatch_semaphore_signal(semaphore);
//        });
//
//        // thread B
//        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//            dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
//            // execute task B
//            NSLog(@"task B");
//            dispatch_semaphore_signal(semaphore);
//        });
    }
    
    @objc private func enterAndLeave() {
        let group = DispatchGroup()
        group.enter()
        DispatchQueue.global().async {
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                print("task: 1 complete")
                group.leave()
            }
        }
        
        group.enter()
        DispatchQueue.global().async {
            
            print("task: 2 complete")
            group.leave()
        }
        
        group.enter()
        DispatchQueue.global().async {
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                print("task: 3 complete")
                group.leave()
                
                //                print("all done ------")
            }
        }
        
        group.notify(queue: .main) {
            print("all done ------")
        }
    }
    
    @objc private func groupOperation() {
        let group = DispatchGroup()
        
//        let queue = DispatchQueue.global(qos: .default)
//        queue.async(group: group, execute: DispatchWorkItem(block: {
//
//        }))
        
        group.enter()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
            group.leave()
            print("task: 1 complete")
        })
        
        group.enter()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
            group.leave()
            print("task: 2 complete")
        })
        
        group.enter()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
            group.leave()
            print("task: 3 complete")
        })
        
        group.notify(queue: .main) {
            print("group notify ------")
        }
    }
    
    @objc private func barrierOperate() {
        let queue = DispatchQueue(label: "barrierQueue", qos: DispatchQoS.default, attributes: .concurrent, autoreleaseFrequency: .workItem, target: nil)
        
        queue.async {
            NSLog("task: 1 complete")
        }
        
        queue.async(execute: DispatchWorkItem(qos: DispatchQoS.default, flags: .barrier, block: {
//            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
//                NSLog("task: 2 complete")
//            }
            DispatchQueue.global().asyncAfter(deadline: .now() + 1, execute: {
                NSLog("task: 2 complete")
            })
//            NSLog("task: 2 complete")
        }))
        
        queue.async {
            NSLog("task: 3 complete")
        }
    }
    
    @objc private func syncQueue() {
        let queue = DispatchQueue(label: "zl.sync.test")
        
        DispatchQueue.main.async {
            print("async ----")
        }
        
        queue.sync(flags: .barrier) {
            sleep(2)
            print("sync ++++")
        }
    }
    
    //MARK: -
    @objc private func faceDetect() {
        if #available(iOS 11.0, *) {
            let handler = VNImageRequestHandler(cgImage: (imageView.image?.cgImage)!, orientation: CGImagePropertyOrientation.up)
            let request = VNDetectFaceRectanglesRequest { (VNRequest, error) in
                DispatchQueue.main.async {
                    if let results = VNRequest.results {
                        let transform = CGAffineTransform(scaleX: 1, y: -1).translatedBy(x: 0, y: -self.imageView.zl_height)
                        let translate = CGAffineTransform.identity.scaledBy(x: self.imageView.zl_width, y: self.imageView.zl_height)
                        
                        for item in results {
                            let faceView = UIView(frame: CGRect.zero)
                            faceView.backgroundColor = UIColor(red: 0, green: 1.0, blue: 0, alpha: 0.5)
                            self.imageView.addSubview(faceView)
                            
                            if let faceObservation = item as? VNFaceObservation {
                                let finalRect = faceObservation.boundingBox.applying(translate).applying(transform)
                                faceView.frame = finalRect
                            }
                        }
                    }
                }
            }
            
            DispatchQueue.global(qos: .userInteractive).async {
                do {
                    try handler.perform([request])
                } catch {
                    
                }
            }
        }
    }
    
    private func thumbnailImage() {
        guard let url = Bundle.main.url(forResource: "image5", withExtension: "jpg") else { return }
        let size = CGSize(width: 60, height: 80)
        if #available(iOS 13.0, *) {
            let request = QLThumbnailGenerator.Request(fileAt: url, size: size, scale: UIScreen.main.scale, representationTypes: .thumbnail)
            QLThumbnailGenerator.shared.generateRepresentations(for: request) { (thumb, type, error) in
                DispatchQueue.main.async {
                    self.imageView.image = thumb?.uiImage
                }
            }
        } else {
            // Fallback on earlier versions
        }
    }

    //MARK: - UIMenu
    //https://github.com/LoongerTao/TLAnimationTabBar
    @objc private func addMenuInteraction() {
//        if #available(iOS 13.0, *) {
//            let menuInteraction = UIContextMenuInteraction(delegate: self)
//            imageView.addInteraction(menuInteraction)
//        }
    }
    
    @available(iOS 13.0, *)
    class func createMenuButton() -> UIMenu {
        let actions: [UIAction] = (0...3).map {UIAction(title: "\($0 + 1) fen", image: nil) { _ in
            
        }}
        
        let first = UIMenu(title: "Favorite", image: UIImage(systemName: "heart"), children: actions)
        
//        let favorite = UIAction(title: "Favorite", image: UIImage(systemName: "heart")) { (action) in
//            debugPrint("click favorite")
//            self.thumbnailImage()
//        }
        
        var dynamicMenu: UIMenuElement = UIAction(title: "Share", image: UIImage(systemName: "square.and.arrow.up")) { (action) in
            //            debugPrint("click Share")
        }
        if #available(iOS 14.0, *) {
            let deferMenu = UIMenu(title: "Defer", children: [UIDeferredMenuElement({ complete in
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    let items = (1...2).map { UIAction(title: "Dynamic Menu Item \($0)") { action in }}
                    complete([UIMenu(title: "", options: .displayInline, children: items)])
                }
            })])
            dynamicMenu = deferMenu
        }
        
        let delete = UIAction(title: "Delete", image: UIImage(systemName: "trash"), identifier: nil) { (action) in
            debugPrint("click delete")
        }
        
        let menuActions = [first, dynamicMenu, delete]
        return UIMenu(title: "", image: nil, identifier: nil, options: .displayInline, children: menuActions)
    }

}

@available(iOS 13.0, *)
extension BlurViewController: UIContextMenuInteractionDelegate {
    func contextMenuInteraction(_ interaction: UIContextMenuInteraction, configurationForMenuAtLocation location: CGPoint) -> UIContextMenuConfiguration? {
        return UIContextMenuConfiguration(identifier: nil, previewProvider: { () -> UIViewController? in
            return nil
        }) { (menu) -> UIMenu? in
            return BlurViewController.createMenuButton()
        }
    }
}
