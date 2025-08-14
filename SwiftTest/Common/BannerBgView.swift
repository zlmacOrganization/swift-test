//
//  BannerBgView.swift
//  SwiftTest
//
//  Created by lezhi on 2018/6/22.
//  Copyright © 2018年 ZhangLiang. All rights reserved.
//

import UIKit
import Kingfisher

typealias BannerImageClickBlock = (_ selectIndex: Int) -> Void

@available(iOS 17.0, *)
class BannerBgView: UIView, UIScrollViewDelegate {
    var imageClickBlock: BannerImageClickBlock?
    
    private var bannerScrollView: UIScrollView?
    private var pageControl: UIPageControl?
    private var imageArray: Array<Any> = []
    private var timer: DispatchSourceTimer?
    private var curIndex: Int = 0
    private var currentTag: Int = 0
    
    let timerProgress = UIPageControlTimerProgress(preferredDuration: 1.5)
    
    //MARK: -

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureViews()
        
        NotificationCenter.default.addObserver(self, selector: #selector(bannerViewDidDisappear), name: .bannerViewDidDisappear, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(applicationEnterBackground), name: UIApplication.didEnterBackgroundNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(applicationEnterForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        debugPrint("BannerBgView deinit")
    }
    
    private func configureViews() {
        bannerScrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: kMainScreenWidth, height: self.frame.size.height))
        bannerScrollView?.delegate = self
        bannerScrollView?.isScrollEnabled = true
        bannerScrollView?.isPagingEnabled = true
        bannerScrollView?.bounces = true
        bannerScrollView?.showsVerticalScrollIndicator = false
        bannerScrollView?.showsHorizontalScrollIndicator = false
        bannerScrollView?.isUserInteractionEnabled = true
        self.addSubview(bannerScrollView!)
        
        pageControl = UIPageControl()
        pageControl?.pageIndicatorTintColor = UIColor.white
        pageControl?.currentPageIndicatorTintColor = CommonBgColor
        
        // 无限循环
        timerProgress.resetsToInitialPageAfterEnd = true
        // 切换时间，覆盖构造方法的值
        timerProgress.preferredDuration = 3.0
        // 自定义某一页的切换时间
        timerProgress.setDuration(1, forPage: 2)
        // 设置progress
        pageControl?.progress = timerProgress
        
        pageControl?.addTarget(self, action: #selector(pageControlChanged), for: .valueChanged)

        self.addSubview(pageControl!)
    }
    
    private func getBannerImageViewWith(index: Int) -> UIImageView {
        let bannerWidth = (bannerScrollView?.frame.size.width)!
        let bannerImageView = UIImageView(frame: CGRect(x: (CGFloat(index))*bannerWidth, y: 0, width: bannerWidth, height: (bannerScrollView?.frame.size.height)!))
        bannerImageView.contentMode = .scaleAspectFill
        bannerImageView.tag = index
        bannerImageView.clipsToBounds = true
        CommonFunction.addTapGesture(with: bannerImageView, target: self, action: #selector(bannerClick(gesture:)))
        
        return bannerImageView
    }
    
    @objc private func bannerClick(gesture: UITapGestureRecognizer) {
        let view = gesture.view
        if imageArray.count > 0 {
            if view?.tag == 0 {
                currentTag = imageArray.count - 1
            }else if view?.tag == imageArray.count + 1 {
                currentTag = 0
            }else {
                currentTag = (view?.tag)! - 1
            }
        }
        
        if self.imageClickBlock != nil {
            self.imageClickBlock!(currentTag)
        }
    }
    
    @objc func pageControlChanged(_ sender: UIPageControl) {
        let contentOffsetX = (bannerScrollView?.frame.size.width ?? kMainScreenWidth) * CGFloat(sender.currentPage)
        let contentOffset = CGPoint(x: contentOffsetX, y: 0)
        bannerScrollView?.setContentOffset(contentOffset, animated: true)
        
        timerProgress.resumeTimer()
    }
    
    @objc private func bannerPageChange() {
        let bannerWidth = (bannerScrollView?.frame.size.width ?? kMainScreenWidth)
        
        if pageControl?.currentPage == imageArray.count - 1 {
            pageControl?.currentPage = 0
            bannerScrollView?.setContentOffset(CGPoint(x: bannerWidth, y: 0), animated: false)
        }else{
            pageControl?.currentPage += 1
            let currentPage = CGFloat((pageControl?.currentPage ?? 0) + 1)
            bannerScrollView?.setContentOffset(CGPoint(x: bannerWidth*currentPage, y: 0), animated: true)
        }
    }
    
    func setBannerImageWith(bannerArray: Array<Dictionary<String, Any>>) {
        if bannerArray.count == 0 {
            return
        }
        
        let scrollHeight = self.frame.size.height
        imageArray = bannerArray
        
        if bannerArray.count == 1 {
            
        }else{
            for i in 0..<bannerArray.count + 2 {
                var dict = bannerArray[0]
                let bannerImage = getBannerImageViewWith(index: i)
                
                if i == 0 {
                    dict = bannerArray[bannerArray.count - 1]
                }else if i == imageArray.count + 1 {
                    dict = bannerArray[0]
                }else {
                    dict = bannerArray[i - 1]
                }
                
                let imageUrl = dict["imageUrl"] as! String
                bannerImage.kf.setImage(with: URL(string: imageUrl), placeholder: nil, options: [.transition(ImageTransition.fade(1))], progressBlock: nil, completionHandler: nil)
                bannerScrollView?.addSubview(bannerImage)
            }
        }
        
        pageControl?.numberOfPages = bannerArray.count
        pageControl?.frame = CGRect(x: 0, y: scrollHeight - 30, width: self.frame.size.width, height: 20)
        bannerScrollView?.contentOffset = CGPoint(x: self.frame.size.width, y: 0)
        bannerScrollView?.contentSize = CGSize(width: CGFloat(bannerArray.count + 2)*self.frame.size.width, height: self.frame.size.height)
        
        if bannerArray.count > 1 {
            pageControl?.isHidden = false
            timerProgress.resumeTimer()
            addScrollTimer()
        }else{
            pageControl?.isHidden = true
        }
    }
    
    //MARK: - UIScrollViewDelegate
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        let bannerWidth = (bannerScrollView?.frame.size.width)!
//        curIndex = Int((scrollView.contentOffset.x + bannerWidth*0.5)/bannerWidth)
//        
//        if scrollView.contentOffset.x > bannerWidth*CGFloat(imageArray.count) {
//            pageControl?.currentPage = 0
//        }else if scrollView.contentOffset.x < bannerWidth*0.5 {
//            pageControl?.currentPage = imageArray.count - 1
//        }else{
//            pageControl?.currentPage = curIndex - 1
//        }
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        stopScrollTimer()
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let bannerWidth = (bannerScrollView?.frame.size.width)!
        
//        if curIndex == imageArray.count + 1 {
//            scrollView.contentOffset = CGPoint(x: bannerWidth, y: 0)
//        }else if curIndex == 0 {
//            scrollView.contentOffset = CGPoint(x: bannerWidth*CGFloat(imageArray.count), y: 0)
//        }
        
//        stopScrollTimer()
//        addScrollTimer()
        
        let contentOffsetX = scrollView.contentOffset.x
        let index = contentOffsetX / bannerWidth
        pageControl?.currentPage = Int(index)
        
        timerProgress.pauseTimer()
    }
    
    //MARK: - timer
    private func addScrollTimer() {
        if timer == nil && imageArray.count > 1 {
//            timer = Timer.scheduledTimer(timeInterval: 7, target: self, selector: #selector(bannerPageChange), userInfo: nil, repeats: true)
//            RunLoop.current.add(timer!, forMode: RunLoop.Mode.common)
            
//            timer = CommonFunction.createGCDTimer(interval: .seconds(5), handler: {
//                self.bannerPageChange()
//            })
//            
//            timer?.resume()
        }
    }
    
    func stopScrollTimer() {
        if timer != nil {
            timer?.cancel()
            timer = nil
        }
    }
    
    //MARK: - notify
    @objc private func bannerViewDidDisappear() {
        stopScrollTimer()
        scrollViewDidEndDecelerating(bannerScrollView!)
    }
    
    @objc private func applicationEnterBackground() {
        stopScrollTimer()
        scrollViewDidEndDecelerating(bannerScrollView!)
    }
    
    @objc private func applicationEnterForeground() {
        addScrollTimer()
    }
}
