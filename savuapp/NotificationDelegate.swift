// NotificationDelegate.swift
// savuapp

import Foundation
import UserNotifications

// Handles notifications while the app is in the foreground
final class NotificationDelegate: NSObject, UNUserNotificationCenterDelegate {
    
    static let shared = NotificationDelegate()
    
    private override init() {
        super.init()
    }
    
    // This allows the notification to show an alert/banner even if the app is currently open
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
    ) {
        // Show banner and play sound even when app is active
        completionHandler([.banner, .sound])
    }
}
