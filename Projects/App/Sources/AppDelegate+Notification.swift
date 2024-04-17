//
//  AppDelegate+Notification.swift
//  App
//
//  Created by gnksbm on 2/27/24.
//  Copyright © 2024 GeonSeobKim. All rights reserved.
//

import UIKit
import BackgroundTasks
import UserNotifications

extension AppDelegate: UNUserNotificationCenterDelegate {
    func applicationDidEnterBackground(_ application: UIApplication) {
        let task = BGAppRefreshTaskRequest(
            identifier: "com.GeonSeobKim.KISStock"
        )
        task.earliestBeginDate = Date(timeIntervalSinceNow: 15 * 60)
        
        do {
            print("Background Task submit!")
            try BGTaskScheduler.shared.submit(task)
        } catch {
            print("Could not schedule app refesh")
        }
    }
    func delegateUNNotification() {
        UNUserNotificationCenter.current().delegate = self
    }
    
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (
            UNNotificationPresentationOptions
        ) -> Void
    ) {
        completionHandler([.badge, .sound])
    }
    
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse,
        withCompletionHandler completionHandler: @escaping () -> Void) {
        completionHandler()
    }
}
