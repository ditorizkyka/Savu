// NewCategoryViewModel.swift
// savuapp > Profile > ViewModel

import Foundation
import Combine

@MainActor
final class NewCategoryViewModel: ObservableObject {
    @Published var categoryName: String    = ""
    @Published var selectedIconName: String = "cup.and.saucer"
    @Published var currentIconPage: Int    = 0

    let availableIcons: [[String]] = [
        [
            "house", "car", "heart", "star", "gift", "bolt", "fork.knife", "cart",
            "airplane", "bus", "tram", "bicycle", "figure.walk", "gamecontroller",
            "music.note", "film", "book", "graduationcap", "briefcase", "stethoscope"
        ],
        [
            "phone", "envelope", "globe", "wifi", "camera", "photo", "map", "location",
            "bell", "tag", "creditcard", "banknote", "chart.bar", "chart.pie", "waveform",
            "leaf", "flame", "drop", "snowflake", "sun.max"
        ],
        [
            "moon", "cloud", "wind", "umbrella", "clock", "alarm", "calendar",
            "folder", "doc", "pencil", "scissors", "paintbrush", "wrench", "hammer",
            "lock", "key", "shield", "flag", "person", "person.2"
        ],
    ]

    func save(to categoryVM: CategoryViewModel) {
        let trimmed = categoryName.trimmingCharacters(in: .whitespaces)
        guard !trimmed.isEmpty else { return }
        categoryVM.add(name: trimmed, iconName: selectedIconName)
    }
}
