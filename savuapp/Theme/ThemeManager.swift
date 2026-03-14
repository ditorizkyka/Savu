// ThemeManager.swift
// savuapp > Theme

import SwiftUI
import Combine

@MainActor
final class ThemeManager: ObservableObject {

    // MARK: - Singleton
    static let shared = ThemeManager()

    // MARK: - UserDefaults Key
    private let key = "savu_dark_mode_enabled"

    // MARK: - Published State
    @Published var isDarkMode: Bool {
        didSet { UserDefaults.standard.set(isDarkMode, forKey: key) }
    }

    // MARK: - Init
    init() {
        self.isDarkMode = UserDefaults.standard.bool(forKey: key)
    }

    // MARK: - Computed
    var colorScheme: ColorScheme? {
        isDarkMode ? .dark : .light
    }
}
