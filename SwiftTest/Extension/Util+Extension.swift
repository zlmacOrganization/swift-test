//
//  Extension+Util.swift
//  SwiftTest
//
//  Created by zhangliang on 2020/9/17.
//  Copyright © 2020 zhangliang. All rights reserved.
//

import Foundation
import UIKit

extension UITableView {
    func zl_registerCell<T: UITableViewCell>(_ cellClass: T.Type, identifier: String = "\(T.self)") {
        register(cellClass, forCellReuseIdentifier: identifier)
    }
    
    func zl_registerNib<T: UITableViewCell>(_ cellClass: T.Type, identifier: String = "\(T.self)") {
        register(UINib(nibName: "\(T.self)", bundle: .main), forCellReuseIdentifier: identifier)
    }
    
    func zl_dequeueReusableCell<T: UITableViewCell>(_ cellClass: T.Type, identifier: String = "\(T.self)", indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withIdentifier: identifier, for: indexPath) as? T else {
            fatalError("\(identifier) is not registed")
        }
        return cell
    }
    
    func zl_registerHeaderFooterView<T: UITableViewHeaderFooterView>(_ viewClass: T.Type, identifier: String = "\(T.self)") {
        register(viewClass, forHeaderFooterViewReuseIdentifier: identifier)
    }
    
    func zl_dequeueHeaderFooterView<T: UITableViewHeaderFooterView>(_ viewClass: T.Type, identifier: String = "\(T.self)") -> T {
        guard let view = dequeueReusableHeaderFooterView(withIdentifier: identifier) as? T else {
            fatalError("view is not registed")
        }
        return view
    }
    
    func isExist(indexPath: IndexPath) -> Bool {
        if indexPath.section >= self.numberOfSections {
            return false
        }
        
        if indexPath.row >= self.numberOfRows(inSection: indexPath.section) {
            return false
        }
        
        return true
    }
}

extension UICollectionView {
    func zl_registerCell<T: UICollectionViewCell>(_ cellClass: T.Type, identifier: String = "\(T.self)") {
        register(cellClass, forCellWithReuseIdentifier: identifier)
    }
    
    func zl_dequeueReusableCell<T: UICollectionViewCell>(_ cellClass: T.Type, identifier: String = "\(T.self)", indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as? T else {
            fatalError("\(identifier) is not registed")
        }
        return cell
    }
    
    func zl_registerSupplementaryView<T: UICollectionReusableView>(kind: String, _ viewClass: T.Type, identifier: String = "\(T.self)") {
        register(viewClass, forSupplementaryViewOfKind: kind, withReuseIdentifier: identifier)
    }
    
    func zl_dequeueSupplementaryView<T: UICollectionReusableView>(kind: String, _ viewClass: T.Type, identifier: String = "\(T.self)", indexPath: IndexPath) -> T {
        guard let view = dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: identifier, for: indexPath) as? T else {
            fatalError("view is not registed")
        }
        return view
    }
}

extension UIViewController {
    func zl_pushViewController(_ controller: UIViewController, animated: Bool = true) {
        if navigationController?.viewControllers.count ?? 0 > 0 {
            controller.hidesBottomBarWhenPushed = true
        }
        navigationController?.pushViewController(controller, animated: animated)
    }
    
    func zl_present(_ controller: UIViewController, animated: Bool = true, style: UIModalPresentationStyle = .fullScreen, completion: (() -> Void)? = nil) {
        controller.modalPresentationStyle = style
        present(controller, animated: animated, completion: completion)
    }
    
    @objc func back() {
        if (presentingViewController != nil) {
            dismiss(animated: true, completion: nil)
        }else {
            navigationController?.popViewController(animated: true)
        }
    }
    
    class func topViewController(rootViewController: UIViewController?) -> UIViewController? {
        guard let rootViewController = rootViewController else {
            return nil
        }

        guard let presented = rootViewController.presentedViewController else {
            return rootViewController
        }

        switch presented {
        case let navigationController as UINavigationController:
            return topViewController(rootViewController: navigationController.viewControllers.last)

        case let tabBarController as UITabBarController:
            return topViewController(rootViewController: tabBarController.selectedViewController)

        default:
            return topViewController(rootViewController: presented)
        }
    }
    
    //MARK: - HUD
    func showNoticeOnlyText(_ text: String) {
        DispatchQueue.main.async {
            self.noticeOnlyText(text)
        }
    }
}

//MARK: - URL
extension URL {
    init?(zlString: String?) {
        guard let urlStr = zlString else { return nil }
        self.init(string: urlStr)
    }
    
    init(staticString: StaticString) {
        guard let url = URL(string: "\(staticString)") else {
            preconditionFailure("Invalid static URL string: \(staticString)")
        }
        self = url
    }
}

//MARK: - color
extension UIColor {
    class func colorWith(hex:String, alpha: CGFloat = 1.0) -> UIColor {
        
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        var rgbValue:UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    class func colorWith(r: CGFloat, g: CGFloat, b: CGFloat, alpha: CGFloat = 1.0) -> UIColor {
        return UIColor(red: r/255.0, green: g/255.0, blue: b/255.0, alpha: alpha)
    }
    
    //生成纯色图片
    func getPureImage() -> UIImage? {
        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContext(rect.size)
        
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(self.cgColor)
        context?.fill(rect)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image
    }
    
    //MARK: - dark mode
    static func dynamicColor(light: UIColor, dark: UIColor) -> UIColor {
        if #available(iOS 13.0, *) {
            let color = UIColor { (traitCollection) -> UIColor in
                if traitCollection.userInterfaceStyle == .dark {
                    return dark
                }else {
                    return light
                }
            }
            return color
        }else {
            return light
        }
    }
    
    @available(iOS 13.0, *)
    var light: UIColor {
            return self.resolvedColor(with: UITraitCollection(userInterfaceStyle: .light))
        }

    @available(iOS 13.0, *)
    var dark: UIColor {
        return self.resolvedColor(with: UITraitCollection(userInterfaceStyle: .dark))
    }
    
    class func randomColor() -> UIColor {
        let r = CGFloat.random(in: 0..<255)
        let g = CGFloat.random(in: 0..<255)
        let b = CGFloat.random(in: 0..<255)
        
        return colorWithRGB(r: r, g: g, b: b)
    }
}

extension UIFont {
    class func getFontWith(name: String, size: CGFloat) -> UIFont {
        if let font = UIFont(name: name, size: size) {
            return font
        }
        
        return UIFont.systemFont(ofSize: size)
    }
}

//MARK: - Collection / Sequence
//逐个相加
extension Array {
    func accumulate<Result>(_ initialResult: Result, _ nextPartialResult:(Result, Element) -> Result) -> [Result] {
        var running = initialResult
        return map({next in
            running = nextPartialResult(running, next)
            return running
        })
    }
}

//extension Array {
//    func reduce<Result>(_ initialResult: Result, _ nextPartiaResult:(Result, Element) -> Result) -> Result {
//        var result = initialResult
//        for index in self {
//            result = nextPartiaResult(result, index)
//        }
//        return result
//    }
//}

//防止数组越界
extension Array {
    // items[safe: 3]
    subscript(safe index: Int) -> Element? {
        if index < 0 {
            return nil
        }
        return indices ~= index ? self[index] : nil
    }
}

//数组去重，并保留原来的顺序
extension Array where Element: Hashable {
    func unique() -> [Element] {
        var uniq = Set<Element>()
        uniq.reserveCapacity(self.count)
        
        return self.filter {
            return uniq.insert($0).inserted
        }
    }
    
    func uniqueKeyValues() -> Dictionary<Element, Int> {
        let numsFreq = Dictionary(self.map {($0, 1)}, uniquingKeysWith: +)
    //    var numsFre = Dictionary(uniqueKeysWithValues: zip(1..., nums1))
        return numsFreq
    }
}

//检查一个序列中的所有元素是否全部都满足某个条件
//extension Sequence {
//    func allContains(matching predicate:(Iterator.Element) -> Bool) -> Bool {
//        return !contains(where: {
//            !predicate($0)
//        })
//    }
//
//    func all(condition: (Iterator .Element) -> Bool) -> Bool {
//        for element in self {
//            guard condition(element) else {
//                return false
//            }
//        }
//        return true
//    }
//}

extension Sequence where Element: Equatable {
    func removingConsecutiveDuplicates() -> [Element] {
        return reduce(into: []) { (result: inout [Element], element) in
            if result.last != element {
                result.append(element)
            }
        }
    }
}

extension Collection {
    //let sortedTodoItems = [].zl_sorted(by: \.date)
    //https://www.swiftbysundell.com/articles/sorting-swift-collections/#sorting-on-multiple-properties
    func zl_sorted<T: Comparable>(
            by keyPath: KeyPath<Element, T>,
            using comparator: (T, T) -> Bool = (<)) -> [Element] {
        sorted { a, b in
            comparator(a[keyPath: keyPath], b[keyPath: keyPath])
        }
    }
    
    subscript<Indices: Sequence>(indices indices: Indices) -> [Element] where Indices.Element == Index {
        var result: [Element] = []
        for index in indices {
            result.append(self[index])
        }
        return result
    }
} // ↓↓↓↓

//let words = "Lorem ipsum dolor sit amet".split(separator: " ")
//words[indices: [1,2]] -> ["ipsum", "dolor"]

//将一个字典合并进另一个字典了
//extension Dictionary {
//    mutating func merge<S>(_ other: S) where S: Sequence, S.Iterator.Element == (key: Key, value: Value){
//        for (k, v) in other {
//            self[k] = v
//        }
//    }
//}
extension Dictionary where Key == String, Value: Any {
    subscript<T>(key: String) -> T? {
        return self[key] as? T
    }
    
    func writeToFile(fileName: String) {
        if let document = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let fileUrl = document.appendingPathComponent(fileName)
            print("fileUrl: \(fileUrl)")
            
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: self)
                try jsonData.write(to: fileUrl, options: .atomic)
            } catch {
                print("write to file failed")
            }
        }
    }
}

//MARK: -
extension DispatchTime : @retroactive ExpressibleByIntegerLiteral, @retroactive ExpressibleByFloatLiteral {

    public init(integerLiteral val: Int) {
        self = .now() + .seconds(val)
    }

    public init(floatLiteral val: Double) {
        self = .now() + .milliseconds(Int(val * 1000))
    }
}

extension Int {
    //数字转换为十六进制数
    func toHex() -> String {
        if self == 0 {
            return "0"
        }
        
        var num = self, resSize = 0, resStr = ""
        let hexChar = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "a", "b", "c", "d", "e", "f"]
        
        while num != 0 && resSize < 8 {
            resStr = hexChar[num&0xf] + resStr
            num >>= 4
            resSize += 1
        }
        
        return resStr
    }
}

//MARK: - Date
extension Date {
    //https://swiftrocks.com/useful-global-swift-functions
    func advanced(by n: Int, component: Calendar.Component = .day) -> Date? {
        return Calendar.current.date(byAdding: component,
                                     value: n,
                                     to: self)
    }

    func distance(to other: Date) -> Int? {
        return Calendar.current.dateComponents([.day],
                                               from: other,
                                               to: self).day
    }
    
    func removeComponents(_ components: Set<Calendar.Component> = [.year, .month, .day, .hour],
                          in calendar: Calendar = .current) -> Date {
        let dateComponents = calendar.dateComponents(components, from: self)
        return calendar.date(from: dateComponents) ?? self
    }
}

//MARK: - NSDecimalNumber
extension NSDecimalNumber {
    // 转String 四舍五入 https://juejin.cn/post/6999184850632736775
    
    /*
     //   scale: 保留几位小数
     //   roundingMode:
     //   plain: 保留位数的下一位四舍五入
     //   down: 保留位数的下一位直接舍去
     //   up: 保留位数的下一位直接进一位
     
     //当保留位数的下一位不是5时，四舍五入，当保留位数的下一位是5时，其前一位是偶数直接舍去，是奇数直接进位（如果5后面还有数字则直接进位）
     */
    
    func toString(_ scale: Int = 2, roundingMode: RoundingMode = .plain) -> String {
        let behavior = NSDecimalNumberHandler(roundingMode: roundingMode, scale: Int16(scale), raiseOnExactness: false, raiseOnOverflow: false, raiseOnUnderflow: false, raiseOnDivideByZero: true)
        let product = multiplying(by: .one, withBehavior: behavior)
        return product.stringValue
    }
}

extension Optional where Wrapped == String {
    var defaultString: String {
        return self ?? ""
    }
}

extension UIDevice {
 
    var phoneModel: String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8 , value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        
        func mapToDevice(identifier: String) -> String { // swiftlint:disable:this cyclomatic_complexity
            switch identifier {
                case "iPod5,1":                                       return "iPod touch (5th generation)"
                case "iPod7,1":                                       return "iPod touch (6th generation)"
                case "iPod9,1":                                       return "iPod touch (7th generation)"
                case "iPhone3,1", "iPhone3,2", "iPhone3,3":           return "iPhone 4"
                case "iPhone4,1":                                     return "iPhone 4s"
                case "iPhone5,1", "iPhone5,2":                        return "iPhone 5"
                case "iPhone5,3", "iPhone5,4":                        return "iPhone 5c"
                case "iPhone6,1", "iPhone6,2":                        return "iPhone 5s"
                case "iPhone7,2":                                     return "iPhone 6"
                case "iPhone7,1":                                     return "iPhone 6 Plus"
                case "iPhone8,1":                                     return "iPhone 6s"
                case "iPhone8,2":                                     return "iPhone 6s Plus"
                case "iPhone9,1", "iPhone9,3":                        return "iPhone 7"
                case "iPhone9,2", "iPhone9,4":                        return "iPhone 7 Plus"
                case "iPhone10,1", "iPhone10,4":                      return "iPhone 8"
                case "iPhone10,2", "iPhone10,5":                      return "iPhone 8 Plus"
                case "iPhone10,3", "iPhone10,6":                      return "iPhone X"
                case "iPhone11,2":                                    return "iPhone XS"
                case "iPhone11,4", "iPhone11,6":                      return "iPhone XS Max"
                case "iPhone11,8":                                    return "iPhone XR"
                case "iPhone12,1":                                    return "iPhone 11"
                case "iPhone12,3":                                    return "iPhone 11 Pro"
                case "iPhone12,5":                                    return "iPhone 11 Pro Max"
                case "iPhone13,1":                                    return "iPhone 12 mini"
                case "iPhone13,2":                                    return "iPhone 12"
                case "iPhone13,3":                                    return "iPhone 12 Pro"
                case "iPhone13,4":                                    return "iPhone 12 Pro Max"
                case "iPhone14,4":                                    return "iPhone 13 mini"
                case "iPhone14,5":                                    return "iPhone 13"
                case "iPhone14,2":                                    return "iPhone 13 Pro"
                case "iPhone14,3":                                    return "iPhone 13 Pro Max"
                case "iPhone14,7":                                    return "iPhone 14"
                case "iPhone14,8":                                    return "iPhone 14 Plus"
                case "iPhone15,2":                                    return "iPhone 14 Pro"
                case "iPhone15,3":                                    return "iPhone 14 Pro Max"
                case "iPhone15,4":                                    return "iPhone 15"
                case "iPhone15,5":                                    return "iPhone 15 Plus"
                case "iPhone16,1":                                    return "iPhone 15 Pro"
                case "iPhone16,2":                                    return "iPhone 15 Pro Max"
                case "iPhone17,3":                                    return "iPhone 16"
                case "iPhone17,4":                                    return "iPhone 16 Plus"
                case "iPhone17,1":                                    return "iPhone 16 Pro"
                case "iPhone17,2":                                    return "iPhone 16 Pro Max"
                case "iPhone17,5":                                    return "iPhone 16e"
                case "iPhone8,4":                                     return "iPhone SE"
                case "iPhone12,8":                                    return "iPhone SE (2nd generation)"
                case "iPhone14,6":                                    return "iPhone SE (3rd generation)"
                case "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4":      return "iPad 2"
                case "iPad3,1", "iPad3,2", "iPad3,3":                 return "iPad (3rd generation)"
                case "iPad3,4", "iPad3,5", "iPad3,6":                 return "iPad (4th generation)"
                case "iPad6,11", "iPad6,12":                          return "iPad (5th generation)"
                case "iPad7,5", "iPad7,6":                            return "iPad (6th generation)"
                case "iPad7,11", "iPad7,12":                          return "iPad (7th generation)"
                case "iPad11,6", "iPad11,7":                          return "iPad (8th generation)"
                case "iPad12,1", "iPad12,2":                          return "iPad (9th generation)"
                case "iPad13,18", "iPad13,19":                        return "iPad (10th generation)"
                case "iPad15,7", "iPad15,8":                          return "iPad (11th generation)"
                case "iPad4,1", "iPad4,2", "iPad4,3":                 return "iPad Air"
                case "iPad5,3", "iPad5,4":                            return "iPad Air 2"
                case "iPad11,3", "iPad11,4":                          return "iPad Air (3rd generation)"
                case "iPad13,1", "iPad13,2":                          return "iPad Air (4th generation)"
                case "iPad13,16", "iPad13,17":                        return "iPad Air (5th generation)"
                case "iPad14,8", "iPad14,9":                          return "iPad Air (11-inch) (M2)"
                case "iPad14,10", "iPad14,11":                        return "iPad Air (13-inch) (M2)"
                case "iPad15,3", "iPad15,4":                          return "iPad Air (11-inch) (M3)"
                case "iPad15,5", "iPad15,6":                          return "iPad Air (13-inch) (M3)"
                case "iPad2,5", "iPad2,6", "iPad2,7":                 return "iPad mini"
                case "iPad4,4", "iPad4,5", "iPad4,6":                 return "iPad mini 2"
                case "iPad4,7", "iPad4,8", "iPad4,9":                 return "iPad mini 3"
                case "iPad5,1", "iPad5,2":                            return "iPad mini 4"
                case "iPad11,1", "iPad11,2":                          return "iPad mini (5th generation)"
                case "iPad14,1", "iPad14,2":                          return "iPad mini (6th generation)"
                case "iPad16,1", "iPad16,2":                          return "iPad mini (A17 Pro)"
                case "iPad6,3", "iPad6,4":                            return "iPad Pro (9.7-inch)"
                case "iPad7,3", "iPad7,4":                            return "iPad Pro (10.5-inch)"
                case "iPad8,1", "iPad8,2", "iPad8,3", "iPad8,4":      return "iPad Pro (11-inch) (1st generation)"
                case "iPad8,9", "iPad8,10":                           return "iPad Pro (11-inch) (2nd generation)"
                case "iPad13,4", "iPad13,5", "iPad13,6", "iPad13,7":  return "iPad Pro (11-inch) (3rd generation)"
                case "iPad14,3", "iPad14,4":                          return "iPad Pro (11-inch) (4th generation)"
                case "iPad16,3", "iPad16,4":                          return "iPad Pro (11-inch) (M4)"
                case "iPad6,7", "iPad6,8":                            return "iPad Pro (12.9-inch) (1st generation)"
                case "iPad7,1", "iPad7,2":                            return "iPad Pro (12.9-inch) (2nd generation)"
                case "iPad8,5", "iPad8,6", "iPad8,7", "iPad8,8":      return "iPad Pro (12.9-inch) (3rd generation)"
                case "iPad8,11", "iPad8,12":                          return "iPad Pro (12.9-inch) (4th generation)"
                case "iPad13,8", "iPad13,9", "iPad13,10", "iPad13,11":return "iPad Pro (12.9-inch) (5th generation)"
                case "iPad14,5", "iPad14,6":                          return "iPad Pro (12.9-inch) (6th generation)"
                case "iPad16,5", "iPad16,6":                          return "iPad Pro (13-inch) (M4)"
                case "AppleTV5,3":                                    return "Apple TV"
                case "AppleTV6,2":                                    return "Apple TV 4K"
                case "AudioAccessory1,1":                             return "HomePod"
                case "AudioAccessory5,1":                             return "HomePod mini"
                case "i386", "x86_64", "arm64":                       return "Simulator \(mapToDevice(identifier: ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"] ?? "iOS"))"
                default:                                              return identifier
                }
            }

            return mapToDevice(identifier: identifier)
    }
}
