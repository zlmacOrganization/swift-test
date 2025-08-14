//
//  AppDelegate.swift
//  SwiftTest
//
//  Created by ZhangLiang on 16/12/11.
//  Copyright © 2016年 ZhangLiang. All rights reserved.
//

import UIKit
import AddressBook
import AVFoundation
import Alamofire
import BackgroundTasks
import UserNotifications
import AuthenticationServices
import Photos
import IQKeyboardManagerSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    
    private let nbaTeamType = "zl_nbaTeamAction"
    private let nameTableType = "zl_nameTableAction"

    var window: UIWindow?
    var delegate = UIApplication.shared.delegate as? AppDelegate
    
    private var shortcutItem: UIApplicationShortcutItem?
    private var backTask: UIBackgroundTaskIdentifier?
    var backgroundTaskId : UIBackgroundTaskIdentifier?
    
    private var effectImageView: UIImageView?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        navigationBarConfig()
        registerPushNotification()
        LeakInspector.delegate = LeakInspectorAlertProvider()
//        IQKeyboardManager.shared.enable = true
        
        if let shortItem = launchOptions?[UIApplication.LaunchOptionsKey.shortcutItem] as? UIApplicationShortcutItem {
            shortcutItem = shortItem
        }
        
        setupRootVC()
        UIButton.zl_initializeMethod()
//        if #available(iOS 13.0, *) {
//            BGTaskScheduler.shared.register(forTaskWithIdentifier: "com.background.zlTest.refresh", using: nil) { (task) in
////                self.handleAppRefresh(task: task as! BGAppRefreshTask)
//            }
//        }
        
        return true
    }
    
    private func setupRootVC() {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.backgroundColor = UIColor.white
        
        let tabBarVC = ZLTarBarViewController()
        window?.rootViewController = tabBarVC
        
        window?.makeKeyAndVisible()
    }
    
    private func navigationBarConfig() {
//        UINavigationBar.appearance().tintColor = UIColor.purple //默认navgationItem的字体颜色
//        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.darkGray] //导航栏 title颜色
//        UINavigationBar.appearance().shadowImage = UIImage() //去掉导航栏底部黑线
        UINavigationBar.appearance().isTranslucent = false
        
        //        UIApplication.shared.statusBarStyle = UIStatusBarStyle.lightContent
    }
    
    @available(iOS 13.0, *)
    func handleAppRefresh(task: BGAppRefreshTask) {
       // Schedule a new refresh task
       scheduleAppRefresh()

       // Create an operation that performs the main part of the background task
//       let operation = RefreshAppContentsOperation()
       
       // Provide an expiration handler for the background task
       // that cancels the operation
//       task.expirationHandler = {
//          operation.cancel()
//       }
//
//       // Inform the system that the background task is complete
//       // when the operation completes
//       operation.completionBlock = {
//          task.setTaskCompleted(success: !operation.isCancelled)
//       }
//
//       // Start the operation
//       operationQueue.addOperation(operation)
     }
    
    @available(iOS 13.0, *)
    func scheduleAppRefresh() {
       let request = BGAppRefreshTaskRequest(identifier: "com.background.zlTest.refresh")
       // Fetch no earlier than 15 minutes from now
       request.earliestBeginDate = Date(timeIntervalSinceNow: 10)
            
       do {
        print("BGTaskScheduler ++++")
          try BGTaskScheduler.shared.submit(request)
       } catch {
          print("Could not schedule app refresh: \(error)")
       }
    }
    
    private func registerPushNotification() {
        if #available(iOS 10.0, *) {
            UIApplication.shared.registerForRemoteNotifications()
            let notificationCenter = UNUserNotificationCenter.current()
            notificationCenter.delegate = self

//            notificationCenter.requestAuthorization(options: [.alert, .badge, .sound]) { (flag, error) in
//                if flag {
//                    print("request push notification success")
//                }else{
//                    print("request push notification fail")
//                }
//            }
        }else{
//            let types = UInt8(UIUserNotificationType.alert.rawValue) | UInt8(UIUserNotificationType.badge.rawValue) | UInt8(UIUserNotificationType.sound.rawValue)
            let settings = UIUserNotificationSettings(types: [.badge, .sound, .alert], categories: nil)
            UIApplication.shared.registerUserNotificationSettings(settings)
        }
    }
    
    private func asAuthorization() {
        
        if #available(iOS 13.0, *) {
            let appleIDProvider = ASAuthorizationAppleIDProvider()
            appleIDProvider.getCredentialState(forUserID: KeychainItem.currentUserIdentifier) { (state, error) in
                switch state {
                    
                case .authorized:
                    break
                    
                case .revoked:
                    break
                    
                case .notFound:
                    break
                    
                default:
                    break
                }
            }
        } else {
            // Fallback on earlier versions
        }
    }
    
    //MARK: -
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let token = deviceToken.map {String(format: "%02.2hhx", $0)}.joined()
        debugPrint("deviceToken: \(token)")
    }

    func applicationWillResignActive(_ application: UIApplication) {
        let nbaItem = UIApplicationShortcutItem(type: nbaTeamType, localizedTitle: "NBA", localizedSubtitle: "subtitle", icon: UIApplicationShortcutIcon(systemImageName: "pencil.circle"))
        let nameTableItem = UIApplicationShortcutItem(type: nameTableType, localizedTitle: "nameTable")
        
        application.shortcutItems = [nbaItem, nameTableItem]
        
        //金融app后台模糊处理(指纹验证时需要添加判断)
//        if effectImageView == nil {
//            let frame = window?.bounds ?? CGRect(x: 0, y: 0, width: kMainScreenWidth, height: kMainScreenHeight)
//            let effectView = UIVisualEffectView(effect: UIBlurEffect(style: .light))
//            effectView.frame = frame
//            effectView.alpha = 0.5
//
//            effectImageView = UIImageView(frame: frame)
//            effectImageView?.contentMode = .scaleAspectFill
//            effectImageView?.clipsToBounds = true
//            effectImageView?.image = UIImage(named: "thumb18")
//            effectImageView?.addSubview(effectView)
//            UIApplication.shared.keyWindow?.addSubview(effectImageView!)
//        }
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        backTask = application.beginBackgroundTask(withName: "webTest", expirationHandler: {
            application.endBackgroundTask(self.backTask!)
        })
        
        //开启后台处理多媒体事件
        UIApplication.shared.beginReceivingRemoteControlEvents()
        let session = AVAudioSession.sharedInstance()
        do{
            try session.setActive(true,
                                  options: AVAudioSession.SetActiveOptions.init(rawValue: 0))
        }catch let error{
            debugPrint(error)
        }

        do {
            if #available(iOS 10.0, *) {
                try session.setCategory(AVAudioSession.Category.playback,
                                        mode: AVAudioSession.Mode.default,
                                        options: AVAudioSession.CategoryOptions.init(rawValue: 0))
            }
        }catch let error{
            debugPrint(error)
        }
        /// 注册后台进程id
        backgroundTaskId = backgroundPlayerId(backgroundTaskId ?? UIBackgroundTaskIdentifier.invalid)
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        UIApplication.shared.applicationIconBadgeNumber = 0
        
//        effectImageView?.removeFromSuperview()
//        effectImageView = nil
        
        if let item = shortcutItem {
            let tabBarVC = window?.rootViewController as? ZLTarBarViewController
            
            if item.type == nbaTeamType {
                tabBarVC?.selectedIndex = 1
            }else if item.type == nameTableType {
                let tableVC = NameTableViewController(style: .plain)
                let nav = tabBarVC?.selectedViewController as? UINavigationController
                nav?.visibleViewController?.zl_pushViewController(tableVC)
                
//                CommonFunction.getFrontController()?.zl_pushViewController(tableVC)
            }
        }
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func application(_ application: UIApplication, performActionFor shortcutItem: UIApplicationShortcutItem, completionHandler: @escaping (Bool) -> Void) {
        self.shortcutItem = shortcutItem
    }
    
//    func registerNotificationWithApplication(_ application: UIApplication) {
//        if application .responds(to: #selector(registerUserNotificationSettings:)) {
//            
//        }
//    }
    
    private func backgroundPlayerId(_ backTaskId:UIBackgroundTaskIdentifier) -> UIBackgroundTaskIdentifier{
        setupAudioSession()

        UIApplication.shared.beginReceivingRemoteControlEvents()
        var nTaskId = UIBackgroundTaskIdentifier.invalid
        nTaskId = UIApplication.shared.beginBackgroundTask(expirationHandler: nil)
        
        if nTaskId != UIBackgroundTaskIdentifier.invalid && backTaskId != UIBackgroundTaskIdentifier.invalid {
            UIApplication.shared.endBackgroundTask(backTaskId)
        }
        
        return nTaskId
    }
    
    private func setupAudioSession() {
        let session = AVAudioSession.sharedInstance()
        if #available(iOS 10.0, *) {
            do{
                try session.setCategory(.playback, mode: .default, options: [])
            }catch let error {
                debugPrint(error)
            }
        } else {
            session.perform(NSSelectorFromString("setCategory:error:"), with: AVAudioSession.Category.playback)
        }
        
//        if #available(iOS 11.0, *) {
//            do{
//                try session.setCategory(.playback, mode: .default, policy: .default, options: .defaultToSpeaker)
//            }catch let error {
//                debugPrint(error)
//            }
//        } else {
//
//        }
        
        do {
            try session.setActive(true, options: .notifyOthersOnDeactivation)
        }catch let error {
            debugPrint(error)
        }
    }
    
    // MARK: - remote Event
    override func remoteControlReceived(with event: UIEvent?) {
        switch event?.subtype {
        case .remoteControlPlay:
            NotificationCenter.default.post(name: .event_remoteControlPlay, object: nil)
        case .remoteControlPause:
            NotificationCenter.default.post(name: .event_remoteControlPause, object: nil)
        case .remoteControlStop:
            NotificationCenter.default.post(name: .event_remoteControlStop, object: nil)
            
        case .remoteControlNextTrack:
            NotificationCenter.default.post(name: .event_remoteControlNextTrack, object: nil)
        case .remoteControlPreviousTrack:
            NotificationCenter.default.post(name: .event_remoteControlPreviousTrack, object: nil)
            
        case .remoteControlBeginSeekingBackward:
            NotificationCenter.default.post(name: .event_remoteControlBeginSeekingBackward, object: nil)
        case .remoteControlEndSeekingBackward:
            NotificationCenter.default.post(name: .event_remoteControlEndSeekingBackward, object: nil)
            
        case .remoteControlBeginSeekingForward:
            NotificationCenter.default.post(name: .event_remoteControlBeginSeekingForward, object: nil)
        case .remoteControlEndSeekingForward:
            NotificationCenter.default.post(name: .event_remoteControlEndSeekingForward, object: nil)
            
        default:
            break
        }
    }
    
    // MARK: - Universal Link
    func application(_ application: UIApplication,
                     continue userActivity: NSUserActivity,
                     restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        // Get URL components from the incoming user activity.
//            guard userActivity.activityType == NSUserActivityTypeBrowsingWeb,
//                let incomingURL = userActivity.webpageURL,
//                let components = NSURLComponents(url: incomingURL, resolvingAgainstBaseURL: true) else { return }
//        
//        guard let path = components.path,
//            let params = components.queryItems else { return }
//            print("path = \(path)")
        
//        let unlink = userActivity.webpageURL?.absoluteString ?? ""
//        if unlink.contains(WechatAppId) {
//            // 从微信拉起app
//            return WXApi.handleOpenUniversalLink(userActivity,
//                                                 delegate: self)
//        }
        
        //快捷指令 跳转指定页面
        if let intent = userActivity.interaction?.intent, intent.isKind(of: AddIntent2Intent.classForCoder()) {
            let blurVC = BlurViewController()
            
            let tabBarVC = window?.rootViewController as? ZLTarBarViewController
            let nav = tabBarVC?.selectedViewController as? UINavigationController
            nav?.visibleViewController?.zl_pushViewController(blurVC)
        }
        
        return true
    }
    
    //MARK: - 

    //MARK: - UNUserNotificationCenterDelegate
//    @available(iOS 10.0, *)
//    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
//        print("在前台收到push通知，不处理")
//    }
//
//    @available(iOS 10.0, *)
//    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
//        let userInfo = response.notification.request.content.userInfo
//        print("UNNotification userInfo = \(userInfo)")
//
//    }
//
//    //before iOS 10
//    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
//        if application.applicationState == .active {
//
//        }else{
//
//        }
//
//        completionHandler(.newData)
//    }
}

