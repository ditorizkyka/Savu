// AppState.swift
// savuapp

import SwiftUI
import Combine

@MainActor
final class AppState: ObservableObject {
    @Published var isOnboardingComplete: Bool

    init() {
        // Read persisted onboarding status from UserStore
        self.isOnboardingComplete = UserDefaults.standard.bool(forKey: "savu_has_completed_onboarding")
    }
}
