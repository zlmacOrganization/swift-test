//
//  UsefulCode.swift
//  SwiftTest
//
//  Created by zhangliang on 2020/11/12.
//  Copyright © 2020 zhangliang. All rights reserved.
//

import Foundation
import UIKit

let res = "14.23444".numDecimal()
//print(res)

//Option Pattern
//https://onevcat.com/2020/10/use-options-pattern/
protocol TrafficLightOption {
    associatedtype Value
    static var defaultValue: Value { get }
}

class TrafficLight {
    enum GreenLightColor: TrafficLightOption {
        case green, turquoise
        
        static var defaultValue: GreenLightColor = .green
    }
    
    private var options: [ObjectIdentifier: Any] = [:]
    
    subscript<T: TrafficLightOption>(option type: T.Type) -> T.Value {
        get {
            options[ObjectIdentifier(type)] as? T.Value ?? type.defaultValue
        }
        
        set {
            options[ObjectIdentifier(type)] = newValue
        }
    }
}

extension TrafficLight {
    //只要不进行设置，它便不会带来额外的开销
    var preferredGreenLightColor: TrafficLight.GreenLightColor {
        get {self[option: GreenLightColor.self]}
        set {self[option: GreenLightColor.self] = newValue}
    }
}

private func test() {
    let light = TrafficLight()
    light.preferredGreenLightColor = .turquoise
}

/*
 playload.apns
 {
     "aps" : {
         "alert" : {
             "title" : "test",
             "body" : "remote notification test"
         },
         "badge" : 1
     },
     "type": "7",
     "target": "973612_577322",
     "Simulator Target Bundle": "com.house730.pms.debug"
 }
 */
