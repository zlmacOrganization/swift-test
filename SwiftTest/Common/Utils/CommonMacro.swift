//
//  CommonMacro.swift
//  SwiftTest
//
//  Created by ZhangLiang on 17/1/8.
//  Copyright © 2017年 ZhangLiang. All rights reserved.
//

import Foundation
import UIKit
import var CommonCrypto.CC_MD5_DIGEST_LENGTH
import func CommonCrypto.CC_MD5
import typealias CommonCrypto.CC_LONG
import SQLite
import os

//MARK: - GCD

func gcdAbout() {
    DispatchQueue.global().async {
        //code
        DispatchQueue.main.async {
            #if swift(>=3.2)
            //
            #endif
            
            
            #if DEBUG
            //do something
            #elseif ADHOC
            //
            #elseif RELEASE
            //
            #endif
        }
    }
    
    DispatchQueue.main.asyncAfter(deadline: 1) {
        if UIDevice.current.userInterfaceIdiom == .pad {
            
        }
    }
    
    let concurrentQueue = DispatchQueue(label: "", attributes: .concurrent)
    concurrentQueue.async {
        
    }
}

// MARK: - 控制print 只在debug生效
public func ZFPrint(_ items: Any..., separator: String = " ", terminator: String = "\n"){
    #if DEBUG
        print("ZFPrint：\(items)", separator: separator, terminator: terminator)
    #endif
}

//MARK: - App Store
let AppStore_reviewLink = "https://apps.apple.com/app/idXXXXXXXXXX?action=write-review"
//AppStore跳转地址
let Const_AppStoreLink = "https://itunes.apple.com/cn/app/id1492668798"

//MARK: - System
let kiOS8 = UIDevice.current.systemVersion.convertToFloat() >= 8.0

struct Platform {
    static let isSimulator: Bool = {
//        #if arch(i386) || arch(x86_64)
        #if targetEnvironment(simulator)
            return true
        #else
            return false
        #endif
    }()
}

func colorWithRGB(r: CGFloat, g: CGFloat, b: CGFloat, alpha: CGFloat = 1.0) -> UIColor {
    return UIColor(red: r/255.0, green: g/255.0, blue: b/255.0, alpha: alpha)
}

func ZLPrint(_ items: Any..., separator: String = " ", terminator: String = "\n") {
    #if DEBUG
    print(items)
    #endif
}

//MARK: - Request
let CommonRequestUrl = "http://ningmengxinli.com/"
//http://ningmengxinli.com:8008/
//http://app.u17.com/v3/appV3_3/ios/phone/rank/list
//"https://sportsnba.qq.com/team/list"

//MARK: - Screen width / color

let kMainScreenWidth: CGFloat = UIScreen.main.bounds.size.width
let kMainScreenHeight: CGFloat = UIScreen.main.bounds.size.height

let SCALE_RATIO: CGFloat = kMainScreenWidth/375
let SCALE_RATIO_HEIGHT: CGFloat = kMainScreenHeight/667
let SCALE_RATIO_HEIGHT_LIGHT: CGFloat = ((SCALE_RATIO_HEIGHT-1)/2.0 + 1)
let SCALE_RATIO_HEIGHT_LIGHT_MORE = ((SCALE_RATIO_HEIGHT-1)/5+1)
let SCALE_RATIO_LIGHT = ((SCALE_RATIO-1)/2.0+1)
let SCALE_RATIO_LIGHT_MORE = ((SCALE_RATIO-1)/5+1)
let SCALE_RATIO_LIMIT = (SCALE_RATIO > 1.6 ? 1.6 : SCALE_RATIO)
let SCALE_RATIO_LIGHT_LIMIT = (SCALE_RATIO_LIGHT > 1.4 ? 1.4 : SCALE_RATIO_LIGHT)

let CommonBgColor = colorWithRGB(r: 237, g: 61, b: 4)
let NewBgColor = colorWithRGB(r: 118, g: 156, b: 249)
let NormalBgColor = colorWithRGB(r: 240, g: 240, b: 240)

func isIPhoneXSeries() -> Bool {
    if UIDevice.current.userInterfaceIdiom != .phone {
        return false
    }
    
    return getSafeAreaBottom() > 0
}

let IS_IPAD_DEVICE = UIDevice.current.userInterfaceIdiom == .pad

func statusBarHeight() -> CGFloat {
    return getStatusBarFrame().height
}

func getStatusBarFrame() -> CGRect {
    if #available(iOS 13.0, *) {
        let statusBarManager = UIApplication.shared.firstWindowScene?.statusBarManager
        let frame = statusBarManager?.statusBarFrame
        return frame ?? CGRect(x: 0, y: 0, width: kMainScreenWidth, height: 20)
    } else {
        return UIApplication.shared.statusBarFrame
    }
}

func getKeyWindow() -> UIWindow? {
    if #available(iOS 13.0, *) {
        return UIApplication.shared.windows.first(where: { $0.isKeyWindow })
    }else {
        return UIApplication.shared.keyWindow
    }
}

func getSafeAreaBottom() -> CGFloat {
    var bottomInset: CGFloat = 0
    
    if #available(iOS 11.0, *) {
        if #available(iOS 13.0, *) {
            let scene = UIApplication.shared.connectedScenes.first
            guard let windowScene = scene as? UIWindowScene else { return 0 }
            guard let window = windowScene.windows.first else { return 0 }
            bottomInset = window.safeAreaInsets.bottom
        }else {
            if let mainWindow = UIApplication.shared.delegate?.window {
                bottomInset = mainWindow?.safeAreaInsets.bottom ?? 0
            }
        }
    }
    
    return bottomInset
}

extension UIApplication {
    var firstWindowScene: UIWindowScene? {
        UIApplication.shared.connectedScenes
            .first(where: { $0 is UIWindowScene })
            .flatMap({ $0 as? UIWindowScene })
    }
    
    //iOS 13
    var firstKeyWindow: UIWindow? {
        return UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .filter { $0.activationState == .foregroundActive }
            .first?.windows
            .first(where: \.isKeyWindow)
    }
    
    //iOS 15
    var firstKeyWindow_iOS15: UIWindow? {
        if #available(iOS 15.0, *) {
            return UIApplication.shared.connectedScenes
                .compactMap { $0 as? UIWindowScene }
                .filter { $0.activationState == .foregroundActive }
                .first?.keyWindow
        } else {
            return firstKeyWindow
        }
    }
}

let kNaviBarHeight: CGFloat = 44
let kNavBarAndStatusBarHeight: CGFloat = kNaviBarHeight + statusBarHeight()
let kTabbarHeight: CGFloat = getSafeAreaBottom() + 49
let iphoneXBottomMargin: CGFloat = getSafeAreaBottom()

let drapTableHeight: CGFloat = 240

//MARK: - App version
let Last_Run_Version_Key = "last_run_version_of_application"
//App版本号
let infoDict = Bundle.main.infoDictionary
// 获取App的版本号
let myAppVersion = infoDict?["CFBundleShortVersionString"] as? String

// 获取App的build版本
let appBuildVersion = infoDict?["CFBundleVersion"]

//MARK: - string interception(截取字符串)
func getStringFromString(originString: String, cutLength: NSInteger) -> String{
    let index = originString.count - cutLength
    return (originString as NSString).substring(to: index)
    
//    let index = originString.endIndex
//    return originString.substring(to: index)
}

//MARK: - Date
func setTimeWith(timeString: String, timeLabel: UILabel) {
    DispatchQueue.global().async {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let dataTime = formatter.string(from: Date())
        let date = formatter.date(from: dataTime)
        let releaseData = formatter.date(from: timeString)
//        let gregorian = Calendar(identifier: Calendar.Identifier.gregorian)
        let currentCalendar = Calendar.current
        let components = currentCalendar.dateComponents([Calendar.Component.day, Calendar.Component.hour, Calendar.Component.minute, Calendar.Component.second], from: releaseData!, to: date!)
        
        DispatchQueue.main.async {
            if components.day! > 3 {
                let dateComponents = currentCalendar.dateComponents([Calendar.Component.year, Calendar.Component.month, Calendar.Component.day, Calendar.Component.hour, Calendar.Component.minute, Calendar.Component.second], from: releaseData!, to: date!)
                timeLabel.text = String(format: "%ld月%ld日", dateComponents.month!, dateComponents.day!)
            }else if components.day! > 0 {
                timeLabel.text = String(format: "%ld天前", components.day!)
            }else if components.hour! > 0 {
                timeLabel.text = String(format: "%ld小时前", components.hour!)
            }else if components.minute! > 0 {
                timeLabel.text = String(format: "%ld分钟前", components.minute!)
            }else if components.second! > 0 {
                timeLabel.text = String(format: "%ld秒前", components.second!)
            }
        }
    }
}

//MARK: -
//获取正确的删除索引
func getRemoveIndex<T: Equatable>(value: T, array: [T]) -> [Int]{
    var indexArray = [Int]()
    var correctArray = [Int]()
    
    //获取指定值在数组中的索引
    for (index,_) in array.enumerated() {
        
        if array[index] == value {
            indexArray.append(index)
        }
        
    }
    
    //计算正确的删除索引
    for (index, originIndex) in indexArray.enumerated() {
        //指定值索引减去索引数组的索引
        let correctIndex = originIndex - index
        
        //添加到正确的索引数组中
        correctArray.append(correctIndex)
    }
    
    return correctArray
    
}

//从数组中删除指定元素
func removeValueFromArray<T: Equatable>(value: T, array: inout [T]){
    let correctArray = getRemoveIndex(value: value, array: array)
    
    //从原数组中删除指定元素
    for index in correctArray{
        array.remove(at: index)
    }
}

//MARK: - Font
///苹方-简 常规体
let PingFangRegularFontName = "PingFangSC-Regular"
///苹方-简 中黑体
let PingFangMediumFontName = "PingFangSC-Medium"
///苹方-简 中粗体
let PingFangSemiboldFontName = "PingFangSC-Semibold"

func getFontWith(name: String, size: CGFloat) -> UIFont {
    if let font = UIFont(name: name, size: size) {
        return font
    }
    
    return UIFont.systemFont(ofSize: size)
}

protocol CellDataProtocol: AnyObject {
    associatedtype DataType
    func setCell(_ model: DataType)
}

extension CellDataProtocol {
    func setCell(_ model: DataType) {
        
    }
}

func swiftClassFromString(className: String) -> UIViewController? {
    // get the project name
    if  let appName: String = Bundle.main.object(forInfoDictionaryKey: "CFBundleName") as? String {
        // YourProject.className
        let classStringName = appName + "." + className
        if let classVC = NSClassFromString(classStringName) as? UIViewController.Type {
            return classVC.init()
        }
    }
    return nil
}

//MARK: - model/codable
struct OptionalObject<Base: Decodable>: Decodable {
    let value: Base?
    
    init(from decoder: Decoder) throws {
        do {
            let container = try decoder.singleValueContainer()
            self.value = try container.decode(Base.self)
        } catch  {
            self.value = nil
        }
        
        //array解析，有元素字段为空处理
//        do {
//            let optionalValues = try JSONDecoder().decode([OptionalObject<MyFansModel>].self, from: Data())
//            let models = optionalValues.compactMap{$0.value}
//        } catch  {
//            
//        }
    }
}
extension KeyedDecodingContainer {
//    fileprivate func decodeIfPresent(_ type: Int.Type, forKey key: CodingKey) -> Int? {
//        return nil
//    }
}

enum AnyNumValue: Codable {
    case int(Int)
    case string(String)
    case float(Float)
    case notMatch
    
//    private enum CodingKeys: CodingKey {
//        case int
//        case string
//    }
    
    init(from decoder: Decoder) throws {
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//        let type = try container.decode(AnyValue.self, forKey: .int)
        
        if let int = try? decoder.singleValueContainer().decode(Int.self) {
            self = .int(int)
            return
        }
        
        if let string = try? decoder.singleValueContainer().decode(String.self) {
            self = .string(string)
            return
        }
        
        if let float = try? decoder.singleValueContainer().decode(Float.self) {
            self = .float(float)
            return
        }
        
        self = .notMatch
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        
        switch self {
        case .int(let value):
            try container.encode(value)
        case .string(let value):
            try container.encode(value)
        case .float(let value):
            try container.encode(value)
        default:
            try container.encodeNil()
        }
    }
}

extension AnyNumValue {
    var intValue: Int? {
        switch self {
        case .int(let value):
            return value
        case .string(let value):
            return Int(value)
        case .float(let value):
            return Int(value)
        default:
            return nil
        }
    }
    
    var stringValue: String? {
        switch self {
        case .int(let value):
            return String(value)
        case .string(let value):
            return value
        case .float(let value):
            return String(value)
        default:
            return nil
        }
    }
}

// ------ ------ ------ ------
extension String: DefaultValue {
    public static let defaultValue = ""
}

extension Int: DefaultValue {
    public static let defaultValue = 0
}

extension KeyedDecodingContainer {
    func decode<T>(_ type: DefaultCodable<T>.Type, forKey key: Key) throws -> DefaultCodable<T> where T: DefaultValue {
        try decodeIfPresent(type, forKey: key) ?? DefaultCodable(wrappedValue: T.defaultValue)
    }
}

struct MyModel: Codable {
    var userPhoneNum: String
    var userHeadImg: String
    var userNickName: String?
    @DefaultCodable<String> var slogan: String
}

public protocol DefaultValue {
    associatedtype Value: Codable
    static var defaultValue: Value {get}
}

public enum DefaultBy {
    public enum True: DefaultValue {
        public static let defaultValue = true
    }
    
    public enum False: DefaultValue {
        public static let defaultValue = false
    }
}

@propertyWrapper
public struct DefaultCodable<T: DefaultValue> {
    public var wrappedValue: T.Value
    
    public init(wrappedValue: T.Value) {
        self.wrappedValue = wrappedValue
    }
}

extension DefaultCodable: Equatable where T.Value: Equatable {
    public static func == (l: DefaultCodable, r: DefaultCodable) -> Bool {
        l.wrappedValue == r.wrappedValue
    }
}

extension DefaultCodable: Codable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        do {
            wrappedValue = try container.decode(T.Value.self)
        } catch {
            wrappedValue = T.defaultValue
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        try wrappedValue.encode(to: encoder)
    }
}

// ------ ------ ------ ------

//MARK: - other ----------
func nestedLoopBreak() {
    iLoop: for i in 1...3 {
        print("i \(i)")
        jLoop: for j in 1...3 {
            print("== j \(j)")
            
            if j == 2 {
                break iLoop
            }
        }
    }
}

class Delegate<Input, Output> {
    private var block: ((Input) -> Output?)?
    
    func delegate<T: AnyObject>(on target: T, block: ((T, Input) -> Output)?) {
        self.block = {[weak target] input in
            guard let target = target else { return nil }
            return block?(target, input)
        }
    }
    
    func call(_ input: Input) -> Output? {
        return block?(input)
    }
    
    //Swift 5.2
    func callAsFunction(_ input: Input) -> Output? {
        return block?(input)
    }
}

//MARK: - lock
public final class UnfairLock {
    public init() {
        self.pointer = .allocate(capacity: 1)
        self.pointer.initialize(to: os_unfair_lock())
    }

    deinit {
        self.pointer.deinitialize(count: 1)
        self.pointer.deallocate()
    }

    public func lock() {
        os_unfair_lock_lock(self.pointer)
    }

    public func unlock() {
        os_unfair_lock_unlock(self.pointer)
    }

    private let pointer: os_unfair_lock_t
}

@propertyWrapper
public final class ThreadSafe<T> {
    public init(wrappedValue: T) {
        self.value = wrappedValue
    }

    private let lock = UnfairLock()
    private var value: T
    public var projectedValue: ThreadSafe<T> { self }

    public var wrappedValue: T {
        get {
            self.lock.lock(); defer { self.lock.unlock() }
            return self.value
        }
        set {
            self.lock.lock(); defer { self.lock.unlock() }
            self.value = newValue
        }
        
        //替换set
//        _modify {
//            self.lock.lock(); defer { self.lock.unlock() }
//            yield &self.value
//        }
    }
}

