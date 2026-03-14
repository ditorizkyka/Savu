import SwiftUI

@main
struct savuappApp: App {
    @StateObject private var appState = AppState()
    @StateObject private var userStore = UserStore.shared
    @StateObject private var themeManager = ThemeManager.shared

    var body: some Scene {
        WindowGroup {
            Group {
                if appState.isOnboardingComplete {
                    MainTabView()
                } else {
                    OnboardingView()
                }
            }
            .environmentObject(appState)
            .environmentObject(userStore)
            .environmentObject(themeManager)
            .preferredColorScheme(themeManager.colorScheme)
        }
    }
}

