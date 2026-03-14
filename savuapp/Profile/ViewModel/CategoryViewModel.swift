// CategoryViewModel.swift
// savuapp > Profile > ViewModel

import Foundation
import Combine

@MainActor
final class CategoryViewModel: ObservableObject {
    @Published var selectedTab: CategoryType      = .income
    @Published var showInfoBanner: Bool           = true
    @Published var showNewCategorySheet: Bool     = false

    @Published var incomeCategories: [Category] = []
    @Published var expenseCategories: [Category] = []

    // MARK: - UserDefaults Keys
    static let incomeKey = "savu_income_categories"
    static let expenseKey = "savu_expense_categories"

    // MARK: - Default Categories
    static let defaultIncomeCategories: [Category] = [
        Category(name: "Salary",         iconName: "banknote",     type: .income),
        Category(name: "Freelance",      iconName: "laptopcomputer", type: .income),
        Category(name: "Investment",     iconName: "chart.line.uptrend.xyaxis", type: .income),
        Category(name: "Gift",           iconName: "gift",         type: .income),
        Category(name: "Work",           iconName: "briefcase",    type: .income),
        Category(name: "Other",          iconName: "ellipsis.circle", type: .income),
    ]

    static let defaultExpenseCategories: [Category] = [
        Category(name: "Food & Beverages", iconName: "fork.knife",  type: .expense),
        Category(name: "Shopping",         iconName: "cart",         type: .expense),
        Category(name: "Transportation",   iconName: "car",          type: .expense),
        Category(name: "Home & Utilities", iconName: "house",        type: .expense),
        Category(name: "Healthcare",       iconName: "heart",        type: .expense),
        Category(name: "Entertainment",    iconName: "gamecontroller", type: .expense),
        Category(name: "Education",        iconName: "graduationcap", type: .expense),
        Category(name: "Other",            iconName: "ellipsis.circle", type: .expense),
    ]

    // MARK: - Init
    init() {
        self.incomeCategories = Self.load(key: Self.incomeKey) ?? Self.defaultIncomeCategories
        self.expenseCategories = Self.load(key: Self.expenseKey) ?? Self.defaultExpenseCategories
    }

    var activeCategories: [Category] {
        selectedTab == .income ? incomeCategories : expenseCategories
    }

    func delete(_ category: Category) {
        if selectedTab == .income {
            incomeCategories.removeAll { $0.id == category.id }
        } else {
            expenseCategories.removeAll { $0.id == category.id }
        }
        save()
    }

    func add(name: String, iconName: String) {
        let cat = Category(name: name, iconName: iconName, type: selectedTab)
        if selectedTab == .income {
            incomeCategories.append(cat)
        } else {
            expenseCategories.append(cat)
        }
        save()
    }

    // MARK: - Persistence

    private func save() {
        if let incData = try? JSONEncoder().encode(incomeCategories) {
            UserDefaults.standard.set(incData, forKey: Self.incomeKey)
        }
        if let expData = try? JSONEncoder().encode(expenseCategories) {
            UserDefaults.standard.set(expData, forKey: Self.expenseKey)
        }
    }

    static func load(key: String) -> [Category]? {
        guard let data = UserDefaults.standard.data(forKey: key),
              let decoded = try? JSONDecoder().decode([Category].self, from: data) else {
            return nil
        }
        return decoded
    }
}

