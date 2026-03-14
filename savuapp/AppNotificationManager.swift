// AppNotificationManager.swift
// savuapp

import Foundation
import UserNotifications
import Combine

@MainActor
final class AppNotificationManager: ObservableObject {
    static let shared = AppNotificationManager()
    
    @Published var isAuthorized = false
    
    private init() {
        checkPermission()
    }
    
    func requestPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            DispatchQueue.main.async {
                self.isAuthorized = granted
                if granted {
                    self.scheduleHourlyReminder()
                } else {
                    self.cancelAllNotifications()
                }
            }
        }
    }
    
    func checkPermission() {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            DispatchQueue.main.async {
                self.isAuthorized = settings.authorizationStatus == .authorized
            }
        }
    }
    
    // Scheduled every hour instead of just 8 PM
    func scheduleHourlyReminder() {
        cancelAllNotifications()
        
        let content = UNMutableNotificationContent()
        content.title = "Time to Check Your Finances!"
        content.body = "Keep track of your spending and income to stay on top of your goals."
        content.sound = .default
        
        // Trigger every 3600 seconds (1 hour)
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 3600, repeats: true)
        
        let request = UNNotificationRequest(identifier: "hourly_reminder", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling hourly notification: \(error.localizedDescription)")
            }
        }
    }
    
    // Triggered immediately after a transaction
    func sendTransactionNotification(type: String, amount: String) {
        guard isAuthorized else { return }
        
        let content = UNMutableNotificationContent()
        let isIncome = type.lowercased() == "income"
        content.title = isIncome ? "Income Added!" : "Expense Recorded"
        content.body = isIncome ? "You just added \(amount) to your balance." : "You just spent \(amount)."
        content.sound = .default
        
        // Trigger 1 second from now
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error sending transaction notification: \(error.localizedDescription)")
            }
        }
    }
    
    func cancelAllNotifications() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }
}
