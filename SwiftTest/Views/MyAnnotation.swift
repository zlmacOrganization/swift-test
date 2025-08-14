//
//  MyAnnotation.swift
//  SwiftTest
//
//  Created by ZhangLiang on 16/12/17.
//  Copyright © 2016年 ZhangLiang. All rights reserved.
//

import UIKit
import MapKit

class MyAnnotation: NSObject , MKAnnotation{
    var coordinate: CLLocationCoordinate2D = CLLocationCoordinate2DMake(0, 0)
    private var testTitle: String!
    private var testSubtitle: String!
    
    init(coordinate: CLLocationCoordinate2D, title: String, subtitle: String) {
        self.coordinate = coordinate
        self.testTitle = title
        self.testSubtitle = subtitle
        super.init()
    }
}
