//
//  AppDelegate.swift
//  MeditationTimer
//
//  Created by Stefan Peters on 27.11.17.
//  Copyright © 2017 Stefan Peters. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let userDefaults = UserDefaults.standard


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        // Set userDefaults standard values
        let userDefaultsStandards: [String: Any] = [
            DefaultsKeys.duration: 5,
            DefaultsKeys.preparation: 5,
            DefaultsKeys.startGong: 1,
            DefaultsKeys.endGong: 1,
            DefaultsKeys.theme: Theme.availableThemes.first!,
            DefaultsKeys.healthKitEnabled: false,
            DefaultsKeys.changedBrightness: true,
            DefaultsKeys.durationPickerHidden: false,
            DefaultsKeys.feedbackStatus: FeedbackStatus.notSubmitted.rawValue,
            DefaultsKeys.useSystemSound: true,
            DefaultsKeys.soundVolume: 0.2,
            DefaultsKeys.hasLaunchedApp: false,
            DefaultsKeys.debugMenuEnabled: false,
            DefaultsKeys.intervalTime: 0,
            DefaultsKeys.intervalGong: 0
        ]
        userDefaults.register(defaults: userDefaultsStandards)
        
        // Set initial storyboard
        self.window = UIWindow(frame: UIScreen.main.bounds)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let storyboardID = userDefaults.bool(forKey: DefaultsKeys.hasLaunchedApp) ? PropertyKeys.defaultStoryboard : PropertyKeys.firstLaunchStoryboard
        self.window?.rootViewController = storyboard.instantiateViewController(withIdentifier: storyboardID)
        self.window?.makeKeyAndVisible()
        
        // Set status bar to white
        UIApplication.shared.statusBarStyle = Theme.currentTheme.statusBar
        
        // Force initialization of shared AudioHelper instance
        AudioHelper.shared.stop()
        
        // Create sessions folder for persistence if it doesn't exist
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        var isDir : ObjCBool = false
        let archivePath = documentsDirectory.appendingPathComponent("sessions").path
        if !FileManager.default.fileExists(atPath: archivePath, isDirectory: &isDir) {
            try? FileManager.default.createDirectory(atPath: archivePath, withIntermediateDirectories: false, attributes: nil)
        }
        
        // Check if feedback should be currently sending or failed last time, if yes then start sending
        let currentFeedbackStatus = userDefaults.integer(forKey: DefaultsKeys.feedbackStatus)
        if currentFeedbackStatus == FeedbackStatus.submitting.rawValue || currentFeedbackStatus == FeedbackStatus.submitFailed.rawValue {
            FeedbackHelper.shared.send()
        }
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

