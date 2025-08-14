//
//  CircleTransition.swift
//  SwiftTest
//
//  Created by zhangliang on 2021/9/6.
//  Copyright © 2021 zhangliang. All rights reserved.
//

import UIKit

class CircleTransition: NSObject, UIViewControllerAnimatedTransitioning {
    let transType: TransitionPushType
    
    init(transType: TransitionPushType) {
        self.transType = transType
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.8
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromVC = transitionContext.viewController(forKey: .from), let toVC = transitionContext.viewController(forKey: .to) else { return }
        
        if transType == .push {
            transitionContext.containerView.addSubview(toVC.view)
            transitionContext.containerView.bringSubviewToFront(toVC.view)
        }else {
            transitionContext.containerView.insertSubview(toVC.view, at: 0)
        }
        
        animationTransition(using: transitionContext, fromVC: fromVC, toVC: toVC)
    }
    
    private func animationTransition(using transitionContext: UIViewControllerContextTransitioning, fromVC: UIViewController, toVC: UIViewController) {
        
        let containerView = transitionContext.containerView
        //画起始圆
        let stratbezierPath = UIBezierPath(ovalIn: CGRect(x: containerView.zl_centerX, y: containerView.zl_centerY, width: 0.1, height: 0.1))
        let radius = sqrt(pow(containerView.zl_width/2, 2) + pow(containerView.zl_height/2, 2))
        let endbezierPath = UIBezierPath(arcCenter: containerView.center, radius: radius, startAngle: 0, endAngle: .pi*2, clockwise: true)
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = transType == .push ? endbezierPath.cgPath : stratbezierPath.cgPath
        
        if transType == .push {
            toVC.view.layer.mask = shapeLayer
        }else {
            fromVC.view.layer.mask = shapeLayer
        }
        
        let animation = CABasicAnimation(keyPath: "path")
        animation.keyPath = "path"
        animation.delegate = self
        animation.fromValue = transType == .push ? stratbezierPath.cgPath : endbezierPath.cgPath
        animation.toValue = transType == .push ? endbezierPath.cgPath : stratbezierPath.cgPath
        animation.duration = transitionDuration(using: transitionContext)
        animation.timingFunction = CAMediaTimingFunction(name: .easeIn)
        animation.setValue(transitionContext, forKey: "transitionContext")
        shapeLayer.add(animation, forKey: "path")
    }
}

extension CircleTransition: CAAnimationDelegate {
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        
        guard let context = anim.value(forKey: "transitionContext") as? UIViewControllerContextTransitioning else { return }
        
        if transType == .push {
            context.completeTransition(!context.transitionWasCancelled)
        }else {
//            if context.transitionWasCancelled {
                if let fromVC = context.viewController(forKey: .from) {
                    fromVC.view.layer.mask = nil
                }
//            }
            context.completeTransition(!context.transitionWasCancelled)
        }
    }
}
