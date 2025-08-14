//
//  ZoomTransition.swift
//  SwiftTest
//
//  Created by zhangliang on 2021/9/6.
//  Copyright © 2021 zhangliang. All rights reserved.
//

import UIKit
import CoreGraphics

class ZoomTransition: NSObject, UIViewControllerAnimatedTransitioning {
    let transType: TransitionPushType
    
    init(transType: TransitionPushType) {
        self.transType = transType
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromVC = transitionContext.viewController(forKey: .from), let toVC = transitionContext.viewController(forKey: .to) else { return }
        
        if transType == .push {
            pushAnimationTransition(using: transitionContext, fromVC: fromVC, toVC: toVC)
        }else {
            popAnimationTransition(using: transitionContext, fromVC: toVC, toVC: fromVC)
        }
    }
    
    private func pushAnimationTransition(using transitionContext: UIViewControllerContextTransitioning, fromVC: UIViewController, toVC: UIViewController) {
        
        transitionContext.containerView.insertSubview(toVC.view, aboveSubview: fromVC.view)
        toVC.view.transform = toVC.view.transform.scaledBy(x: 0.01, y: 0.01)
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext)) {
            toVC.view.layer.transform = CATransform3DIdentity
        } completion: { _ in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
    }
    
    private func popAnimationTransition(using transitionContext: UIViewControllerContextTransitioning, fromVC: UIViewController, toVC: UIViewController) {
        
//        transitionContext.containerView.insertSubview(fromVC.view, aboveSubview: toVC.view)
        transitionContext.containerView.addSubview(fromVC.view)
        fromVC.view.alpha = 0
//        fromVC.view.transform = fromVC.view.transform.scaledBy(x: 0.01, y: 0.01)
        toVC.view.layer.transform = CATransform3DIdentity
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext)) {
//            fromVC.view.layer.transform = CATransform3DIdentity
            toVC.view.transform = toVC.view.transform.scaledBy(x: 0.01, y: 0.01)
        } completion: { _ in
            fromVC.view.alpha = 1
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
    }
}
