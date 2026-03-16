// AppNotificationManager.swift
// savuapp

import Foundation
import UserNotifications
import Combine

@MainActor
final class AppNotificationManager: ObservableObject {
    static let shared = AppNotificationManager()

    @Published var isAuthorized = false

    private let dailyReminderIdentifier = "savu_daily_8pm_reminder"

    private init() {
        checkPermission()
    }

    /// Requests permission only when the system status is `.notDetermined`.
    /// If already authorized, refreshes state and ensures daily reminder is scheduled.
    func requestPermissionIfNeeded() {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            DispatchQueue.main.async {
                switch settings.authorizationStatus {
                case .notDetermined:
                    self.requestPermission()
                case .authorized, .provisional, .ephemeral:
                    self.isAuthorized = true
                    self.scheduleDailyReminder()
                default:
                    self.isAuthorized = false
                }
            }
        }
    }

    func requestPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            DispatchQueue.main.async {
                self.isAuthorized = granted
                if granted {
                    self.scheduleDailyReminder()
                } else {
                    self.cancelDailyReminder()
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

    /// Schedules a repeating daily notification at 8:00 PM.
    func scheduleDailyReminder() {
        cancelDailyReminder()

        let content = UNMutableNotificationContent()
        content.title = "Your Daily Insights Are Ready 🎉"
        content.body = "Open Savu to see your personalised financial summary for today."
        content.sound = .default

        var dateComponents = DateComponents()
        dateComponents.hour = 20
        dateComponents.minute = 0

        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        let request = UNNotificationRequest(identifier: dailyReminderIdentifier, content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("❌ Error scheduling 8 PM daily notification: \(error.localizedDescription)")
            } else {
                print("🔔 Scheduled daily 8 PM notification")
            }
        }
    }

    /// Cancels only the daily 8 PM reminder, leaving transaction notifications intact.
    func cancelDailyReminder() {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [dailyReminderIdentifier])
    }

    // Triggered immediately after a transaction
    func sendTransactionNotification(type: String, amount: String) {
        guard isAuthorized else { return }

        let content = UNMutableNotificationContent()
        let isIncome = type.lowercased() == "income"
        content.title = isIncome ? "Income Added!" : "Expense Recorded"
        content.body = isIncome ? "You just added \(amount) to your balance." : "You just spent \(amount)."
        content.sound = .default

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("❌ Error sending transaction notification: \(error.localizedDescription)")
            }
        }
    }

    func cancelAllNotifications() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }
}
