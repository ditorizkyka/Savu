import SwiftUI

@main
struct savuappApp: App {
    @StateObject private var appState = AppState()
    @StateObject private var userStore = UserStore.shared
    @StateObject private var themeManager = ThemeManager.shared
    @State private var showSplash = true

    var body: some Scene {
        WindowGroup {
            Group {
                if showSplash {
                    SplashScreenView {
                        showSplash = false
                    }
                } else {
                    if appState.isOnboardingComplete {
                        MainTabView()
                    } else {
                        OnboardingView()
                    }
                }
            }
            .environmentObject(appState)
            .environmentObject(userStore)
            .environmentObject(themeManager)
            .preferredColorScheme(themeManager.colorScheme)
            .onAppear {
                UNUserNotificationCenter.current().delegate = NotificationDelegate.shared
                AppNotificationManager.shared.requestPermissionIfNeeded()
            }
        }
    }
}

