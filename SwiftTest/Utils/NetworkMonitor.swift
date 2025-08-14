//
//  NetworkMonitor.swift
//  SwiftTest
//
//  Created by zhangliang on 2022/3/16.
//  Copyright © 2022 zhangliang. All rights reserved.
//

import UIKit
import Network

@available(iOS 12.0, *)
final class NetworkMonitor: NSObject {
    static let shared = NetworkMonitor()
    private let queue = DispatchQueue(label: "NetworkConnectivityMonitor")
    
    private let monitor: NWPathMonitor
    private(set) var isConnected = false
    
    /// Checks if the path uses an NWInterface that is considered to
    /// be expensive
    ///
    /// Cellular interfaces are considered expensive. WiFi hotspots
    /// from an iOS device are considered expensive. Other
    /// interfaces may appear as expensive in the future.
    private(set) var isExpensive = false
    
    private(set) var connectionType: NWInterface.InterfaceType?
    
    private override init() {
        monitor = NWPathMonitor()
    }
    
    func startMonitoring() {
        monitor.pathUpdateHandler = {[weak self] path in
            guard let self = self else { return }
            
            self.isConnected = path.status != .unsatisfied
            self.isExpensive = path.isExpensive
            self.connectionType = NWInterface.InterfaceType.allCases.filter{path.usesInterfaceType($0)}.first
            
            NotificationCenter.default.post(name: .connectivityStatus, object: nil)
        }
        
        self.monitor.start(queue: self.queue)
    }
    
    func stopMonitoring() {
        monitor.cancel()
    }
}

extension Notification.Name {
    static let connectivityStatus = Notification.Name(rawValue: "connectivityStatusChanged")
}

@available(iOS 12.0, *)
extension NWInterface.InterfaceType: CaseIterable {
    public static var allCases: [NWInterface.InterfaceType] = [
        .wifi,
        .cellular,
        .loopback,
        .wiredEthernet,
        .other,
    ]
}
