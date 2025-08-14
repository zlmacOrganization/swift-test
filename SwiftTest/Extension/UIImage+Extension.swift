//
//  UIImage+Extension.swift
//  SwiftTest
//
//  Created by zhangliang on 2022/8/2.
//  Copyright © 2022 zhangliang. All rights reserved.
//

import Foundation
import UIKit
import Accelerate
import Vision

extension UIImage {
    func imageWith(tintColor: UIColor) -> UIImage {
        if #available(iOS 13.0, *) {
            return self.withTintColor(tintColor)
        }else {
            UIGraphicsBeginImageContextWithOptions(self.size, false, 0.0)
            tintColor.setFill()
            
            let bounds = CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height)
            UIRectFill(bounds)
            self.draw(in: bounds, blendMode: .destinationIn, alpha: 1.0)
            
            guard let image = UIGraphicsGetImageFromCurrentImageContext() else {
                return UIImage()
            }
            UIGraphicsEndImageContext()
            
//            let format = UIGraphicsImageRendererFormat()
//            format.opaque = false
//            format.scale = 0
//            
//            let render = UIGraphicsImageRenderer(size: self.size, format: format)
//            let resultImage = render.image { context in
//                let rect = CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height)
//                tintColor.setFill()
//                UIRectFill(rect)
//            }
//            return resultImage
            
            return image
        }
    }
    
    func gray() -> UIImage? {
        let width = self.size.width
        let height = self.size.height
        let colorSpace = CGColorSpaceCreateDeviceGray()
        let bitmapInfo = CGImageAlphaInfo.premultipliedLast.rawValue
        
        let context = CGContext(data: nil, width: Int(width), height: Int(height), bitsPerComponent: 8, bytesPerRow: 0, space: colorSpace, bitmapInfo: bitmapInfo)
        
        if let cgImage = self.cgImage {
            context?.draw(cgImage, in: CGRect(x: 0, y: 0, width: width, height: height))
            if let contextImage = context?.makeImage() {
                let grayImage = UIImage(cgImage: contextImage)
                return grayImage
            }
        }
        
        return nil
    }
    
    //https://juejin.im/post/5ddc8258518825734f2b8eb2
    //用子线程绘制，会出现CPU略微升高，当image size大很多的时候会出现内存飙升然后慢慢恢复到normal
    func resizeIamge_render(targetSize: CGSize) -> UIImage? {
        let size = self.size
        
        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height
        
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
        }
        
        if #available(iOS 10.0, *) {
            let render = UIGraphicsImageRenderer(size: self.size)
            return render.image { (context) in
                draw(in: CGRect(origin: .zero, size: newSize))
            }
        }else {
            UIGraphicsBeginImageContext(newSize)
            draw(in: CGRect(origin: .zero, size: newSize))
            
            let resultImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return resultImage
        }
    }
    
    //使用上下文绘制 cpu 和内存变化如下,CPU和内存没有大的变动解决了该问题，也做到省电、顺滑
    func resizeIamge_graphic(size: CGSize) -> UIImage? {
//        guard let imageSource = CGImageSourceCreateWithURL(url as CFURL, nil), let sourceCgimage = CGImageSourceCreateImageAtIndex(imageSource, 0, nil) else { return nil }
        
        guard let sourceCgimage = self.cgImage else { return nil }
        
        let ctx = CGContext(data: nil, width: Int(size.width), height: Int(size.height), bitsPerComponent: sourceCgimage.bitsPerComponent, bytesPerRow: sourceCgimage.bytesPerRow, space: sourceCgimage.colorSpace ?? CGColorSpace(name: CGColorSpace.sRGB)!, bitmapInfo: UInt32(Int(sourceCgimage.bitsPerComponent)))
        ctx?.interpolationQuality = .high
        ctx?.draw(sourceCgimage, in: CGRect(origin: .zero, size: size))
        
        guard let scaleImage = ctx?.makeImage() else { return nil }
        let img = UIImage(cgImage: scaleImage)
        
        return img
    }
    
    //官方推荐
    func downsampleImage(_ imageUrl: URL) -> UIImage? {
        let filePath = "/image.jpg"
        let url = NSURL(fileURLWithPath: filePath)
        
        if let imageSource = CGImageSourceCreateWithURL(url, nil) {
//            let properties = CGImageSourceCopyPropertiesAtIndex(imageSource, 0, nil)
            let options: [NSString: Any] = [kCGImageSourceThumbnailMaxPixelSize: 100,
                                   kCGImageSourceCreateThumbnailFromImageAlways: true]
            guard let scaledImage = CGImageSourceCreateThumbnailAtIndex(imageSource, 0, options as CFDictionary) else {
                return nil
            }
            
            return UIImage(cgImage: scaledImage)
        }
        
        return nil
    }
    
    func downsampleImage(at URL: NSURL, maxSize: Float) -> UIImage?
    {
        let sourceOptions = [kCGImageSourceShouldCache:false] as CFDictionary
        guard let source = CGImageSourceCreateWithURL(URL as CFURL, sourceOptions) else {
            return nil
        }
        let downsampleOptions = [kCGImageSourceCreateThumbnailFromImageAlways:true,
                                 kCGImageSourceThumbnailMaxPixelSize:maxSize,
                                 kCGImageSourceShouldCacheImmediately:true,
                                 kCGImageSourceCreateThumbnailWithTransform:true,
        ] as CFDictionary
        
        guard let downsampledImage = CGImageSourceCreateThumbnailAtIndex(source, 0, downsampleOptions) else {
            return nil
        }
        
        return UIImage(cgImage: downsampledImage)
    }
    
    //模糊效果 level: 0~1数值越大越模糊
    func vImage_blur(_ level: CGFloat) -> UIImage? {
        var levelValue: CGFloat = level
        if level < 0 {
            levelValue = 0.1
        } else if level > 1.0 {
            levelValue = 1.0
        }
        
        // boxSize 必须大于 0
        var boxSize = Int(levelValue * 100)
        boxSize -= (boxSize % 2) + 1
        
        guard let cgImage = self.cgImage else { return nil }
        
        // 图像缓存: 输入缓存、输出缓存
        var inBuffer = vImage_Buffer()
        var outBuffer = vImage_Buffer()
        var error = vImage_Error()
        
        let inProvider = cgImage.dataProvider
        let inBitmapData = inProvider?.data
        
        inBuffer.width = vImagePixelCount(cgImage.width)
        inBuffer.height = vImagePixelCount(cgImage.height)
        inBuffer.rowBytes = cgImage.bytesPerRow
        inBuffer.data = UnsafeMutableRawPointer(mutating: CFDataGetBytePtr(inBitmapData))
        
        // 像素缓存
        let pixelBuffer = malloc(cgImage.bytesPerRow * cgImage.height)
        outBuffer.data = pixelBuffer
        outBuffer.width = vImagePixelCount(cgImage.width)
        outBuffer.height = vImagePixelCount(cgImage.height)
        outBuffer.rowBytes = cgImage.bytesPerRow
        
        // 中间缓存区, 抗锯齿
        let pixelBuffer2 = malloc(cgImage.bytesPerRow * cgImage.height)
        var outBuffer2 = vImage_Buffer()
        outBuffer2.data = pixelBuffer2
        outBuffer2.width = vImagePixelCount(cgImage.width)
        outBuffer2.height = vImagePixelCount(cgImage.height)
        outBuffer2.rowBytes = cgImage.bytesPerRow
        
        error = vImageBoxConvolve_ARGB8888(&inBuffer, &outBuffer2, nil, 0, 0, UInt32(boxSize), UInt32(boxSize), nil, vImage_Flags(kvImageEdgeExtend))
        error = vImageBoxConvolve_ARGB8888(&outBuffer2, &outBuffer, nil, 0, 0, UInt32(boxSize), UInt32(boxSize), nil, vImage_Flags(kvImageEdgeExtend))
        
        if error != kvImageNoError {
            ZFPrint("vimage error: \(error)")
        }
        
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let ctx = CGContext(data: outBuffer.data, width: Int(outBuffer.width), height: Int(outBuffer.height), bitsPerComponent: 8, bytesPerRow: outBuffer.rowBytes, space: colorSpace, bitmapInfo: cgImage.bitmapInfo.rawValue)
        
        guard let finalCGImage = ctx?.makeImage() else {
            free(pixelBuffer)
//            free(pixelBuffer2)
            return nil
        }
        
        let resultImage = UIImage(cgImage: finalCGImage)
        
        free(pixelBuffer)
//        free(pixelBuffer2)
        
        return resultImage
    }
    
    /// 经纪人头像对图片做裁剪
    func clipHeaderImag() -> UIImage {
        if let cgImage = self.cgImage {
            // 裁剪后的图片
            if let newCGImage = cgImage.cropping(to: CGRect.init(x: 0, y: 0, width: self.size.width, height: self.size.width)) {
                let finalImage = UIImage.init(cgImage: newCGImage,
                                              scale: self.scale,
                                              orientation: self.imageOrientation)
                return finalImage
            }
        }
        
        return self
    }
    
    /// 修复图片旋转
    func fixOrientation() -> UIImage {
        
        if self.imageOrientation == .up {
            return self
        }
        
        var transform = CGAffineTransform.identity
        
        switch self.imageOrientation {
        case .down, .downMirrored:
            transform = transform.translatedBy(x: self.size.width, y: self.size.height)
            transform = transform.rotated(by: .pi)
            break
            
        case .left, .leftMirrored:
            transform = transform.translatedBy(x: self.size.width, y: 0)
            transform = transform.rotated(by: .pi / 2)
            break
            
        case .right, .rightMirrored:
            transform = transform.translatedBy(x: 0, y: self.size.height)
            transform = transform.rotated(by: -.pi / 2)
            break
            
        default:
            break
        }
        
        switch self.imageOrientation {
        case .upMirrored, .downMirrored:
            transform = transform.translatedBy(x: self.size.width, y: 0)
            transform = transform.scaledBy(x: -1, y: 1)
            break
            
        case .leftMirrored, .rightMirrored:
            transform = transform.translatedBy(x: self.size.height, y: 0);
            transform = transform.scaledBy(x: -1, y: 1)
            break
            
        default:
            break
        }
        
        guard let cgImage = self.cgImage, let colorSpace = cgImage.colorSpace else { return self }
        
        let ctx = CGContext(data: nil, width: Int(self.size.width), height: Int(self.size.height), bitsPerComponent: cgImage.bitsPerComponent, bytesPerRow: 0, space: colorSpace, bitmapInfo: cgImage.bitmapInfo.rawValue)
        ctx?.concatenate(transform)
        
        switch self.imageOrientation {
        case .left, .leftMirrored, .right, .rightMirrored:
            ctx?.draw(cgImage, in: CGRect(x: CGFloat(0), y: CGFloat(0), width: CGFloat(size.height), height: CGFloat(size.width)))
            break
            
        default:
            ctx?.draw(cgImage, in: CGRect(x: CGFloat(0), y: CGFloat(0), width: CGFloat(size.width), height: CGFloat(size.height)))
            break
        }
        
        let cgimg: CGImage = ctx?.makeImage() ?? cgImage
        let img = UIImage(cgImage: cgimg)
        
        return img
    }
    
    func adjustBrightness(value: Float) -> UIImage? {
        guard let ciImage = CIImage(image: self) else { return nil }
        let filter = CIFilter(name: "CIColorControls")
        filter?.setValue(ciImage, forKey: kCIInputImageKey)
        filter?.setValue(value, forKey: kCIInputBrightnessKey)
        let context = CIContext(options: nil)
        if let output = filter?.outputImage, let cgImage = context.createCGImage(output, from: output.extent) {
            let resultImage = UIImage(cgImage: cgImage)
            return resultImage
        }
        return nil
    }
    
    func adjustContrast(value: Float) -> UIImage? {
        guard let ciImage = CIImage(image: self) else { return nil }
        let filter = CIFilter(name: "CIColorControls")
        filter?.setValue(ciImage, forKey: kCIInputImageKey)
        filter?.setValue(value, forKey: kCIInputContrastKey)
        let context = CIContext(options: nil)
        if let output = filter?.outputImage, let cgImage = context.createCGImage(output, from: output.extent) {
            let resultImage = UIImage(cgImage: cgImage)
            return resultImage
        }
        return nil
    }
    
    //MARK: - Vision
    @available(iOS 11.0, *)
    func detectQRCode(block: @escaping (VNBarcodeObservation?) -> Void) {
        guard let cgImage = self.cgImage else {
            block(nil)
            return
        }
        
        SwiftNotice.wait()
        let imageHandle = VNImageRequestHandler(cgImage: cgImage)
        let request = VNDetectBarcodesRequest()
        request.symbologies = [.qr, .code128]
        
        if #available(iOS 15.0, *) {
            request.symbologies = [.codabar, .code128, .qr]
            request.revision = VNDetectBarcodesRequestRevision2
        }
        
        DispatchQueue.global(qos: .userInitiated).async {
            do {
                try imageHandle.perform([request])
            } catch {
                block(nil)
                print("detect error: \(error.localizedDescription)")
            }
            
            DispatchQueue.main.async {
                SwiftNotice.clear()
                if let observation = request.results?.first {
                    block(observation)
                    print("playload: \(observation.payloadStringValue ?? "-")")
                }else {
                    block(nil)
                    print("no results")
                }
            }
        }
    }
    
    @available(iOS 13.0, *)
    func textRecognize(block: @escaping ([VNObservation]?) -> Void) {
        guard let cgImage = self.cgImage else {
            block(nil)
            return
        }
        
        SwiftNotice.wait()
        let textRequest = VNRecognizeTextRequest { request, error in
            DispatchQueue.main.async {
                SwiftNotice.clear()
                guard let results = request.results, !results.isEmpty else {
                    block(nil)
                    return
                }
                
                block(results)
                
//                    for result in results {
//                        if let observation = result as? VNRecognizedTextObservation {
//                            for text in observation.topCandidates(1) {
//                                print("string: \(text.string)")
//                                print("confidence: \(text.confidence)")
//    //                                print(observation.boundingBox)
//                                print("\n")
//                            }
//                        }
//                    }
            }
        }
        textRequest.recognitionLevel = .accurate
        textRequest.usesLanguageCorrection = false
        
        if #available(iOS 15.0, *) {
            do {
                let supportLanauages = try textRequest.supportedRecognitionLanguages()
                print("supportLanauages: \(supportLanauages)")
                textRequest.recognitionLanguages = ["zh-Hans", "zh-Hant"]
            } catch {
                
            }
        }
        
        let imageHandle = VNImageRequestHandler(cgImage: cgImage)
        DispatchQueue.global(qos: .userInitiated).async {
            do {
                try imageHandle.perform([textRequest])
            } catch {
                block(nil)
                print("detect error: \(error.localizedDescription)")
            }
        }
    }
    
    @available(iOS 15.0, *)
    func documentRecognize(block: @escaping (VNRectangleObservation?) -> Void) {
        guard let cgImage = self.cgImage else {
            block(nil)
            return
        }
        
        SwiftNotice.wait()
//        let orientation = CGImagePropertyOrientation(rawValue: UInt32(self.imageOrientation.rawValue)) ?? CGImagePropertyOrientation(rawValue: UInt32(UIImage.Orientation.up.rawValue))
        let imageHandle = VNImageRequestHandler(cgImage: cgImage)
        let request = VNDetectDocumentSegmentationRequest()
        request.revision = VNDetectDocumentSegmentationRequestRevision1
        
        DispatchQueue.global(qos: .userInitiated).async {
            do {
                try imageHandle.perform([request])
            } catch {
                block(nil)
                print("detect error: \(error.localizedDescription)")
            }
            
            DispatchQueue.main.async {
                SwiftNotice.clear()
                if let result = request.results?.first, result.confidence > 0.7 {
                    block(result)
                }else {
                    block(nil)
                    print("未检测到文档")
                }
            }
        }
    }
    
    func trim(result: VNRectangleObservation) -> UIImage? {
        guard let ciImage = self.ciImage else {
            return nil
        }
        let imageSize = ciImage.extent.size
        let boundingBox = result.boundingBox
        let correctedImage = ciImage
            .cropped(to: boundingBox)
            .perspectiveCorrect(by: result, imageSize: imageSize)
        
        return UIImage(ciImage: correctedImage)
    }
    
    //MARK: - compress
    //https://juejin.cn/post/6844903758200061960
    //压缩图片质量
    func compressImageQuality(toByte maxLength: Int) -> UIImage {
        var compression: CGFloat = 1
        guard var data = self.jpegData(compressionQuality: compression),
            data.count > maxLength else { return self }
        
        var max: CGFloat = 1
        var min: CGFloat = 0
        for _ in 0..<6 {
            compression = (max + min) / 2
            data = self.jpegData(compressionQuality: compression) ?? Data()
            if CGFloat(data.count) < CGFloat(maxLength) * 0.9 {
                min = compression
            } else if data.count > maxLength {
                max = compression
            } else {
                break
            }
        }
        return UIImage(data: data) ?? self
    }
    
    //压缩图片尺寸(图片会模糊)
    func compressImageSize(toByte maxLength: Int) -> UIImage {
        guard var data = self.jpegData(compressionQuality: 1) else { return self }
        
        var resultImage: UIImage = self
        var lastDataLength: Int = 0
        while data.count > maxLength, data.count != lastDataLength {
            lastDataLength = data.count
            let ratio: CGFloat = CGFloat(maxLength) / CGFloat(data.count)
            let size: CGSize = CGSize(width: Int(resultImage.size.width * sqrt(ratio)),
                                    height: Int(resultImage.size.height * sqrt(ratio)))
            UIGraphicsBeginImageContext(size)
            resultImage.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
            resultImage = UIGraphicsGetImageFromCurrentImageContext()!
            UIGraphicsEndImageContext()
            data = resultImage.jpegData(compressionQuality: 1) ?? Data()
        }
        return resultImage
    }
    
    //MARK: - thumbnail
    @available(iOS 15.0, *)
    func getPreparingThumbnail(_ size: CGSize) async -> UIImage? {
        return await self.byPreparingThumbnail(ofSize: size)
    }
    
    @available(iOS 15.0, *)
    func zl_getPrepareThumbnail(size: CGSize, completionHandler: @escaping (UIImage?) -> Void) {
        self.prepareThumbnail(of: size) { image in
            DispatchQueue.main.async {
                completionHandler(image)
            }
        }
    }
    
    func zl_preparingThumbnail(_ size: CGSize) -> UIImage? {
        if #available(iOS 15.0, *) {
            return self.preparingThumbnail(of: size)
        }else {
            return self
        }
    }
    
    var thumbnail: UIImage? {
//        get async {
//            let size = CGSize(width: 40, height: 40)
//            return await self.byPreparingThumbnail(ofSize: size)
//        }
        
        get {
            if #available(iOS 15.0, *) {
                let size = CGSize(width: 40, height: 40)
                return self.preparingThumbnail(of: size)
            }
            return self
        }
    }
    
    //MARK: - 图片添加水印(文字)
    func addTextWatermark(text: String, textColor: UIColor, frame: CGRect? = nil, font: UIFont = UIFont.systemFont(ofSize: 35)) -> UIImage {
        let textAttributes = [NSAttributedString.Key.font: font, NSAttributedString.Key.foregroundColor: textColor]
        
        UIGraphicsBeginImageContext(self.size)
        self.draw(in: CGRect(origin: .zero, size: self.size))
        
        var rect = frame
        if frame == nil {
            let height: CGFloat = 45
            let tWidth = text.calculateTextWidth(font: font, height: height)
            rect = CGRect(x: (self.size.width - tWidth)/2, y: (self.size.height - height)/2, width: self.size.width, height: self.size.height)
        }
        
        text.draw(in: rect ?? CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height), withAttributes: textAttributes)
        let watermarkedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return watermarkedImage ?? self
    }
}

extension CIImage {
    /// 视觉矫正， 把 distort 的弄正
    /// - Parameter observation: Vision返回的结果
    /// - Returns: 新的CIImage
    func perspectiveCorrect(by observation: VNRectangleObservation, imageSize: CGSize?) -> CIImage {
        let imageSize = imageSize ?? self.extent.size
        let newImage =
        applyingFilter("CIPerspectiveCorrection", parameters: [
            "inputTopLeft": CIVector(cgPoint: observation.topLeft.scaled(to: imageSize)),
            "inputTopRight": CIVector(cgPoint: observation.topRight.scaled(to: imageSize)),
            "inputBottomLeft": CIVector(cgPoint: observation.bottomLeft.scaled(to: imageSize)),
            "inputBottomRight": CIVector(cgPoint: observation.bottomRight.scaled(to: imageSize))
        ])
        return newImage
    }
}

extension CGPoint {
    func scaled(to size: CGSize) -> CGPoint {
        CGPoint(x: x * size.width,
                y: y * size.height)
    }
}
