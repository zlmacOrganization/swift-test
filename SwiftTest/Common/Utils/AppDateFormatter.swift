//
//  AppDateFormatter.swift
//  SwiftTest
//
//  Created by zhangliang on 2021/8/5.
//  Copyright © 2021 zhangliang. All rights reserved.
//

import UIKit

final class AppDateFormatter {
    static let shared = AppDateFormatter()
        
    private init() {}
    
    /*
              timeStyle | dateStyle
     .none    nothing
     .short   下午3:00   | 18/5/12
     .medium  下午3:00:00 | 2018年5月12日
     .long    GMT +8下午3:00:00 | 2018年5月12日
     .full    中国标准时间下午3:00:00 | 2018年5月12日 星期日
     */
    private let mediumDateFormatter: DateFormatter = {
        let df = DateFormatter()
        df.dateStyle = .medium
        df.timeStyle = .none
        
        return df
    }()
    
    private let mediumTimeFormatter: DateFormatter = {
        let df = DateFormatter()
        df.dateStyle = .none
        df.timeStyle = .medium
        
        return df
    }()
    
    private let mediumDateTimeFormatter: DateFormatter = {
        let df = DateFormatter()
        df.dateStyle = .medium
        df.timeStyle = .medium
        
        return df
    }()
    
    private let dateFormatter: DateFormatter = {
        let df = DateFormatter()
        return df
    }()

    func mediumDateString(from date: Date, format: String = "yyyy-MM-dd HH:mm:ss") -> String {
        mediumDateFormatter.dateFormat = format
        return mediumDateFormatter.string(from: date)
    }
    
    func mediumTimeString(from date: Date, format: String = "yyyy-MM-dd HH:mm:ss") -> String {
        mediumTimeFormatter.dateFormat = format
        return mediumTimeFormatter.string(from: date)
    }
    
    func mediumDateTimeString(from date: Date, format: String = "yyyy-MM-dd HH:mm:ss") -> String {
        mediumDateTimeFormatter.dateFormat = format
        return mediumDateTimeFormatter.string(from: date)
    }
    
    func dateString(from date: Date, format: String = "yyyy-MM-dd HH:mm:ss") -> String {
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: date)
    }
}
