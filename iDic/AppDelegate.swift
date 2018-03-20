//
//  AppDelegate.swift
//  iDic
//
//  Created by Yura Granchenko on 4/9/17.
//  Copyright © 2017 Yura Granchenko. All rights reserved.
//

import UIKit
import UserNotifications
import GoogleSignIn

@UIApplicationMain

class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions
        launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        UNUserNotificationCenter.current().requestAuthorization(options: [.badge, .alert, .sound],
                                                                completionHandler: {_,_ in })
        application.registerForRemoteNotifications()
        Logger.configure()
        
        return true 
    }
    
    func application(_ application: UIApplication,
                     didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let deviceTokenString = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
        print("success in registering for remote notifications with token \(deviceTokenString)")
    }
    
    func application(_ application: UIApplication,
                     didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("failed to register for remote notifications: \(error.localizedDescription)")
    }
    
    func application(_ application: UIApplication,
                     didReceiveRemoteNotification
        userInfo: [AnyHashable : Any]) {
        print("Received push notification: \(userInfo)")
        let aps = userInfo["aps"] as! [String: Any]
        print("\(aps)")
    }
    
    func application(_ application: UIApplication,
                     open url: URL,
                     options: [UIApplicationOpenURLOptionsKey : Any]) -> Bool {
            return GIDSignIn.sharedInstance().handle(url,
                                                     sourceApplication:options[.sourceApplication] as? String,
                                                     annotation: [:])
    }
}
