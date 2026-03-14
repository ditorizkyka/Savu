// ProfileModels.swift
// savuapp > Profile

import Foundation

// MARK: - UserProfile
struct UserProfile {
    var fullName: String
    var tagline: String
}

// MARK: - CategoryType
enum CategoryType: String, CaseIterable, Codable {
    case income  = "Income"
    case expense = "Expense"
}

// MARK: - Category
struct Category: Identifiable, Codable {
    let id: UUID
    var name: String
    var iconName: String
    var type: CategoryType

    init(id: UUID = UUID(), name: String, iconName: String, type: CategoryType) {
        self.id = id
        self.name = name
        self.iconName = iconName
        self.type = type
    }
}

