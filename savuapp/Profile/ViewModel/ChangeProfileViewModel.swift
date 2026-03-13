// ChangeProfileViewModel.swift
// savuapp > Profile > ViewModel

import SwiftUI
import Combine

@MainActor
final class ChangeProfileViewModel: ObservableObject {
    @Published var fullName: String       = ""
    @Published var selectedImage: UIImage? = nil
    @Published var showImagePicker: Bool   = false

    func load(from profile: ProfileViewModel) {
        fullName      = profile.fullName
        selectedImage = profile.profileImage
    }

    func saveChanges(to profile: ProfileViewModel) {
        profile.fullName = fullName
        if let img = selectedImage {
            profile.profileImage = img
        }
    }
}
