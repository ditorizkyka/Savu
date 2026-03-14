// ProfileViewModel.swift
// savuapp > Profile > ViewModel

import SwiftUI
import Combine

@MainActor
final class ProfileViewModel: ObservableObject {
    // MARK: - UserDefaults Keys
    private enum Keys {
        static let notifications = "savu_notifications_enabled"
        static let language = "savu_selected_language"
        static let profileImagePath = "savu_profile_image"
    }

    // MARK: - Published State
    @Published var profileImage: UIImage? = nil

    @Published var notificationsEnabled: Bool {
        didSet {
            UserDefaults.standard.set(notificationsEnabled, forKey: Keys.notifications)
            if notificationsEnabled {
                AppNotificationManager.shared.requestPermission()
            } else {
                AppNotificationManager.shared.cancelAllNotifications()
            }
        }
    }

    @Published var darkModeEnabled: Bool {
        didSet { ThemeManager.shared.isDarkMode = darkModeEnabled }
    }

    @Published var selectedLanguage: String {
        didSet { UserDefaults.standard.set(selectedLanguage, forKey: Keys.language) }
    }

    private var cancellables = Set<AnyCancellable>()
    let userStore: UserStore

    init(userStore: UserStore = .shared) {
        self.userStore = userStore

        let defaults = UserDefaults.standard
        
        // Initialize all stored properties first
        self.darkModeEnabled = ThemeManager.shared.isDarkMode
        self.selectedLanguage = defaults.string(forKey: Keys.language) ?? "Indonesian"
        
        // Load persisted values (notifications defaults to true on first launch)
        if defaults.object(forKey: Keys.notifications) == nil {
            self.notificationsEnabled = false
        } else {
            self.notificationsEnabled = defaults.bool(forKey: Keys.notifications)
        }
        
        // Sync state with actual system permission
        AppNotificationManager.shared.checkPermission()
        if self.notificationsEnabled {
            AppNotificationManager.shared.requestPermission()
        }

        // Load profile image from file system
        self.profileImage = Self.loadProfileImage()

        // Re-publish when userStore changes
        userStore.objectWillChange
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in self?.objectWillChange.send() }
            .store(in: &cancellables)

        // Sync dark mode from ThemeManager changes
        ThemeManager.shared.$isDarkMode
            .receive(on: RunLoop.main)
            .sink { [weak self] value in
                if self?.darkModeEnabled != value {
                    self?.darkModeEnabled = value
                }
            }
            .store(in: &cancellables)
    }

    var fullName: String {
        let name = userStore.username
        return name.isEmpty ? "User" : name
    }

    var tagline: String {
        userStore.spendingTagline
    }

    // MARK: - Profile Image Persistence

    func saveProfileImage(_ image: UIImage) {
        profileImage = image
        guard let data = image.jpegData(compressionQuality: 0.8) else { return }
        let url = Self.profileImageURL()
        try? data.write(to: url)
    }

    private static func loadProfileImage() -> UIImage? {
        let url = profileImageURL()
        guard FileManager.default.fileExists(atPath: url.path),
              let data = try? Data(contentsOf: url) else { return nil }
        return UIImage(data: data)
    }

    private static func profileImageURL() -> URL {
        let docs = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        return docs.appendingPathComponent("savu_profile.jpg")
    }
}

