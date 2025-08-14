//
//  AppStoreUpdateChecker.swift
//  SwiftTest
//
//  Created by zhangliang on 2022/10/27.
//  Copyright © 2022 zhangliang. All rights reserved.
//

import Foundation

@available(iOS 15.0, *)
struct AppStoreUpdateChecker {
    // Usage:
    //Task {
    //    if await AppStoreUpdateChecker.isNewVersionAvailable() {
    //        print("New version of app is availabe. Showing blocking alert!")
    //    }
    //}
    static func isNewVersionAvailable() async -> Bool {
        guard let bundleID = Bundle.main.bundleIdentifier,
            let currentVersionNumber = Bundle.main.releaseVersionNumber,
            //https://itunes.apple.com/lookup?appId=xxx
            let url = URL(string: "http://itunes.apple.com/lookup?bundleId=\(bundleID)") else {
            
            return false
        }

        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let appStoreResponse = try JSONDecoder().decode(AppStoreResponse.self, from: data)

            guard let latestVersionNumber = appStoreResponse.results.first?.version else {
                // No app with matching bundleID found
                return false
            }

            return currentVersionNumber != latestVersionNumber
        }
        catch {
            // TODO: Handle error
            return false
        }
    }
}

struct AppStoreResponse: Codable {
    let resultCount: Int
    let results: [Result]
}

// MARK: - Result
struct Result: Codable {
    let releaseNotes: String
    let releaseDate: String
    let version: String
}

private extension Bundle {
    var releaseVersionNumber: String? {
        infoDictionary?["CFBundleShortVersionString"] as? String
    }
}
