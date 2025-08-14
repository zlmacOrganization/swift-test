//
//  String+Extension.swift
//  SwiftTest
//
//  Created by zhangliang on 2020/9/17.
//  Copyright © 2020 zhangliang. All rights reserved.
//

import Foundation
import CommonCrypto
import var CommonCrypto.CC_MD5_DIGEST_LENGTH
import func CommonCrypto.CC_MD5
import typealias CommonCrypto.CC_LONG
import UIKit
import SwiftyRSA
import CryptoKit

extension String {
    //MARK: -
    var utf16Count: Int {
        return self.utf16.count
    }
    
    private var length: Int {
        return self.count
    }

    //"abcdefg"[3]
    subscript (i: Int) -> String {
        if i >= 0 && length > i {
            return String(self[i ..< i + 1])
        }
        return self
    }
    
    func substring(from index: Int) -> String {
        if index >= 0 && length > index {
            let startIndex = self.index(self.startIndex, offsetBy: index)
            let subString = self[startIndex..<self.endIndex]

            return String(subString)
        }
        return self
    }

    func substring(toIndex: Int) -> String {
        if toIndex <= 0 {
            return self
        }
        let subString = self[0..<toIndex]
        return String(subString)
    }
    
    subscript(range: NSRange) -> String {
        let start = index(startIndex, offsetBy: range.location)
        let end = index(start, offsetBy: range.length)
        return String(self[start..<end])
    }
    
    //"abcdefg"[3,2]
    subscript(index: Int, length: Int) -> String {
        if self.length > index + length {
            let start = self.index(startIndex, offsetBy: index)
            let end = self.index(startIndex, offsetBy: length)
            
            return String(self[start..<end])
        }
        
        return self
    }
    
    //string[1..<4]
    subscript (r: Range<Int>) -> String {
        let range = Range(uncheckedBounds: (lower: max(0, min(self.count, r.lowerBound)), upper: min(self.count, max(0, r.upperBound))))
            let start = index(startIndex, offsetBy: range.lowerBound)
            let end = index(start, offsetBy: range.upperBound - range.lowerBound)
            return String(self[start ..< end])
    }
    
    //https://stackoverflow.com/questions/32305891/index-of-a-substring-in-a-string-with-swift
    func nsRange(of searchString: String, options: NSString.CompareOptions = []) -> NSRange {
        let range = NSString(string: self).range(of: searchString, options: options)
        if range.location == NSNotFound {
            return NSRange(location: 0, length: 0)
        }else {
            return range
        }
    }
    
    //不分大小写的字符串包含判断
    func insensitiveContains(_ other: String) -> Bool {
        return localizedCaseInsensitiveContains(other)
    }
    
    //MARK: -
    func getIntNumbers() -> Int {
        if #available(iOS 13.0, *) {
            let scanner = Scanner(string: self)
//            let digitStr = scanner.scanUpToCharacters(from: .decimalDigits) ?? ""
            var number: Int = 0
            scanner.scanInt(&number)
//            print("number: \(number), digitStr: \(digitStr)")
            return number
        } else {
            var count = 0
            for char in self {
                let str = String(char)
                if Int(str) ?? -1 >= 0 {
                    count += 1
                }
            }
            return count
        }
    }
    
    //MARK: -
    func MD5() -> String? {
        //CC_MD5()已废弃
//        let str = self.cString(using: String.Encoding.utf8)
//        let strLen = CC_LONG(self.lengthOfBytes(using: String.Encoding.utf8))
//        let digestLen = Int(CC_MD5_DIGEST_LENGTH)
//        let result = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: digestLen)
//        
//        CC_MD5(str!, strLen, result)
//        
//        let hash = NSMutableString()
//        for i in 0 ..< digestLen {
//            hash.appendFormat("%02x", result[i])
//        }
//        result.deinitialize(count: digestLen)
//        return String(hash)
        
        if let data = self.data(using: .utf8) {
            let digestData = Insecure.MD5.hash(data: data)
            let digestHex = String(digestData.map({ String(format: "%02hhx", $0) }).joined().prefix(32))
            return digestHex
        }else {
            return nil
        }
    }
    
    func sha256() -> String {// iOS 13+
        let data = Data(self.utf8)
        let hashed = SHA256.hash(data: data)
        
        let hashString = hashed.compactMap {String.init(format: "%02x", $0) }.joined()
//        print("hashString: \(hashString)")
        
        return hashString
    }
    
    func HMAC_Sign(algorithm: CCHmacAlgorithm, keyString: String) -> String {
        if algorithm != kCCHmacAlgSHA1 && algorithm != kCCHmacAlgSHA256 {
            print("Unsupport algorithm.")
            return ""
        }
        
        if let keyData = keyString.data(using: .utf8) as? NSData, let strData = self.data(using: .utf8) as? NSData {
            let len = algorithm == CCHmacAlgorithm(kCCHmacAlgSHA1) ? CC_SHA1_DIGEST_LENGTH : CC_SHA256_DIGEST_LENGTH
            var cHMAC = [UInt8](repeating: 0, count: Int(len))
            CCHmac(algorithm, keyData.bytes, keyData.count, strData.bytes, strData.count, &cHMAC)
            let data = Data(bytes: &cHMAC, count: Int(len))
            let base64String = data.base64EncodedString()
            return base64String
        }
        
        return ""
    }
    
    //MARK: -
    func convertToFloat() -> CGFloat {
        if self.isEmpty {
            return 0
        }
        
        let doubleString = Double(self) ?? 0
        let floatNum = CGFloat(doubleString)
        
        return floatNum
    }
    
    func decimal() -> String {//保留两位小数，去掉小数点后多余的0
        let stringToFloat = self.convertToFloat()
        var result = ""
        
        if stringToFloat.truncatingRemainder(dividingBy: 1) == 0 {
            result = String(format: "%.0f", stringToFloat)
        }else {
            result = String(format: "%.2f", stringToFloat)
        }
        
        return result
    }
    
    //是否包含数字和字母
    var isAlphanumeric: Bool {
        return !isEmpty && range(of: "[^a-zA-Z0-9]", options: .regularExpression) == nil
    }
    
    var isNumber: Bool {
        return self.range(of: "^[0-9]*$", options: .regularExpression) != nil
//        return self.allSatisfy { character in character.isWholeNumber}
    }
    
    func isBlank() -> Bool {//判断空格字符串也为空
        let trimStr = trimmingCharacters(in: .whitespacesAndNewlines)
        return trimStr.isEmpty
    }
    
    func removeWhitespace() -> String {//去掉字符串首尾空格
        let spaceSet = CharacterSet.whitespaces
        return trimmingCharacters(in: spaceSet)
    }
    
    func removeSpecific(character: String) -> String {//删除首尾指定的字符
        let spaceSet = CharacterSet(charactersIn: character)
        return trimmingCharacters(in: spaceSet)
    }
    
    func getDigits() -> String {//获取字符串中的数字
//        let digitSet = CharacterSet.decimalDigits.inverted
//        return components(separatedBy: digitSet).joined()
        
        return filter({ $0.isNumber })
    }
    
    //数字添加千位分隔符 123,321,234
    func changeNumberFormatter(style: NumberFormatter.Style = .decimal) -> String{
        let formatter = NumberFormatter()
        formatter.numberStyle = style
        
        let value = Int(self) ?? 0
        let formatterString = formatter.string(from: NSNumber(value: value))

        return formatterString ?? ""
    }
    
    //保留2位小数
    func numDecimal(_ digits: Int = 2) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = digits
        
        let number = NSNumber(value: Float(self) ?? 0)
        let value = formatter.string(from: number) ?? ""
        
        return value
    }
    
    /// 汉字转成阿拉伯数字 "一室/二室" -> "1/2室"
    public func chineseToArabic() -> String {
        var result = self
        var numStrings: [String] = []
        let wordDict = ["零": "0", "一": "1", "二": "2", "三": "3", "四": "4", "五": "5", "六": "6", "七": "7", "八": "8", "九": "9", "十": "10"]
        
        for i in 0..<self.count {
            let charStr = self[i]
            
            for (key, value) in wordDict {
                if charStr == key {
                    //户型数字添加到数组
                    numStrings.append(value)
                }
            }
        }
        
        if numStrings.count <= 1 {
            if numStrings.isEmpty {
                return self
            }
            //只有一个数字
            result = (numStrings.first ?? "") + "室"
        }else {
            //户型数字拼接
            result = numStrings.joined(separator: "/") + "室"
        }
        
        return result
    }
    
    func isStringAllDigits() -> Bool {
        let regex = try! NSRegularExpression(pattern: "^\\d+$")
        let range = NSRange(location: 0, length: self.count)
        return regex.firstMatch(in: self, options: [], range: range) != nil
    }

    //MARK: -
    //options = .byParagraphs, .byLines
    func countTextComponents(options: String.EnumerationOptions = .byWords) -> Int {
        var components = [Substring]()
        self.enumerateSubstrings(in: self.startIndex..<self.endIndex,
                                 options: options) { _, substringRange, _, _ in
            components.append(self[substringRange])
        }
        
        return components.count
    }

    //MARK: -
    func versionCompare(_ otherVersion: String) -> ComparisonResult {
        let versionDelimiter = "."

        var versionComponents = self.components(separatedBy: versionDelimiter)
        var otherVersionComponents = otherVersion.components(separatedBy: versionDelimiter)

        let zeroDiff = versionComponents.count - otherVersionComponents.count

        if zeroDiff == 0 {
            // Same format, compare normally
            return self.compare(otherVersion, options: .numeric)
        } else {
            let zeros = Array(repeating: "0", count: abs(zeroDiff))
            if zeroDiff > 0 {
                otherVersionComponents.append(contentsOf: zeros)
            } else {
                versionComponents.append(contentsOf: zeros)
            }
            return versionComponents.joined(separator: versionDelimiter)
                .compare(otherVersionComponents.joined(separator: versionDelimiter), options: .numeric)
        }
    }
    
    //MARK: - NSRegularExpression(正则匹配)
    func regularMatching(_ pattern: String) -> Bool {
//        let pattern = "[\\u4e00-\\u9fa5]" 必须为英文字母、数字或符号
        /// 正则规则
        let regex = try? NSRegularExpression(pattern: pattern, options: [])
        /// 进行正则匹配
        if let results = regex?.matches(in: self, options: [], range: NSRange(location: 0, length: self.count)), !results.isEmpty {
            return false
        }
        return true
    }
    
    func publishMobileMatch() -> Bool {
        if self.count < 8 {
            return true
        }
        
        let pattern = "\\b\\d{8}\\b" //连续的8个数字
        let regex = try! NSRegularExpression(pattern: pattern, options: [])
        let input = "23456789rtrjt 345678990"
        let range = NSRange(location: 0, length: input.utf16.count)
        let matches = regex.matches(in: input, options: [], range: range)

        for match in matches {
            if let mRange = Range(match.range, in: input) {
                let resultString = String(input[mRange])
                print("match string: \(resultString)")
//                if !resultString.regularMatching("^[2-9]") {
//                    return false
//                }
            }
        }
        
        return true
    }
    
    func matchs(pattern: String) -> [String] {
        do {
            let expression = try NSRegularExpression(pattern: pattern, options: .caseInsensitive)
            let matchs = expression.matches(in: self, options: [], range: NSRange(location: 0, length: self.count))
            
            var datas: [String] = []
            for item in matchs {
                let string = (self as NSString).substring(with: item.range)
                datas.append(string)
            }
            
            return datas
            
        } catch {
            return []
        }
    }
    
    //字符串的替换
    func replace(pattern: String, template: String) -> String {
        //"13232323232".replace(pattern: "(?=(\\d{4})+$)", template: " ") -> "132 3232 3232"
        //"2017-06-12".replace("/(\d{4})-(\d{2})-(\d{2})/", "$2/$3/$1") -> "06/12/2017"
        
        do {
            let expression = try NSRegularExpression(pattern: pattern, options: .caseInsensitive)
            let match = expression.stringByReplacingMatches(in: self, options: .reportProgress, range: NSRange(location: 0, length: self.count), withTemplate: template)
            
            return match
            
        } catch {
            return ""
        }
    }
    
    //包含中文
    func containsChineseCharacters() -> Bool {
        let regularRange = range(of: "\\p{Han}", options: .regularExpression)
        if let regularRange = regularRange {
            let str = String(self[regularRange])
            ZFPrint("reg string: \(str)")
        }
        
        return regularRange != nil
    }
    
    //包含英文
    func containsEnglishCharacters() -> Bool {
        let pattern = "[a-zA-Z]"
        return range(of: pattern, options: .regularExpression) != nil
    }
    
    //包含日文
    func containsJapaneseCharacters() -> Bool {
        let pattern = "[\\p{Han}\\p{Hiragana}\\p{Katakana}]"
        return range(of: pattern, options: .regularExpression) != nil
    }
    
    //MARK: - URLComponents
    func getQueryItems() -> [String: String] {
        var dict: [String: String] = [:]
        let components = URLComponents(string: self)
        
        if let items = components?.queryItems {
            for queryItem in items {
                dict[queryItem.name] = queryItem.value
            }
        }
    
        return dict
    }
    
    //去掉反斜杠转义符
    func urlTransfer() -> String {
        return self.replacingOccurrences(of: "\\/", with: "/")
    }
    
    /*
     \a - Sound alert
     \b - 退格
     \f - Form feed
     \n - 换行
     \r - 回车
     \t - 水平制表符
     \v - 垂直制表符
     \\ - 反斜杠
     \" - 双引号
     \' - 单引号
     */
    func transfer() -> String {
        let mutableString = NSMutableString(string: self)
        for i in 0..<mutableString.length {
            let char = mutableString.substring(with: NSRange(location: i, length: 1))
            if char == "\\" {
                mutableString.deleteCharacters(in: NSRange(location: i, length: 1))
            }
        }
        return String(mutableString)
    }
    
    //MARK: - html
    func htmlAttributedString() -> NSAttributedString? {
        guard let data = self.data(using: .utf8) else {
            return nil
        }

        return try? NSAttributedString(
            data: data,
            options: [.documentType: NSAttributedString.DocumentType.html],
            documentAttributes: nil
        )
    }
    
    //MARK: - Calculate string width/height
    func calculateTextWidth(font: UIFont, height: CGFloat) -> CGFloat {
        if self.isEmpty {
            return 0
        }
        
        let dict = [NSAttributedString.Key.font: font]
        let size = self.boundingRect(with: CGSize(width: CGFloat(MAXFLOAT), height: height), options: [.usesLineFragmentOrigin, .usesFontLeading, .truncatesLastVisibleLine], attributes: dict, context: nil).size
        
        return size.width
    }
    
    func calculateTextHeight(font: UIFont, width: CGFloat) -> CGFloat {
        if self.isEmpty {
            return 0
        }
        
        let dict = [NSAttributedString.Key.font: font]
        let size = self.boundingRect(with: CGSize(width: width, height: CGFloat(MAXFLOAT)), options: [.usesLineFragmentOrigin, .usesFontLeading, .truncatesLastVisibleLine], attributes: dict, context: nil).size
        
        return size.height
    }
    
    func calculateTextHeight(font: UIFont, width: CGFloat, numberOfLines: Int = 0) -> CGFloat {
        let lab = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: 0))
        lab.numberOfLines = numberOfLines
        lab.font = font
        lab.text = self
        lab.sizeToFit()
        return lab.bounds.size.height
    }
    
    //计算UILabel的高度(带有行间距的情况)，width>0计算高度，height>0计算宽度
    func calculateSpaceSize(spacing: CGFloat, font: UIFont, width: CGFloat, height: CGFloat) -> CGSize {
        if self.isEmpty {
            return CGSize(width: width, height: height)
        }
        
        let paraStyle = NSMutableParagraphStyle()
        paraStyle.lineBreakMode = .byCharWrapping
        paraStyle.alignment = .left
        paraStyle.lineSpacing = spacing
        paraStyle.hyphenationFactor = 1.0
        
        paraStyle.firstLineHeadIndent = 0.0;
        paraStyle.paragraphSpacingBefore = 0.0;
        paraStyle.headIndent = 0;
        paraStyle.tailIndent = 0;
        
        var boundSize = CGSize(width: width, height: height)
        if width > 0 {
            boundSize = CGSize(width: width, height: CGFloat(MAXFLOAT))
        }else {
            boundSize = CGSize(width: CGFloat(MAXFLOAT), height: height)
        }
        
        let dict = [NSAttributedString.Key.font: font, NSAttributedString.Key.kern: "0.5", NSAttributedString.Key.paragraphStyle: paraStyle] as [NSAttributedString.Key : Any]
        let size = self.boundingRect(with: boundSize, options: NSStringDrawingOptions(rawValue: NSStringDrawingOptions.usesLineFragmentOrigin.rawValue | NSStringDrawingOptions.usesFontLeading.rawValue | NSStringDrawingOptions.truncatesLastVisibleLine.rawValue), attributes: dict, context: nil).size
        return size
    }
    
    // MARK: - RSA加密/解密
    func rsa_encrypt() -> String {
        if self.isEmpty {
            return ""
        }
        
        var result = ""
//        guard let data = self.data(using: .utf8) else { return "" }
        
        do {
            let ras_pubKey = try PublicKey(pemNamed: "public")
            let clear = try ClearMessage(string: self, using: .utf8)
            result = try clear.encrypted(with: ras_pubKey, padding: .PKCS1).base64String
        } catch {
            ZLPrint("RSA加密失败: \(error.localizedDescription)")
        }
        
        return result
    }
    
    func rsa_decrypt() -> String {
        if self.isEmpty {
            return ""
        }
        
        var result = ""
        let enData = Data(base64Encoded: self, options: .ignoreUnknownCharacters) ?? Data()
        
        do {
            let ras_privateKey = try PrivateKey(pemNamed: "private")
            let encrypted = EncryptedMessage(data: enData)
            let clear = try encrypted.decrypted(with: ras_privateKey, padding: .PKCS1)
            result = try clear.string(encoding: .utf8)
        } catch {
            ZLPrint("RSA解密失败: \(error.localizedDescription)")
        }
        
        return result
    }
}

extension String.StringInterpolation {
    /*
     printing JSON
     
     print("The provided JSON is \(json: jsonData)")
     */
    mutating func appendInterpolation(json JSONData: Data) {
        guard
            let JSONObject = try? JSONSerialization.jsonObject(with: JSONData, options: []),
            let jsonData = try? JSONSerialization.data(withJSONObject: JSONObject, options: .prettyPrinted) else {
            appendInterpolation("Invalid JSON data")
            return
        }
        appendInterpolation("\n\(String(decoding: jsonData, as: UTF8.self))")
    }
}

//MARK: - file size
extension String {
    // 对象方法
    func getFileSize() -> UInt64  {
        var size: UInt64 = 0
        let fileManager = FileManager.default
        var isDir: ObjCBool = false
        let isExists = fileManager.fileExists(atPath: self, isDirectory: &isDir)
        // 判断文件存在
        if isExists {
            // 是否为文件夹
            if isDir.boolValue {
                // 迭代器 存放文件夹下的所有文件名
                let enumerator = fileManager.enumerator(atPath: self)
                for subPath in enumerator! {
                    // 获得全路径
                    let fullPath = self.appending("/\(subPath)")
                    do {
                        let attr = try fileManager.attributesOfItem(atPath: fullPath)
                        size += attr[FileAttributeKey.size] as! UInt64
                    } catch  {
                        print("error :\(error)")
                    }
                }
            } else {    // 单文件
                do {
                    let attr = try fileManager.attributesOfItem(atPath: self)
                    size += attr[FileAttributeKey.size] as! UInt64
                    
                } catch  {
                    print("error :\(error)")
                }
            }
        }
        return size
    }
}

//MARK: - Character
extension Character {
//    var isSimpleEmoji: Bool {
//        guard let firstScalar = unicodeScalars.first else { return false }
//        if #available(iOS 10.2, *) {
//            return firstScalar.properties.isEmoji && firstScalar.value > 0x238C
//        } else {
//            return false
//        }
//    }
//
//    var isCombinedIntoEmoji: Bool {
//        if #available(iOS 10.2, *) {
//            return unicodeScalars.count > 1 && unicodeScalars.first?.properties.isEmoji ?? false
//        }
//
//        return false
//    }
//
//    var isEmoji: Bool { isSimpleEmoji || isCombinedIntoEmoji }
    
    /// 简单的emoji是一个标量，以emoji的形式呈现给用户
    var isSimpleEmoji: Bool {
        guard let firstProperties = unicodeScalars.first?.properties else {
            return false
        }
        
        if #available(iOS 10.2, *) {
            return unicodeScalars.count == 1 &&
                (firstProperties.isEmojiPresentation ||
                    firstProperties.generalCategory == .otherSymbol)
        } else {
            return false
        }
    }

    /// 检查标量是否将合并到emoji中
    var isCombinedIntoEmoji: Bool {
        return unicodeScalars.count > 1 &&
            unicodeScalars.contains { $0.properties.isJoinControl || $0.properties.isVariationSelector }
    }

    /// 是否为emoji表情
    /// - Note: http://stackoverflow.com/questions/30757193/find-out-if-character-in-string-is-emoji
    var isEmoji: Bool{
        return isSimpleEmoji || isCombinedIntoEmoji
    }
}
