// AppState.swift
// savuapp

import SwiftUI
import Combine

@MainActor
final class AppState: ObservableObject {
    @Published var isOnboardingComplete: Bool

    private var cancellables = Set<AnyCancellable>()

    init() {
        // Read persisted onboarding status from UserStore
        self.isOnboardingComplete = UserDefaults.standard.bool(forKey: "savu_has_completed_onboarding")

        // Keep in sync with UserStore changes
        UserStore.shared.$hasCompletedOnboarding
            .receive(on: RunLoop.main)
            .sink { [weak self] value in
                self?.isOnboardingComplete = value
            }
            .store(in: &cancellables)
    }
}

