//
//  AppDelegate.swift
//
//  Naver ID Login SDK for iOS Swift
//  Copyright (c) 2025-present NAVER Corp.
//  Apache-2.0
//

import UIKit
import NidThirdPartyLogin
import NidLogin

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        NidOAuth.shared
            .initialize(
                appName: ClientConfiguration.appName,
                clientId: ClientConfiguration.clientID,
                clientSecret: ClientConfiguration.clientSecret,
                urlScheme: ClientConfiguration.urlScheme
            )
        return true
    }
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
}
