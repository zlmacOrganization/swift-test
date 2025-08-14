//
//  CommonFunction.swift
//  Exercise
//
//  Created by ZhangLiang on 2017/10/14.
//  Copyright © 2017年 ZhangLiang. All rights reserved.
//

import Foundation
import UserNotifications
import CoreLocation
import Contacts
import Photos
import UIKit
import os.signpost

final class CommonFunction: NSObject {
    
    class func isFirstLoadOrUpdate() -> Bool {//第一次启动或者版本更新
        let currentVersion = myAppVersion
        let defaults = UserDefaults.standard
        let lastRunVersion = defaults.object(forKey: Last_Run_Version_Key)
        
        if lastRunVersion == nil {
            defaults.set(currentVersion, forKey: Last_Run_Version_Key)
            return true
        }
        
        if lastRunVersion as? String != currentVersion {
            defaults.set(currentVersion, forKey: Last_Run_Version_Key)
            return true
        }
        
        return false
    }

    //MARK: - init
    class func createLabel(frame: CGRect, text: String, font: UIFont, textColor: UIColor, textAlignment: NSTextAlignment) -> UILabel {
        let label = UILabel(frame: frame)
        label.font = font
        label.text = text
        label.textColor = textColor
        label.textAlignment = textAlignment
        
        return label
    }
    
    class func createLabel(font: UIFont, text: String, textColor: UIColor, textAlignment: NSTextAlignment) -> UILabel {
        let label = UILabel()
        label.font = font
        label.text = text
        label.textColor = textColor
        label.textAlignment = textAlignment
        
        return label
    }
    
    class func createButton(frame:CGRect, title: String?, textColor: UIColor?, font: UIFont?, imageName: String? = nil, isBackgroundImage: Bool = false, target: Any, action: Selector?) -> UIButton {
        let button = UIButton(frame: frame)
        button.setTitle(title, for: .normal)
        button.setTitleColor(textColor, for: .normal)
        button.titleLabel?.font = font
        
        if isBackgroundImage {
            button.setBackgroundImage(UIImage(named: imageName ?? ""), for: .normal)
        }else{
            button.setImage(UIImage(named: imageName ?? ""), for: .normal)
        }
        
        if let selector = action {
            button.addTarget(target, action: selector, for: UIControl.Event.touchUpInside)
        }
        
        return button
    }
    
    class func createButton(frame:CGRect, title: String?, textColor: UIColor?, font: UIFont?, isBackgroundImage: Bool = false, imageName: String? = nil, isMultiLine: Bool = false, textAlignment: NSTextAlignment = .center, target: Any, action: Selector?) -> UIButton {
        let button = UIButton(frame: frame)
        button.setTitle(title, for: .normal)
        button.setTitleColor(textColor, for: .normal)
        button.titleLabel?.font = font
        
        if isMultiLine {
            button.titleLabel?.textAlignment = textAlignment
            button.titleLabel?.lineBreakMode = .byWordWrapping
        }
        
        if isBackgroundImage {
            button.setBackgroundImage(UIImage(named: imageName ?? ""), for: .normal)
        }else{
            button.setImage(UIImage(named: imageName ?? ""), for: .normal)
        }
        
        if let selector = action {
            button.addTarget(target, action: selector, for: UIControl.Event.touchUpInside)
        }
        
        return button
    }
    
    class func createBarButtonItem(title: String, tintColor: UIColor = UIColor.darkGray, target: Any, action: Selector) -> UIBarButtonItem {
        let buttonItem = UIBarButtonItem(title: title, style: .plain, target: target, action: action)
        buttonItem.tintColor = tintColor
        return buttonItem
    }
    
    class func createBarButtonItem(imageName: String, tintColor: UIColor = UIColor.darkGray, target: Any, action: Selector) -> UIBarButtonItem {
        let buttonItem = UIBarButtonItem(image: UIImage(named: imageName), style: .plain, target: target, action: action)
        buttonItem.tintColor = tintColor
        return buttonItem
    }
    
    class func createTextField(frame: CGRect, fontNum: CGFloat, textColor:UIColor, placeholder: String) -> DefinedTextField{
        let textField = DefinedTextField(frame: frame)
        textField.textColor = textColor
        textField.placeholder = placeholder
        textField.font = UIFont.systemFont(ofSize: fontNum)
        textField.setPadding(enable: true, top: 0, left: 3, bottom: 0, right: 3)
        return textField
    }
    
    class func setupInfoViews_leftAlignment(infoView: UIView, infos: [String], viewWidth: CGFloat, labelHeight: CGFloat, font: UIFont, textColor: UIColor = .darkGray, alignment: NSTextAlignment = .center) {
        var labelX: CGFloat = 0
        var labelY: CGFloat = 0
        
        for info in infos {
            var wordWidth = info.calculateTextWidth(font: font, height: labelHeight)
            if wordWidth > viewWidth {
                wordWidth = viewWidth
            }
            
            if labelX + wordWidth > viewWidth {
                labelY += labelHeight + 10
                labelX = 0
            }
            
            let label = CommonFunction.createLabel(frame: CGRect(x: labelX, y: labelY, width: wordWidth, height: labelHeight), text: info, font: font, textColor: textColor, textAlignment: alignment)
            infoView.addSubview(label)
            
            labelX += wordWidth + 8
        }
    }
    
    class func setupInfoViews_rightAlignment(infoView: UIView, infos: [String], viewWidth: CGFloat, labelHeight: CGFloat, font: UIFont, textColor: UIColor = .darkGray, alignment: NSTextAlignment = .center) {
        var labelX = viewWidth
        var labelY: CGFloat = 0
        
        for (i, info) in infos.enumerated() {
            var wordWidth = info.calculateTextWidth(font: font, height: labelHeight)
            if wordWidth > viewWidth {
                wordWidth = viewWidth
            }
            
            if i == 0 {
                labelX = viewWidth - wordWidth
            }else {
                let margin = wordWidth + 8
                labelX -= margin
            }
            
            if labelX < 0 {
                labelY += labelHeight + 10
                labelX = viewWidth - wordWidth
            }
            
            let label = CommonFunction.createLabel(frame: CGRect(x: labelX, y: labelY, width: wordWidth, height: labelHeight), text: info, font: font, textColor: textColor, textAlignment: alignment)
            infoView.addSubview(label)
        }
    }
    
    //MARK: - AlertController
    @discardableResult
    class func zl_showAlertController(title: String? = nil, message: String? = nil, sureTitle: String = "确定", sureColor: UIColor? = nil, cancelTitle: String? = "取消", cancelColor: UIColor? = nil, controller: UIViewController, preferredStyle: UIAlertController.Style = .alert, cancelAction: (() -> Void)? = nil, sureAction: (() -> Void)? = nil) -> UIAlertController {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: preferredStyle)
        
        let sure = UIAlertAction(title: sureTitle, style: .default) { (action) in
            sureAction?()
        }
        
        if let sureColor = sureColor {
            sure.setTitle(color: sureColor)
        }
        
        alertController.addAction(sure)
        
        if let cancelTitle = cancelTitle {
            let cancel = UIAlertAction(title: cancelTitle, style: .cancel) { (action) in
                cancelAction?()
            }
            
            if let cancelColor = cancelColor {
                cancel.setTitle(color: cancelColor)
            }
            
            alertController.addAction(cancel)
        }
        
        controller.present(alertController, animated: true, completion: nil)
        return alertController
    }
    
    class func showAlertController(title: String? = nil, message: String? = nil, controller: UIViewController, cancelAction: (() -> Void)? = nil, sureAction: (() -> Void)? = nil, preferredStyle: UIAlertController.Style = .alert, isShowCancel: Bool = true) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: preferredStyle)
        
        let sure = UIAlertAction(title: "确定", style: .default) { (action) in
            if let action = sureAction {
                action()
            }
        }
        
        if isShowCancel {
            let cancel = UIAlertAction(title: "取消", style: .cancel) { (action) in
                if let action = cancelAction {
                    action()
                }
            }
            alertController.addAction(cancel)
        }
        
        alertController.addAction(sure)
        
        controller.present(alertController, animated: true, completion: nil)
    }
    
    //MARK: - tap gesture
    class func addTapGesture(with view: UIView, target: Any, action: Selector) {
        let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: target, action: action)
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(tapGesture)
    }
    
    class func addPanGesture(with view: UIView, target: Any, action: Selector) {
        let tapGesture: UIPanGestureRecognizer = UIPanGestureRecognizer(target: target, action: action)
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(tapGesture)
    }
    
    //MARK: - Calculate Label width/height
    //计算UILabel的宽度和高度
    
    class func getTextWidth(string: String, font: UIFont, height: CGFloat) -> CGFloat {
        if string.isEmpty {
            return 0
        }
        
        let dict = [NSAttributedString.Key.font: font]
        let size = string.boundingRect(with: CGSize(width: CGFloat(MAXFLOAT), height: height), options: [.usesLineFragmentOrigin, .usesFontLeading, .truncatesLastVisibleLine], attributes: dict, context: nil).size
        
        return size.width
    }
    
    class func getTextHeight(string: String, font: UIFont, width: CGFloat) -> CGFloat {
        if string.isEmpty {
            return 0
        }
        
        let dict = [NSAttributedString.Key.font: font]
        let size = string.boundingRect(with: CGSize(width: width, height: CGFloat(MAXFLOAT)), options: [.usesLineFragmentOrigin, .usesFontLeading, .truncatesLastVisibleLine], attributes: dict, context: nil).size
        
        return size.height
    }
    
    //计算UILabel的高度(带有行间距的情况)
    class func getSpaceHeightSize(with string: String, lineSpacing: CGFloat, font: UIFont, width: CGFloat) -> CGSize {
        if string.isEmpty {
            return CGSize(width: width, height: 0)
        }
        
        let paraStyle = NSMutableParagraphStyle()
        paraStyle.lineBreakMode = .byCharWrapping
        paraStyle.alignment = .left
        paraStyle.lineSpacing = lineSpacing
        paraStyle.hyphenationFactor = 1.0
        
        paraStyle.firstLineHeadIndent = 0.0;
        paraStyle.paragraphSpacingBefore = 0.0;
        paraStyle.headIndent = 0;
        paraStyle.tailIndent = 0;
        
        let dict = [NSAttributedString.Key.font: font, NSAttributedString.Key.kern: "0.5", NSAttributedString.Key.paragraphStyle: paraStyle] as [NSAttributedString.Key : Any]
        let size = string.boundingRect(with: CGSize(width: width, height: CGFloat(MAXFLOAT)), options: NSStringDrawingOptions(rawValue: NSStringDrawingOptions.usesLineFragmentOrigin.rawValue | NSStringDrawingOptions.usesFontLeading.rawValue | NSStringDrawingOptions.truncatesLastVisibleLine.rawValue), attributes: dict, context: nil).size
        return size
    }
    
    //MARK: - GCD timer
    class func GCDTimerCountdown(interval: CGFloat, count: Int, handler: @escaping (Int) -> ()) {
        guard count > 0 else {
            return
        }
        
        let timer = DispatchSource.makeTimerSource(flags: [], queue: DispatchQueue.main)
        var repeatCount = count
        
        timer.schedule(deadline: .now(), repeating: DispatchTimeInterval.seconds(Int(interval)), leeway: DispatchTimeInterval.seconds(0))
        timer.setEventHandler {
            repeatCount -= 1
            
            DispatchQueue.main.async {
                handler(repeatCount)
            }
            
            if repeatCount <= 0 {
                timer.cancel()
            }
        }
        
        timer.resume()
    }
    
    class func createGCDTimer(interval: DispatchTimeInterval, handler: @escaping () -> ()) -> DispatchSourceTimer {
        let timer = DispatchSource.makeTimerSource(flags: [], queue: DispatchQueue.main)
        
        timer.schedule(deadline: .now(), repeating: interval)
        timer.setEventHandler() {
            DispatchQueue.main.async {
                handler()
            }
        }
        
        return timer
    }
    
    //MARK: - 测试方法执行时长
    class func testFuncAbsoluteTime(block: () -> Void) {
        let start = CFAbsoluteTimeGetCurrent()
        block()
        let end = CFAbsoluteTimeGetCurrent()
        let decimalNumber = NSDecimalNumber(string: "\(end - start)")
        ZFPrint("TimeGetCurrent: \(decimalNumber.toString(8))")
    }
    
    class func testFuncMediaTime(block: () -> Void) {
        let start = CACurrentMediaTime()
        block()
        let end = CACurrentMediaTime()
        let decimalNumber = NSDecimalNumber(string: "\(end - start)")
        ZFPrint("TimeGetCurrent: \(decimalNumber.toString(8))")
    }
    
    @available(iOS 12.0, *)
    class func osLog_funcTime(category: String, name: StaticString = "func duration", block: () -> Void) {
        let bundleID = Bundle.main.bundleIdentifier ?? "com.zltest.oslog"
        let refreshLog = OSLog(subsystem: bundleID, category: category)
        
        os_signpost(.begin, log: refreshLog, name: name)
        block()
//        defer {
            os_signpost(.end, log: refreshLog, name: name)
//        }
    }
    
    //MARK: - timeinterval/Date
    class func getCurrentTimeString(format: String = "yyyy-MM-dd HH:mm:ss") -> String {//yyyy-MM-dd HH:mm:ss
        let currentDate = Date()
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = format
        let timeString = dateformatter.string(from: currentDate)
        
        return timeString
    }
    
    //获取时间戳(精确到毫秒)
    class func getTimeInterval(with timeString: String, format: String = "yyyy-MM-dd HH:mm:ss", isThousand: Bool = false) -> String {
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = format
        let currentDate = dateformatter.date(from: timeString)
//        var interval = (currentDate?.timeIntervalSince1970)!
        guard var interval = (currentDate?.timeIntervalSince1970) else {
            return ""
        }
        if isThousand {
            interval = interval*1000
        }
        return String(format: "%.0f", interval)
    }
    
    //时间戳转化为年月日
    class func getDateString(with timeInterval: TimeInterval, format: String = "yyyy-MM-dd HH:mm:ss", isThousand: Bool = false) -> String {
        var seconds = timeInterval
        if isThousand {
            seconds = timeInterval/1000
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: Date(timeIntervalSince1970: seconds))
    }
    
    class func getTimeGap(with dateString: String, format: String = "yyyy-MM-dd HH:mm:ss") -> String {
        var timeString = ""
        
        if dateString.isEmpty {
            return timeString
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        
        let currentDateString = dateFormatter.string(from: Date())
        
        let gregorian = Calendar(identifier: Calendar.Identifier.gregorian)
        if let otherDate = dateFormatter.date(from: dateString), let currentDate = dateFormatter.date(from: currentDateString) {
            let comps = gregorian.dateComponents([Calendar.Component.day, Calendar.Component.hour, Calendar.Component.minute, Calendar.Component.second], from: otherDate, to: currentDate)
            
            if comps.day ?? 0 > 10 {
                let calendar = Calendar.current
                let yearComps = calendar.dateComponents([Calendar.Component.year, Calendar.Component.month, Calendar.Component.day, Calendar.Component.hour, Calendar.Component.minute, Calendar.Component.second], from: otherDate)
                if comps.day ?? 0 > 365 {
                    guard let year = yearComps.year, let month = yearComps.month, let day = yearComps.day else {
                        return timeString
                    }
                    timeString = "\(year)-\(month)-\(day)"
                }else {
                    guard let month = yearComps.month, let day = yearComps.day else {
                        return timeString
                    }
                    timeString = "\(month)-\(day)"
                }
            }else if comps.day ?? 0 > 0 {
                guard let day = comps.day else {
                    return timeString
                }
                timeString = "\(day)天前"
            }else if comps.hour ?? 0 > 0 {
                guard let hour = comps.hour else {
                    return timeString
                }
                timeString = "\(hour)小时前"
            }else if comps.minute ?? 0 > 0 {
                guard let minute = comps.minute else {
                    return timeString
                }
                timeString = "\(minute)分钟前"
            }else {
                timeString = "刚刚"
            }
        }
        
        return timeString
    }
    
    class func compareDate(with oneDay: Date, anotherDay:Date, format: String = "yyyy-MM-dd HH:mm:ss") -> Int {
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = format
        
        let oneString = dateformatter.string(from: oneDay)
        let dateA = dateformatter.date(from: oneString)
        
        let anotherString = dateformatter.string(from: anotherDay)
        let dateB = dateformatter.date(from: anotherString)
        
        let result = dateA?.compare(dateB!)
        var compareNum = 0
        if result == .orderedDescending {//dateA  is in the future
            compareNum = 1
        }
        
        if result == .orderedAscending {//dateA is in the past
            compareNum = -1
        }
        
//        switch result {
//        case .orderedDescending?: //dateA  is in the future
//            compareNum = 1
//        case .orderedAscending?: //dateA is in the past
//            compareNum = -1
//        case .none:
//            compareNum = 100
//        case .some(.orderedSame): //Both dates are the same
//            compareNum = 0
//        }
        
        return compareNum
    }
    
    //两个时间的时间差
    class func getDifferenceBy(preTime: String, afterTime: String, format: String = "yyyy-MM-dd HH:mm:ss") -> DateComponents? {
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = format
        
        guard let preDate = dateformatter.date(from: preTime) else { return nil }
        guard let afDate = dateformatter.date(from: afterTime) else { return nil }
        let gregorian = NSCalendar(calendarIdentifier: .gregorian)
        let components = gregorian?.components([.year, .month, .day, .hour, .minute, .second], from: preDate, to: afDate, options: .wrapComponents)
        
        //使用结果 记得取绝对值abs()
        return components
    }
    
    // MARK: - 两个时间戳的时间差
    class func getTimeIntervalDifferenceBy(preTime: TimeInterval, afterTime: TimeInterval, format: String = "yyyy-MM-dd HH:mm:ss") -> DateComponents? {
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = format
        
        let preDate = Date(timeIntervalSince1970: preTime)
        let afDate = Date(timeIntervalSince1970: afterTime)
        let gregorian = NSCalendar(calendarIdentifier: .gregorian)
        let components = gregorian?.components([.year, .month, .day, .hour, .minute, .second], from: preDate, to: afDate, options: .wrapComponents)
        
        //使用结果 记得取绝对值abs()
        return components
    }
    
    class func getAgeBy(birthTime: String, format: String = "yyyy-MM-dd HH:mm:ss") -> Int {
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = format
        
        guard let preDate = dateformatter.date(from: birthTime) else { return 0 }
        let curDate = Date()
        let interval = curDate.timeIntervalSince(preDate) //获得当前时间与出生日期之间的时间间隔
        
        return Int(interval/(3600*24*365))
    }
    
    class func getDateAgoWith(originDate: Date, yearNum: Int) -> Date? {//从当前日期往后yearNum年
//        let curDate = Date()
        let calendar = Calendar.current
//
//        var components = calendar.dateComponents([Calendar.Component.year, Calendar.Component.month, Calendar.Component.day, Calendar.Component.hour, Calendar.Component.minute, Calendar.Component.second], from: curDate)
//
//        if components.year == nil {
//            return nil
//        }
//        components.year! -= yearNum
        
//        let res = calendar.date(from: components)
        
        let res = calendar.date(byAdding: .year, value: yearNum, to: originDate)
        
        return res
    }
    
    //将秒数转为时分秒(1:03:43)
    class func getDateComponentsFormat(second: TimeInterval) -> String? {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .month, .second]
        let outputString = formatter.string(from: second)
        return outputString
    }
    
    //MARK: - codable
    class func decodeModel<T>(model: T.Type, object: Any) -> T? where T: Decodable {
        
        do {
            let decoder = JSONDecoder()
//                decoder.keyDecodingStrategy = .convertFromSnakeCase
            
//                let dateFormatter = DateFormatter()
//                dateFormatter.dateFormat = "yyyy-MM-dd 'T' HH:mm:ssZ"
//                dateFormatter.timeZone = TimeZone(secondsFromGMT: 8)
//                decoder.dateDecodingStrategy = .formatted(dateFormatter)
            
            let data = try JSONSerialization.data(withJSONObject: object, options: .prettyPrinted)
            let resultModel = try decoder.decode(model, from: data)
            return resultModel
        } catch  {
            debugPrint("解析失败:\(error)")
        }
        
        return nil
    }
    
    class func decodeArray<T>(_ model: T.Type, object: Any) -> [T]? where T: Decodable {
        
        do {
            let decoder = JSONDecoder()
            let data = try JSONSerialization.data(withJSONObject: object, options: .prettyPrinted)
            let resultModels = try decoder.decode(Array<T>.self, from: data)
            return resultModels
        } catch  {
            debugPrint("解析失败:\(error)")
        }
        
        return nil
    }
    
    class func plistEncode<T>(model: T, key: String) where T: Encodable {
        let object = try? PropertyListEncoder().encode(model)
        UserDefaults.standard.setValue(object, forKey: key)
    }
    
    class func plistDecode<T>(model: T.Type, key: String, defaultData: Data? = nil) -> T? where T: Decodable {
        if let data = defaultData {
            let model = try? PropertyListDecoder().decode(model, from: data)
            return model
        }else {
            if let data = UserDefaults.standard.object(forKey: key) as? Data {
                let model = try? PropertyListDecoder().decode(model, from: data)
                return model
            }
        }
        
        return nil
    }
    
    //MARK: - dark mode
    class func setDynamicColor(defaultColor: UIColor, darkColor: UIColor, result: (UIColor) -> Void) {
        if #available(iOS 13.0, *) {
            let color = UIColor { (traitCollection) -> UIColor in
                if traitCollection.userInterfaceStyle == .dark {
                    return darkColor
                }else {
                    return defaultColor
                }
            }
            
            result(color)
        }else {
            result(defaultColor)
        }
    }
    
    //MARK: - bundle id
    class func showBundleID(_ controller: UIViewController) {
        let bundleID = Bundle.main.bundleIdentifier ?? "no bundleIdentifier"
        let alert = UIAlertController(title: "notice", message: bundleID, preferredStyle: .alert)
        let action = UIAlertAction(title: "确定", style: .cancel, handler: nil)
        alert.addAction(action)
        
        controller.present(alert, animated: true, completion: nil)
    }
    
    //MARK: - Authorization
    class func locationAuthorization(isAllow: () -> Void, notAllow: () -> Void, notDetermined: (() -> Void)? = nil) {
        let authStatus = CLLocationManager.authorizationStatus()
        
        if authStatus == .denied || authStatus == .restricted {
            notAllow()
        }else if authStatus == .notDetermined {
            notDetermined?()
        }else {
            isAllow()
        }
    }
    
    //相机-相册权限
    class func photoAuthorization(isAllow: () -> Void, notAllow: () -> Void, notDetermined: (() -> Void)? = nil) {
        var authStatus: PHAuthorizationStatus = .notDetermined
        if #available(iOS 14, *) {
            authStatus = PHPhotoLibrary.authorizationStatus(for: .readWrite)
        } else {
            authStatus = PHPhotoLibrary.authorizationStatus()
        }
        
        switch authStatus {
        case .denied, .restricted:
            notAllow()
//        case .notDetermined:
//            notDetermined?()
        default:
            isAllow()
        }
    }
    
    //视频权限
    class func videoCameraAuthorization(isAllow: () -> Void, notAllow: () -> Void, notDetermined: () -> Void) {
        let authStatus = AVCaptureDevice.authorizationStatus(for: .video)
        
        switch authStatus {
        case .denied, .restricted:
            notAllow()
//        case .notDetermined:
//            notDetermined()
        default:
            isAllow()
        }
    }
    
    //语音、麦克风权限
    class func audioAuthorization(isAllow: () -> Void, notAllow: () -> Void, notDetermined: (() -> Void)? = nil) {
        let authStatus = AVCaptureDevice.authorizationStatus(for: .audio)
        
        switch authStatus {
        case .denied, .restricted:
            notAllow()
        case .notDetermined:
            notDetermined?()
        default:
            isAllow()
        }
    }
    
    //通知权限
    class func pushNotificationAuthorization(isAllow: @escaping () -> Void, notAllow: @escaping () -> Void, notDetermined: @escaping () -> Void) {
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().getNotificationSettings { (settings: UNNotificationSettings) in
                let authStatus = settings.authorizationStatus
                
                if authStatus == .denied {
                    notAllow()
                }else if authStatus == .notDetermined {
                    notDetermined()
                }else {
                    isAllow()
                }
            }
        }else {
            if UIApplication.shared.isRegisteredForRemoteNotifications {
                isAllow()
            }else {
                notAllow()
            }
        }
        
    }
    
    //通讯录权限
    class func contactAuthorization(isAllow: () -> Void, notAllow: () -> Void, notDetermined: () -> Void) {
        let authStatus = CNContactStore.authorizationStatus(for: .contacts)
        
        if authStatus == .denied || authStatus == .restricted {
            notAllow()
        }else if authStatus == .notDetermined {
            notDetermined()
        }else {
            isAllow()
        }
    }
    
    class func goSystemSetting() {
        if let url = URL(string: UIApplication.openSettingsURLString) {
            if UIApplication.shared.canOpenURL(url) {
                if #available(iOS 10, *) {
                    UIApplication.shared.open(url, options: [UIApplication.OpenExternalURLOptionsKey.universalLinksOnly : false], completionHandler: nil)
                }else {
                    UIApplication.shared.openURL(url)
                }
            }
        }
    }
    
    //MARK: - localizedString
    class func localizedString(originString: String) -> String {
        return NSLocalizedString(originString, tableName: "", bundle: .main, value: "", comment: "")
    }
    
    //MARK: - file management
    /**
     folderName：Documents目录下的文件名
     subfile：folderName目录下的文件名
     */
    class func getDocumentFileDirectory() -> String {
        return NSHomeDirectory() + "/Documents/"
    }
    
    class func getDocumentFileUrl() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    class func getDocumentsFolderAndSubFile(folderName: String, subfile: String) -> String {
        let myPath: String = NSHomeDirectory() + "/Documents/\(folderName)/\(subfile)"
        return myPath
    }
    
    class func getDocumentsFolderFile(folderName: String? = nil) -> String {
        var myPath: String = NSHomeDirectory() + "/Documents/"
        
        if let folderName = folderName {
            myPath += folderName
        }
        
        return myPath
    }
    
    @discardableResult
    class func creatDocumentSaveFile(subfile: String) -> String? {
        let myPath = CommonFunction.getDocumentsFolderFile(folderName: subfile)
        
        if FileManager.default.fileExists(atPath: myPath) {
            return myPath
        }else {
            do {
                try FileManager.default.createDirectory(atPath: myPath, withIntermediateDirectories: true, attributes: nil)
                debugPrint("appendPath path: \(myPath)")
                return myPath
            } catch  {
                debugPrint("failed ++++")
                return nil
            }
        }
    }
    
    @discardableResult
    class func creatDocumentSaveFile(appendFolderName: String, subfile: String) -> String? {
        let myPath = CommonFunction.getDocumentsFolderAndSubFile(folderName: appendFolderName, subfile: subfile)
        
        if FileManager.default.fileExists(atPath: myPath) {
            return myPath
        }else {
            do {
                try FileManager.default.createDirectory(atPath: myPath, withIntermediateDirectories: true, attributes: nil)
                debugPrint("subfile path: \(myPath)")
                return myPath
            } catch  {
                debugPrint("failed ++++")
                return nil
            }
        }
    }
    
    @discardableResult
    class func createLibraryCacheFile(isTemp: Bool = false, folderName: String? = nil) -> String {
        var tempPath = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .allDomainsMask, true)[0]
        if isTemp {
            tempPath = NSTemporaryDirectory()
        }
        
        if let folderName = folderName {
            tempPath += "/\(folderName)/"
        }
        
        if FileManager.default.fileExists(atPath: tempPath) {
            return tempPath
        }else {
            do {
                try FileManager.default.createDirectory(atPath: tempPath, withIntermediateDirectories: true, attributes: nil)
                ZLPrint("appendPath path: \(tempPath)")
                return tempPath
            } catch  {
                ZLPrint("failed ++++")
                return ""
            }
        }
    }
    
    //复制文件夹下所有文件到另一个文件夹
    class func copyFileFrom(sourcePath: String, to toPath: String) throws {
        let files = try FileManager.default.contentsOfDirectory(atPath: sourcePath)
        for name in files {
            let fullPath = sourcePath + "/\(name)"
            let fullToPath = toPath + "/\(name)"
            
            var isFolder = ObjCBool(false)
            if FileManager.default.fileExists(atPath: fullPath, isDirectory: &isFolder) {
                try FileManager.default.copyItem(atPath: fullPath, toPath: fullToPath)
                
                if isFolder.boolValue {
                    try copyFileFrom(sourcePath: fullPath, to: fullToPath)
                }
            }
        }
    }
    
    class func deleteFile(fileName: String) {
        if FileManager.default.fileExists(atPath: fileName) {
            try! FileManager.default.removeItem(atPath: fileName)
        }
    }
    
    class func getFileName(from url: String, hasExtension: Bool = false) -> String {
        let url = URL(string: url)
        let fileNameWithExtension = url?.lastPathComponent
        var fileName = fileNameWithExtension
        
        if !hasExtension {
            fileName = (fileNameWithExtension as? NSString)?.deletingPathExtension
        }
        
        return fileName ?? ""
    }
    
    //MARK: - gif
    @available(iOS 14.0, *)
    class func canGenerateGif(photos: [UIImage], url: URL, loopCount: Int, delayTime: Double) -> Bool {
        let fileProperties = [kCGImagePropertyGIFDictionary: [kCGImagePropertyGIFLoopCount: loopCount]]
        let gifProperties = [kCGImagePropertyGIFDictionary: [kCGImagePropertyGIFDelayTime: delayTime]]
        guard let destination = CGImageDestinationCreateWithURL(url as CFURL, UTType.gif.identifier as CFString, photos.count, nil) else {
            return false
        }
        CGImageDestinationSetProperties(destination, fileProperties as CFDictionary)
        for photo in photos {
            CGImageDestinationAddImage(destination, photo.cgImage!, gifProperties as CFDictionary)
        }
        return CGImageDestinationFinalize(destination)
    }
    
    //MARK: - local
    class func loadLocalJson(_ name: String) -> Any? {
        let path = Bundle.main.path(forResource: name, ofType: nil)
        if let path = path {
            do {
                let url = URL(fileURLWithPath: path)
                let data = try Data(contentsOf: url)
                let object = try JSONSerialization.jsonObject(with: data, options: .mutableContainers)
                return object
            } catch  {
                debugPrint("解析失败:\(error)")
            }
        }
        return nil
    }
    
    class func saveImageToAlbum(image: UIImage, completion: ((Bool) -> Void)?) {
        let status = PHPhotoLibrary.authorizationStatus()
        
        if status == .denied || status == .restricted {
            completion?(false)
            return
        }
        
//        var placeholderAsset: PHObjectPlaceholder? = nil
        PHPhotoLibrary.shared().performChanges({
//            let newAssetRequest = PHAssetChangeRequest.creationRequestForAsset(from: image)
//            placeholderAsset = newAssetRequest.placeholderForCreatedAsset
            PHAssetChangeRequest.creationRequestForAsset(from: image)
        }) { (success, error) in
            DispatchQueue.main.async {
                //let asset = self.getAsset(from: placeholderAsset?.localIdentifier)
                completion?(success)
            }
        }
    }
    
    private class func getAsset(from localIdentifier: String?) -> PHAsset? {
        guard let id = localIdentifier else {
            return nil
        }
        let result = PHAsset.fetchAssets(withLocalIdentifiers: [id], options: nil)
        if result.count > 0{
            return result[0]
        }
        return nil
    }
    
    //MARK: - other
    class func setupNoDataView(tableView: UITableView, array: [Any], warnTitle: String = "暂无数据", imageName: String = "noData", type: LoadingType = .empty, retryBlock: (() -> Void)? = nil) {
        if array.isEmpty {
            let noDataView = NoDataView(frame: tableView.bounds, type: type)
            noDataView.firstLabel.text = warnTitle
            noDataView.noImageView.image = UIImage(named: imageName)
            tableView.tableFooterView = noDataView
            noDataView.retryBlock = retryBlock
        }else {
            tableView.tableFooterView = UIView()
        }
    }
    
    class func getOptionalNumString(dict: [String: Any], key: String) -> String {
        
        if dict.isEmpty {
            return "0"
        }
        
        if let result = dict[key] {
            if result is String {
                return result as! String
            }
            
            if result is Int {
                return "\(result)"
            }
            
            if result is CGFloat {
                return "\(result)"
            }
        }
        
        return "0"
    }
    
//    #import <mach/mach.h>
//    - (int64_t)memoryUsage {
//        int64_t memoryUsageInByte = 0;
//        struct task_basic_info taskBasicInfo;
//        mach_msg_type_number_t size = sizeof(taskBasicInfo);
//        kern_return_t kernelReturn = task_info(mach_task_self(), TASK_BASIC_INFO, (task_info_t) &taskBasicInfo, &size);
//        
//        if(kernelReturn == KERN_SUCCESS) {
//            memoryUsageInByte = (int64_t) taskBasicInfo.resident_size;
//            NSLog(@"Memory in use (in bytes): %lld", memoryUsageInByte);
//        } else {
//            NSLog(@"Error with task_info(): %s", mach_error_string(kernelReturn));
//        }
//        
//        return memoryUsageInByte;
//    }
    
    //MARK: -
    class func getFrontController() -> UIViewController? {
        var nav: UINavigationController?
        let rootVC = getKeyWindow()?.rootViewController
        
        if rootVC is ZLTarBarViewController {
            nav = (rootVC as? ZLTarBarViewController)?.selectedViewController as? UINavigationController
        }else if rootVC is UINavigationController {
            nav = rootVC as? UINavigationController
        }
        
//        else if rootVC is AdViewController {
//            nav = rootVC?.navigationController
//        }
        
        return nav?.visibleViewController
    }
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToCAMediaTimingFillMode(_ input: String) -> CAMediaTimingFillMode {
	return CAMediaTimingFillMode(rawValue: input)
}
