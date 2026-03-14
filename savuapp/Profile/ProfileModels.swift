// ProfileModels.swift
// savuapp > Profile

import Foundation

// MARK: - UserProfile
struct UserProfile {
    var fullName: String
    var tagline: String
}

// MARK: - CategoryType
enum CategoryType: String, CaseIterable {
    case income  = "Income"
    case expense = "Expense"
}

// MARK: - Category
struct Category: Identifiable {
    let id: UUID = UUID()
    var name: String
    var iconName: String
    var type: CategoryType
}
