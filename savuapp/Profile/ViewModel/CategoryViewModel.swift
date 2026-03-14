// CategoryViewModel.swift
// savuapp > Profile > ViewModel

import Foundation
import Combine

@MainActor
final class CategoryViewModel: ObservableObject {
    @Published var selectedTab: CategoryType      = .income
    @Published var showInfoBanner: Bool           = true
    @Published var showNewCategorySheet: Bool     = false

    @Published var incomeCategories: [Category] = [
        Category(name: "Food & Dining",   iconName: "fork.knife", type: .income),
        Category(name: "Shopping",         iconName: "cart",       type: .income),
        Category(name: "Transportation",   iconName: "car",        type: .income),
        Category(name: "Home & Utilities", iconName: "house",      type: .income),
        Category(name: "Healthcare",       iconName: "heart",      type: .income),
        Category(name: "Entertainment",    iconName: "gift",       type: .income),
        Category(name: "Utilities",        iconName: "bolt",       type: .income),
    ]

    @Published var expenseCategories: [Category] = [
        Category(name: "Food & Dining",   iconName: "fork.knife", type: .expense),
        Category(name: "Shopping",         iconName: "cart",       type: .expense),
        Category(name: "Transportation",   iconName: "car",        type: .expense),
        Category(name: "Home & Utilities", iconName: "house",      type: .expense),
        Category(name: "Healthcare",       iconName: "heart",      type: .expense),
        Category(name: "Entertainment",    iconName: "gift",       type: .expense),
        Category(name: "Utilities",        iconName: "bolt",       type: .expense),
    ]

    var activeCategories: [Category] {
        selectedTab == .income ? incomeCategories : expenseCategories
    }

    func delete(_ category: Category) {
        if selectedTab == .income {
            incomeCategories.removeAll { $0.id == category.id }
        } else {
            expenseCategories.removeAll { $0.id == category.id }
        }
    }

    func add(name: String, iconName: String) {
        let cat = Category(name: name, iconName: iconName, type: selectedTab)
        if selectedTab == .income {
            incomeCategories.append(cat)
        } else {
            expenseCategories.append(cat)
        }
    }
}
