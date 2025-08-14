//
//  UIAlertController+Extension.swift
//  SwiftTest
//
//  Created by Liang Zhang on 2024/12/13.
//  Copyright © 2024 zhangliang. All rights reserved.
//

import Foundation
import UIKit

extension UIAlertController {
    //Set background color of UIAlertController
    func setBackgroundColor(color: UIColor) {
        if let bgView = self.view.subviews.first, let groupView = bgView.subviews.first, let contentView = groupView.subviews.first {
                contentView.backgroundColor = color
            }
    }
    
    //Set title font and title color
    func setTitle(font: UIFont?, color: UIColor?) {
        guard let title = self.title else { return }
        let attributedString = NSMutableAttributedString(string: title)
        
        if let titleFont = font {
            attributedString.addAttributes([NSAttributedString.Key.font: titleFont], range: NSMakeRange(0, title.utf8.count))
        }
        
        if let titleColor = color {
            attributedString.addAttributes([NSAttributedString.Key.foregroundColor: titleColor], range: NSMakeRange(0, title.utf8.count))
        }
        
        self.setValue(attributedString, forKey: "attributedTitle")
    }
    
    //Set message font and message color
    func setMessage(font: UIFont?, color: UIColor?) {
        guard let title = self.message else { return }
        let attributedString = NSMutableAttributedString(string: title)
        
        if let messageFont = font {
            attributedString.addAttributes([NSAttributedString.Key.font: messageFont], range: NSMakeRange(0, title.utf8.count))
        }
        
        if let messageColor = color {
            attributedString.addAttributes([NSAttributedString.Key.foregroundColor: messageColor], range: NSMakeRange(0, title.utf8.count))
        }
        
        self.setValue(attributedString, forKey: "attributedMessage")
    }
    
    //Set tint color of UIAlertController
    func setTint(color: UIColor) {
        self.view.tintColor = color
    }
}

extension UIAlertAction {
    func setTitle(color: UIColor?) {
        if let titleColor = color {
            self.setValue(titleColor, forKey: "titleTextColor")
        }
    }
}
