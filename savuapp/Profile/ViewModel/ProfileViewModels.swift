// ProfileViewModel.swift
// savuapp > Profile > ViewModel

import SwiftUI
import Combine

@MainActor
final class ProfileViewModel: ObservableObject {
    @Published var profileImage: UIImage?  = nil
    @Published var notificationsEnabled: Bool = true
    @Published var darkModeEnabled: Bool      = false
    @Published var selectedLanguage: String   = "Indonesian"

    private var cancellables = Set<AnyCancellable>()
    let userStore: UserStore

    init(userStore: UserStore = .shared) {
        self.userStore = userStore

        // Re-publish when userStore changes
        userStore.objectWillChange
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in self?.objectWillChange.send() }
            .store(in: &cancellables)
    }

    var fullName: String {
        let name = userStore.username
        return name.isEmpty ? "User" : name
    }

    var tagline: String {
        userStore.spendingTagline
    }
}
