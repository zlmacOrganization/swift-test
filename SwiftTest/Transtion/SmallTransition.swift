//
//  SmallTransition.swift
//  SwiftTest
//
//  Created by zhangliang on 2021/8/21.
//  Copyright © 2021 zhangliang. All rights reserved.
//

import UIKit

enum SmallTransitionType {
    case present, dismiss
}

class SmallTransition: NSObject, UIViewControllerAnimatedTransitioning {
    private var presentType: SmallTransitionType
    
    init(type: SmallTransitionType) {
        presentType = type
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.4
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        if presentType == .present {
            presentTransition(using: transitionContext)
        }else {
            dismissTransition(using: transitionContext)
        }
    }
    
    private func presentTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let toView = transitionContext.view(forKey: .to) else {
            transitionContext.completeTransition(true)
            return
        }
        
        let containerView = transitionContext.containerView
        toView.frame = CGRect(x: 0, y: kMainScreenHeight, width: kMainScreenWidth, height: 300)
        containerView.addSubview(toView)
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: [], animations: {
            toView.frame.origin.y = 0
        }) { (completed) in
            transitionContext.completeTransition(completed)
        }
    }
    
    private func dismissTransition(using transitionContext: UIViewControllerContextTransitioning) {
//        let containerView = transitionContext.containerView
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveLinear) {
            if let toView = transitionContext.view(forKey: .from) {
                toView.frame.origin.y = kMainScreenHeight
            }
        } completion: { _ in
            transitionContext.completeTransition(true)
        }
    }
}
