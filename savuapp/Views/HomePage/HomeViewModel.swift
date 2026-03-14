// HomeViewModel.swift
// savuapp > Views > HomePage

import SwiftUI
import Combine

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

    // MARK: - Computed from Store

    var totalIncome: Double { store.totalIncome }
    var totalExpense: Double { store.totalExpense }
    var totalBalance: Double { store.totalBalance }

    var formattedBalance: String { formatRupiah(totalBalance) }
    var formattedIncome: String { formatRupiah(totalIncome) }
    var formattedExpense: String { formatRupiah(totalExpense) }

    var recentTransactions: [StoredTransaction] { store.recentTransactions }

    // MARK: - Helpers

    private func formatRupiah(_ value: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = "."
        formatter.decimalSeparator = ","
        formatter.maximumFractionDigits = 0
        let formatted = formatter.string(from: NSNumber(value: abs(value))) ?? "0"
        return "Rp\(formatted)"
    }
}
