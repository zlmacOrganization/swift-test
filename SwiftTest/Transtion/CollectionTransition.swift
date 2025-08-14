//
//  CollectionTrans.swift
//  SwiftTest
//
//  Created by zhangliang on 2021/5/21.
//  Copyright © 2021 zhangliang. All rights reserved.
//

import UIKit

enum TransitionPushType {
    case push, pop
}

class CollectionTransition: NSObject, UIViewControllerAnimatedTransitioning {
    let transType: TransitionPushType
    
    init(transType: TransitionPushType) {
        self.transType = transType
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.4
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        if transType == .push {
            pushAnimationTransition(using: transitionContext)
        }else {
            popAnimationTransition(using: transitionContext)
        }
    }
    
    private func pushAnimationTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from) as? CollectionDragViewController else {
            return
        }
        
        guard let toVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to) as? CollectionDetailViewController else {
            return
        }
        toVC.imageView.isHidden = true
        
        let imageView = fromVC.selectCell?.targetImageView
        let containerView = transitionContext.containerView
        
        let originFrame = imageView?.frame ?? .zero
//        imageView?.frame = CGRect(x: 0, y: 0, widt h: originFrame.width, height: originFrame.height)
        
        let imageFrame = containerView.convert(imageView?.frame ?? .zero, from: fromVC.selectCell)
        
        let selectImageView = createSelectImageView()
        selectImageView.image = imageView?.image
        selectImageView.frame = imageFrame
        
        imageView?.isHidden = true
        toVC.view.frame = transitionContext.finalFrame(for: toVC)
        toVC.view.alpha = 0
        
        containerView.addSubview(toVC.view)
        containerView.addSubview(selectImageView)
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext)) {
            var toFrame = toVC.imageView.frame
            if !UINavigationBar.appearance().isTranslucent {
                toFrame.origin.y += kNavBarAndStatusBarHeight
            }
            
            selectImageView.frame = toFrame
            toVC.view.alpha = 1
        } completion: { _ in
            imageView?.isHidden = false
            imageView?.frame = originFrame
            toVC.imageView.isHidden = false
            selectImageView.removeFromSuperview()
            
            transitionContext.completeTransition(true)
        }
    }
    
    private func popAnimationTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from) as? CollectionDetailViewController else {
            return
        }
        
        guard let toVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to) as? CollectionDragViewController else {
            return
        }
        
        let containerView = transitionContext.containerView
        
        var originFrame = fromVC.imageView.frame
        if !UINavigationBar.appearance().isTranslucent {
            originFrame.origin.y += kNavBarAndStatusBarHeight
        }
        
        let selectImageView = createSelectImageView()
        selectImageView.frame = originFrame
        selectImageView.image = fromVC.imageView.image
        
        let imageView = toVC.selectCell?.targetImageView
        
        containerView.addSubview(toVC.view)
        containerView.addSubview(selectImageView)
        
        fromVC.imageView.isHidden = true
        imageView?.isHidden = true
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext)) {
            let backFrame = imageView?.convert(imageView?.frame ?? .zero, to: containerView)
            selectImageView.frame = backFrame ?? CGRect(x: (kMainScreenWidth - 240)/2, y: (kMainScreenHeight - 240)/2, width: 240, height: 240)
            fromVC.view.alpha = 0
        } completion: { _ in
            imageView?.isHidden = false
            selectImageView.removeFromSuperview()
            fromVC.imageView.isHidden = false
            
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
    }
    
    private func createSelectImageView() -> UIImageView {
        let selectImageView = UIImageView()
        selectImageView.contentMode = .scaleAspectFill
        selectImageView.clipsToBounds = true
        
        return selectImageView
    }
}
