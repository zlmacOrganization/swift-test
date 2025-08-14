//
//  HalfPageTransition.swift
//  SwiftTest
//
//  Created by zhangliang on 2021/9/6.
//  Copyright © 2021 zhangliang. All rights reserved.
//

import UIKit

class HalfPageTransition: NSObject, UIViewControllerAnimatedTransitioning {
    let transType: TransitionPushType
    
    init(transType: TransitionPushType) {
        self.transType = transType
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.8
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromVC = transitionContext.viewController(forKey: .from), let toVC = transitionContext.viewController(forKey: .to) else { return }
        
        pushAnimationTransition(using: transitionContext, fromVC: fromVC, toVC: toVC)
    }
    
    private func pushAnimationTransition(using transitionContext: UIViewControllerContextTransitioning, fromVC: UIViewController, toVC: UIViewController) {
        
        let containerView = transitionContext.containerView
        containerView.addSubview(toVC.view)
        
        let snapshots = creatSnapshots(view: fromVC.view, afterScreenUpdates: false)
        if snapshots.isEmpty {
            return
        }
        
        let stratVCright = snapshots[0]
        PageTransition.addShadow(to: stratVCright, direction: 0)
        stratVCright.subviews.last?.alpha = 0
        
        let stratVCleft = snapshots[1]
        PageTransition.addShadow(to: stratVCleft, direction: 1)
        stratVCleft.subviews.last?.alpha = 0
        
        var startRightTransform = CATransform3DIdentity
        startRightTransform.m34 = -0.002
        let view = transType == .push ? stratVCleft : stratVCright
        view.layer.transform = startRightTransform
        let startPoint = CGPoint(x: transType == .push ? 0 : 1, y: 0.5)
        PageTransition.setAnchorPoint(to: view, point: startPoint)
        
        //toVC
        let endSnapshots = creatSnapshots(view: toVC.view, afterScreenUpdates: true)
        if endSnapshots.isEmpty {
            return
        }
        
        let endVCright = endSnapshots[0]
        PageTransition.addShadow(to: endVCright, direction: 0)
        let endVCleft = endSnapshots[1]
        PageTransition.addShadow(to: endVCleft, direction: 1)
        
        var endVCLeft3D = CATransform3DIdentity
        endVCLeft3D.m34 = -0.002
        let endView = transType == .push ? endVCright : endVCleft
        endView.layer.transform = endVCLeft3D
        let endStartPoint = CGPoint(x: transType == .push ? 1 : 0, y: 0.5)
        PageTransition.setAnchorPoint(to: endView, point: endStartPoint)

        if transType == .push {
            endVCleft.layer.transform = CATransform3DRotate(endVCleft.layer.transform, -.pi/2, 0, 1, 0)
            containerView.addSubview(endVCright)
            containerView.addSubview(stratVCright)
            containerView.addSubview(stratVCleft)
            containerView.addSubview(endVCleft)
        }else {
            endVCright.layer.transform = CATransform3DRotate(endVCleft.layer.transform, -.pi/2, 0, 1, 0)
            containerView.addSubview(endVCleft)
            containerView.addSubview(stratVCright)
            containerView.addSubview(stratVCleft)
            containerView.addSubview(endVCright)
        }
        
        UIView.animateKeyframes(withDuration: transitionDuration(using: transitionContext), delay: 0, options: .calculationModeCubic) {
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.5) {
                stratVCright.subviews.last?.alpha = 1
                stratVCleft.subviews.last?.alpha = 1
                
                if self.transType == .push {
                    stratVCright.layer.transform = CATransform3DRotate(stratVCright.layer.transform, -.pi/2, 0, 1, 0)
                }else {
                    stratVCleft.layer.transform = CATransform3DRotate(stratVCright.layer.transform, -.pi/2, 0, 1, 0)
                }
            }
            
            UIView.addKeyframe(withRelativeStartTime: 0.5, relativeDuration: 0.5) {
                endVCleft.subviews.last?.alpha = 1
                endVCright.subviews.last?.alpha = 1
                
                if self.transType == .push {
                    endVCleft.layer.transform = CATransform3DIdentity
                }else {
                    endVCright.layer.transform = CATransform3DIdentity
                }
            }
        } completion: { _ in
            if !transitionContext.transitionWasCancelled {
                stratVCright.removeFromSuperview()
                stratVCleft.removeFromSuperview()
                endVCright.removeFromSuperview()
                endVCleft.removeFromSuperview()
            }
            
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
    }
    
    private func popAnimationTransition(using transitionContext: UIViewControllerContextTransitioning, fromVC: UIViewController, toVC: UIViewController) {
        
        let containerView = transitionContext.containerView
        containerView.addSubview(toVC.view)
        
        let snapshots = creatSnapshots(view: toVC.view, afterScreenUpdates: false)
        if snapshots.isEmpty {
            return
        }
        
        let stratVCright = snapshots[0]
        PageTransition.addShadow(to: stratVCright, direction: 0)
        stratVCright.subviews.last?.alpha = 0
        
        let stratVCleft = snapshots[1]
        PageTransition.addShadow(to: stratVCleft, direction: 1)
        stratVCleft.subviews.last?.alpha = 0
        
        var startRightTransform = CATransform3DIdentity
        startRightTransform.m34 = -0.002
        stratVCleft.layer.transform = startRightTransform
        PageTransition.setAnchorPoint(to: stratVCleft, point: CGPoint(x: 0, y: 0.5))
        
        //toVC
        let endSnapshots = creatSnapshots(view: toVC.view, afterScreenUpdates: true)
        if endSnapshots.isEmpty {
            return
        }
        
        let endVCright = endSnapshots[0]
        PageTransition.addShadow(to: endVCright, direction: 0)
        let endVCleft = endSnapshots[1]
        PageTransition.addShadow(to: endVCleft, direction: 1)
        
        var endVCLeft3D = CATransform3DIdentity
        endVCLeft3D.m34 = -0.002
        endVCright.layer.transform = endVCLeft3D
        PageTransition.setAnchorPoint(to: endVCright, point: CGPoint(x: 1, y: 0.5))
        endVCright.layer.transform = CATransform3DRotate(endVCright.layer.transform, .pi/2, 0, 1, 0)
        
        UIView.animateKeyframes(withDuration: transitionDuration(using: transitionContext), delay: 0, options: .calculationModeCubic) {
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.5) {
                stratVCright.subviews.last?.alpha = 1
                stratVCleft.subviews.last?.alpha = 1
                stratVCleft.layer.transform = CATransform3DRotate(stratVCright.layer.transform, -.pi/2, 0, 1, 0)
            }
            
            UIView.addKeyframe(withRelativeStartTime: 0.5, relativeDuration: 0.5) {
                endVCleft.subviews.last?.alpha = 0
                endVCright.subviews.last?.alpha = 0
                endVCright.layer.transform = CATransform3DIdentity
            }
        } completion: { _ in
            if !transitionContext.transitionWasCancelled {
                stratVCright.removeFromSuperview()
                stratVCleft.removeFromSuperview()
                endVCright.removeFromSuperview()
                endVCleft.removeFromSuperview()
            }
            
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
    }
    
    private func creatSnapshots(view: UIView, afterScreenUpdates: Bool) -> [UIView] {
        let rightViewFrame = CGRect(x: 0, y: 0, width: view.zl_width/2, height: view.zl_height)
        let rightView = view.resizableSnapshotView(from: rightViewFrame, afterScreenUpdates: afterScreenUpdates, withCapInsets: UIEdgeInsets.zero)
        rightView?.frame = rightViewFrame
        
        let leftViewFrame = CGRect(x: view.zl_width/2, y: 0, width: view.zl_width/2, height: view.zl_height)
        let leftView = view.resizableSnapshotView(from: leftViewFrame, afterScreenUpdates: afterScreenUpdates, withCapInsets: UIEdgeInsets.zero)
        leftView?.frame = leftViewFrame
        
        guard let left = leftView, let right = rightView else { return [] }
        
        return [right, left]
    }
}
