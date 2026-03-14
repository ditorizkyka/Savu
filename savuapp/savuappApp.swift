//
//  savuappApp.swift
//  savuapp
//
//  Created by Andito Rizkyka Rianto on 11/03/26.
//

import SwiftUI

@main
struct savuappApp: App {
    @StateObject private var appState = AppState()
    @StateObject private var userStore = UserStore.shared

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
        }
    }
}
