// AddTransactionViewModel.swift
// savuapp > Views > Transaction

import SwiftUI
import Combine

@MainActor
final class AddTransactionViewModel: ObservableObject {
    @Published var selectedType: TransactionType = .income
    @Published var date: Date = Date()
    @Published var title: String = ""
    @Published var amount: String = ""
    @Published var selectedCategory: String = ""
    @Published var showCategoryPicker: Bool = false

    // MARK: - Category Options
    let incomeCategories: [(name: String, icon: String)] = [
        ("Salary", "banknote"),
        ("Freelance", "laptopcomputer"),
        ("Investment", "chart.line.uptrend.xyaxis"),
        ("Gift", "gift"),
        ("Work", "briefcase"),
        ("Other", "ellipsis.circle"),
    ]

    let expenseCategories: [(name: String, icon: String)] = [
        ("Food & Beverages", "fork.knife"),
        ("Transport", "car.fill"),
        ("Shopping", "cart"),
        ("Entertainment", "gamecontroller"),
        ("Healthcare", "heart"),
        ("Home & Utilities", "house"),
        ("Education", "graduationcap"),
        ("Other", "ellipsis.circle"),
    ]

    var currentCategories: [(name: String, icon: String)] {
        selectedType == .income ? incomeCategories : expenseCategories
    }

    var selectedIconName: String {
        let cats = currentCategories
        return cats.first(where: { $0.name == selectedCategory })?.icon ?? "questionmark.circle"
    }

    var canSave: Bool {
        !title.trimmingCharacters(in: .whitespaces).isEmpty &&
        !amount.isEmpty &&
        (Double(amount) ?? 0) > 0 &&
        !selectedCategory.isEmpty
    }

    // MARK: - Save

    func save(to store: TransactionStore) {
        guard canSave, let amountValue = Double(amount) else { return }

        let transaction = StoredTransaction(
            title: title.trimmingCharacters(in: .whitespaces),
            amount: amountValue,
            category: selectedCategory,
            iconName: selectedIconName,
            type: selectedType,
            date: date
        )

        store.add(transaction)
        
        // Trigger notification if enabled
        AppNotificationManager.shared.sendTransactionNotification(
            type: selectedType.rawValue,
            amount: transaction.formattedAmount
        )
        
        resetForm()
    }

    // MARK: - Reset

    private func resetForm() {
        title = ""
        amount = ""
        selectedCategory = ""
        date = Date()
    }
}
