//
//  Extension+NotificationName.swift
//  SwiftTest
//
//  Created by zhangliang on 2021/8/4.
//  Copyright © 2021 zhangliang. All rights reserved.
//

import Foundation
import UIKit

extension Notification.Name {
    static let bannerViewDidDisappear = Notification.Name("bannerViewDidDisappear")
    
    static let event_remoteControlPlay = Notification.Name("event_remoteControlPlay")
    static let event_remoteControlPause = Notification.Name("event_remoteControlPause")
    static let event_remoteControlStop = Notification.Name("event_remoteControlStop")
    
    static let event_remoteControlNextTrack = Notification.Name("event_remoteControlNextTrack")
    static let event_remoteControlPreviousTrack = Notification.Name("event_remoteControlPreviousTrack")
    
    static let event_remoteControlBeginSeekingBackward = Notification.Name("event_remoteControlBeginSeekingBackward")
    static let event_remoteControlEndSeekingBackward = Notification.Name("event_remoteControlEndSeekingBackward")
    
    static let event_remoteControlBeginSeekingForward = Notification.Name("event_remoteControlBeginSeekingForward")
    static let event_remoteControlEndSeekingForward = Notification.Name("event_remoteControlEndSeekingForward")
}
