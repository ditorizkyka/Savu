// ProfileViewModel.swift
// savuapp > Profile > ViewModel

import SwiftUI
import Combine

@MainActor
final class ProfileViewModel: ObservableObject {
    @Published var fullName: String        = "Dema Vander"
    @Published var tagline: String         = "The Spender"
    @Published var profileImage: UIImage?  = nil
    @Published var notificationsEnabled: Bool = true
    @Published var darkModeEnabled: Bool      = false
    @Published var selectedLanguage: String   = "Indonesian"
}
