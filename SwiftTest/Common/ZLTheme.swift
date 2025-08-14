//
//  ZLTheme.swift
//  SwiftTest
//
//  Created by ZhangLiang on 2019/10/19.
//  Copyright © 2019 ZhangLiang. All rights reserved.
//

import Foundation
import UIKit

enum Icon: String {
    case leftBack = "left_back"
    case qqShare = "qq_share"
    case qzoneShare = "qzone_share"
    
    var image: UIImage {
        return UIImage(named: rawValue)!
    }
}

protocol CodableEnumeration: RawRepresentable, Codable where RawValue: Codable {
    static var defaultCase: Self { get }
}

extension CodableEnumeration {
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        do {
            let decoded = try container.decode(RawValue.self)
            self = Self.init(rawValue: decoded) ?? Self.defaultCase
        } catch {
            self = Self.defaultCase
        }
    }
}

enum Code: String, CodableEnumeration {

    static var defaultCase: Code {
        return .unknown
    }

    case success
    case failure
    case unknown
}
