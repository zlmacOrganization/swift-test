//
//  CollectionDetailViewController.swift
//  SwiftTest
//
//  Created by zhangliang on 2021/5/24.
//  Copyright © 2021 zhangliang. All rights reserved.
//

import UIKit

class CollectionDetailViewController: BaseViewController {
    var imageView =  UIImageView()

    override func viewDidLoad() {
        super.viewDidLoad()

        configureViews()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
//        navigationController?.delegate = self
    }
    
    private func configureViews() {
        let imageWidth: CGFloat = 240
        imageView.frame = CGRect(x: (kMainScreenWidth - imageWidth)/2, y: (kMainScreenHeight - kNavBarAndStatusBarHeight - imageWidth)/2, width: imageWidth, height: imageWidth)
//        imageView.frame = CGRect(x: (kMainScreenWidth - imageWidth)/2, y: 200, width: imageWidth, height: imageWidth)
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.addTapGesture(target: self, action: #selector(baseBackButtonClick))
        view.addSubview(imageView)
    }
}

extension CollectionDetailViewController {
//    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
//
//        if operation == .pop && toVC.isKind(of: CollectionDragViewController.self) {
//            return CircleTransition(transType: .pop)
//        }
//
//        return nil
//    }
}
