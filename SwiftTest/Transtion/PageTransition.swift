//
//  PageTransition.swift
//  SwiftTest
//
//  Created by zhangliang on 2021/9/6.
//  Copyright © 2021 zhangliang. All rights reserved.
//

import UIKit

class PageTransition: NSObject, UIViewControllerAnimatedTransitioning {
    let transType: TransitionPushType
    
    init(transType: TransitionPushType) {
        self.transType = transType
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 1.0
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
        var transfrom3D = CATransform3DIdentity
        transfrom3D.m34 = -0.002
        
        let containerView = transitionContext.containerView
        containerView.layer.sublayerTransform = transfrom3D
        containerView.addSubview(toVC.view)
        containerView.addSubview(fromVC.view)
        
        PageTransition.setAnchorPoint(to: fromVC.view, point: CGPoint(x: 0, y: 0.5))
        PageTransition.addShadow(to: fromVC.view, direction: 0)
        fromVC.view.subviews.last?.alpha = 0
        PageTransition.addShadow(to: toVC.view, direction: 0)
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext)) {
            fromVC.view.subviews.last?.alpha = 1
            toVC.view.subviews.last?.alpha = 0
            fromVC.view.layer.transform = CATransform3DMakeRotation(-.pi/2, 0, 1, 0)
        } completion: { _ in
            if !transitionContext.transitionWasCancelled {
                fromVC.view.layer.transform = CATransform3DIdentity
                fromVC.view.subviews.last?.removeFromSuperview()
                toVC.view.subviews.last?.removeFromSuperview()
            }
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
    }
    
    private func popAnimationTransition(using transitionContext: UIViewControllerContextTransitioning, fromVC: UIViewController, toVC: UIViewController) {
        var transfrom3D = CATransform3DIdentity
        transfrom3D.m34 = -0.002
        
        let containerView = transitionContext.containerView
        containerView.layer.sublayerTransform = transfrom3D
        containerView.addSubview(toVC.view)
        containerView.addSubview(fromVC.view)
        
        PageTransition.setAnchorPoint(to: fromVC.view, point: CGPoint(x: 0, y: 0.5))
        PageTransition.addShadow(to: fromVC.view, direction: 0)
        PageTransition.addShadow(to: toVC.view, direction: 0)
        
        toVC.view.subviews.last?.alpha = 0
        fromVC.view.layer.transform = CATransform3DMakeRotation(-.pi/2, 0, 1, 0)
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext)) {
            fromVC.view.subviews.last?.alpha = 0
            toVC.view.subviews.last?.alpha = 1
            fromVC.view.layer.transform = CATransform3DIdentity
        } completion: { _ in
            if !transitionContext.transitionWasCancelled {
                fromVC.view.subviews.last?.removeFromSuperview()
                toVC.view.subviews.last?.removeFromSuperview()
            }
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
    }
    
    class func addShadow(to view: UIView, direction: Int) {
        let typeView = UIView(frame: view.bounds)
        typeView.backgroundColor = .clear
        typeView.alpha = 1
        let layer = CAGradientLayer()
        layer.opacity = 1
        
        if direction == 0 {
            layer.colors = [UIColor.clear.cgColor, UIColor.black.cgColor]
        }else {
            layer.colors = [UIColor.black.cgColor, UIColor.clear.cgColor]
        }
        
        layer.frame = view.bounds
        layer.startPoint = CGPoint(x: 0, y: 1)
        layer.endPoint = CGPoint(x: 1, y: 1)
        typeView.layer.addSublayer(layer)
        view.addSubview(typeView)
    }
    
    class func setAnchorPoint(to view: UIView, point: CGPoint) {
        view.frame = view.frame.offsetBy(dx: (point.x - view.layer.anchorPoint.x) * view.frame.size.width, dy: (point.y - view.layer.anchorPoint.y) * view.frame.size.height)
        view.layer.anchorPoint = point
    }
}
