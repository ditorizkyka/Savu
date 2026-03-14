// HomeViewModel.swift
// savuapp > Views > HomePage

import SwiftUI
import Combine

// MARK: - Category Slice Model
struct CategorySlice: Identifiable {
    let id = UUID()
    let name: String
    let amount: Double
    let color: Color
    var percentage: Double = 0
}

@MainActor
final class HomeViewModel: ObservableObject {
    var savingsGoalPercent: Double {
        let income = store.totalIncome
        guard income > 0 else { return 0 }
        return max(0, min(1, (income - store.totalExpense) / income))
    }

    private var cancellables = Set<AnyCancellable>()
    let store: TransactionStore
    let userStore: UserStore

    // MARK: - Init
    init(store: TransactionStore = .shared, userStore: UserStore = .shared) {
        self.store = store
        self.userStore = userStore

        // Re-publish when store changes
        store.objectWillChange
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in self?.objectWillChange.send() }
            .store(in: &cancellables)

        // Re-publish when userStore changes
        userStore.objectWillChange
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in self?.objectWillChange.send() }
            .store(in: &cancellables)
    }

    // MARK: - User Data
    var userName: String {
        let name = userStore.username
        return name.isEmpty ? "User" : name
    }

    var profileImage: UIImage? {
        let docs = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let url = docs.appendingPathComponent("savu_profile.jpg")
        guard FileManager.default.fileExists(atPath: url.path),
              let data = try? Data(contentsOf: url) else { return nil }
        return UIImage(data: data)
    }

    // MARK: - Computed from Store

    var totalIncome: Double { store.totalIncome }
    var totalExpense: Double { store.totalExpense }
    var totalBalance: Double { store.totalBalance }

    var formattedBalance: String { formatRupiah(totalBalance) }
    var formattedIncome: String { formatRupiah(totalIncome) }
    var formattedExpense: String { formatRupiah(totalExpense) }

    var recentTransactions: [StoredTransaction] { store.recentTransactions }

    // MARK: - Suggestion Banner Data

    var spendingTagline: String { userStore.spendingTagline }

    var suggestionIcon: String {
        if savingsGoalPercent >= 0.5 { return "leaf.fill" }
        if savingsGoalPercent >= 0.2 { return "scale.3d" }
        return "exclamationmark.triangle.fill"
    }

    var hasSuggestion: Bool {
        return totalIncome > 0 || totalExpense > 0
    }

    var suggestionMessage: String {
        if totalIncome == 0 && totalExpense == 0 {
            return "Start tracking your finances by adding your first transaction!"
        }
        if savingsGoalPercent >= 0.5 {
            return "Great job! You're saving \(Int(savingsGoalPercent * 100))% of your income. Keep it up!"
        } else if savingsGoalPercent >= 0.2 {
            return "You're doing okay. Try to reduce some expenses to save more."
        } else if savingsGoalPercent > 0 {
            return "Your expenses are high. Consider reviewing your spending habits."
        } else {
            return "Your expenses exceed your income. Time to cut back on spending!"
        }
    }

    // MARK: - Overview / Donut Chart Data

    /// Predefined category colors
    private let categoryColors: [Color] = [
        Color(hex: "002267"),   // Dark navy
        Color(hex: "014CE6"),   // Primary blue
        Color(hex: "5B8DEF"),   // Light blue
        Color(hex: "A3C4F7"),   // Lighter blue
        Color(hex: "0139AD"),   // Medium blue
        Color(hex: "7AA8F2"),   // Soft blue
    ]

    /// Current month name
    var currentMonthName: String {
        let fmt = DateFormatter()
        fmt.dateFormat = "MMMM"
        return fmt.string(from: Date())
    }

    /// Expense breakdown by category for the current month
    var expenseCategorySlices: [CategorySlice] {
        let calendar = Calendar.current
        let now = Date()
        let monthExpenses = store.transactions.filter {
            $0.type == .expenses &&
            calendar.component(.month, from: $0.date) == calendar.component(.month, from: now) &&
            calendar.component(.year, from: $0.date) == calendar.component(.year, from: now)
        }

        let grouped = Dictionary(grouping: monthExpenses) { $0.category }
        let totalExpenseMonth = monthExpenses.reduce(0.0) { $0 + $1.amount }

        var slices: [CategorySlice] = []
        for (index, (category, transactions)) in grouped.sorted(by: { $0.value.reduce(0) { $0 + $1.amount } > $1.value.reduce(0) { $0 + $1.amount } }).enumerated() {
            let amount = transactions.reduce(0.0) { $0 + $1.amount }
            let pct = totalExpenseMonth > 0 ? amount / totalExpenseMonth : 0
            slices.append(CategorySlice(
                name: category,
                amount: amount,
                color: categoryColors[index % categoryColors.count],
                percentage: pct
            ))
        }
        return slices
    }

    var totalMonthExpense: Double {
        let calendar = Calendar.current
        let now = Date()
        return store.transactions.filter {
            $0.type == .expenses &&
            calendar.component(.month, from: $0.date) == calendar.component(.month, from: now) &&
            calendar.component(.year, from: $0.date) == calendar.component(.year, from: now)
        }.reduce(0.0) { $0 + $1.amount }
    }

    var formattedTotalMonthExpense: String { formatRupiah(totalMonthExpense) }

    // MARK: - Helpers

    private func formatRupiah(_ value: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = "."
        formatter.decimalSeparator = ","
        formatter.maximumFractionDigits = 0
        let formatted = formatter.string(from: NSNumber(value: abs(value))) ?? "0"
        let prefix = value < 0 ? "-" : ""
        return "\(prefix)Rp \(formatted)"
    }
}
