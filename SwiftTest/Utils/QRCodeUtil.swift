//
//  QRCodeUtil.swift
//  SwiftTest
//
//  Created by zhangliang on 2022/5/7.
//  Copyright © 2022 zhangliang. All rights reserved.
//

import Foundation
import UIKit

protocol Barcodable {
    var name: String { get }
    var properties: [String: Any] { get }
}

struct BarcodeService {
    static func generateBarcode(from barcode: Barcodable, scalar: CGFloat = 3.0) -> UIImage? {
        if let filter = CIFilter(name: barcode.name) {
            filter.setValuesForKeys(barcode.properties)
            
            let transform = CGAffineTransform(scaleX: scalar, y: scalar)
            if let output = filter.outputImage?.transformed(by: transform) {
                return UIImage(ciImage: output)
            }
        }
        return nil
    }
}

/// Generate an Aztec barcode image for message data.
struct AztecBarcode: Barcodable {
    let name = "CIAztecCodeGenerator"

    /// Force a compact style Aztec code to true or false. Set to nil for automatic.
    let inputCompactStyle: Bool?

    /// Aztec error correction value between 5 and 95
    let inputCorrectionLevel: NSNumber

    /// Aztec layers value between 1 and 32. Set to nil for automatic.
    let inputLayers: NSNumber?

    /// The message to encode in the Aztec Barcode
    let inputMessage: Data

    init(inputCompactStyle: Bool? = nil, inputCorrectionLevel: NSNumber = 5.0, inputLayers: NSNumber? = nil, inputMessage: Data) throws {
        self.inputCompactStyle = inputCompactStyle
        self.inputCorrectionLevel = inputCorrectionLevel
        self.inputLayers = inputLayers
        self.inputMessage = inputMessage
    }
    
    var properties: [String: Any] {
        var response: [String: Any] = [:]
        
        if let inputCompactStyle = inputCompactStyle {
            response["inputCompactStyle"] = inputCompactStyle
        }

        response["inputCorrectionLevel"] = inputCorrectionLevel

        if let inputLayers = inputLayers {
            response["inputLayers"] = inputLayers
        }

        response["inputMessage"] = NSData(data: inputMessage)
        
        return response
    }
}

struct QRCode: Barcodable {
    enum QRCorrectionLevel: String {
        case l
        case m
        case q
        case h
    }

    let name = "CIQRCodeGenerator"

    /// QR Code correction level L, M, Q, or H.
    let inputCorrectionLevel: QRCorrectionLevel = .m

    /// The message to encode in the QR Code
    let inputMessage: Data
    
    var properties: [String: Any] {
        [
            "inputCorrectionLevel": inputCorrectionLevel.rawValue.uppercased(),
            "inputMessage": NSData(data: inputMessage)
        ]
    }
}


/// Generate a Code 128 barcode image for message data.
struct Code128Barcode: Barcodable {
    let name = "CICode128BarcodeGenerator"

    /// The message to encode in the Code 128 Barcode
    let inputMessage: Data

    /// The number of empty white pixels that should surround the barcode. (Scalar. Min: 0.0 Max: 100.0)
    let inputQuietSpace: NSNumber

    /// The height of the generated barcode in pixels. (Scalar. Min: 1.0 Max: 500.0)
    let inputBarcodeHeight: NSNumber

    var properties: [String: Any] {
        [
            "inputBarcodeHeight": inputBarcodeHeight,
            "inputQuietSpace": inputQuietSpace,
            "inputMessage": inputMessage as NSData
        ]
    }
    
    // Usage:
//    if let data = "http://www.digitalbunker.dev".data(using: .ascii) {
//        let code128Barcode = Code128Barcode(inputMessage: data, inputQuietSpace: 20, inputBarcodeHeight: 100)
//        imageView.image = BarcodeService.generateBarcode(from: code128Barcode)
//    }
}
