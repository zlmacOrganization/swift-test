//
//  GlobalData.swift
//  SwiftTest
//
//  Created by ZhangLiang on 17/1/10.
//  Copyright © 2017年 ZhangLiang. All rights reserved.
//

import UIKit

//final关键字的作用是这个类或方法不希望被继承和重写
final class GlobalData: NSObject {
    static let shareInstance = GlobalData()
    
    private override init() {
        
    }
    
    var userPhoneNum: String?
    var numArray: Array<Any> = []
}
