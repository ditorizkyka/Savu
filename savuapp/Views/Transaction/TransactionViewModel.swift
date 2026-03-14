// TransactionViewModel.swift
// savuapp > Views > Transaction

import SwiftUI
import Combine

@MainActor
final class TransactionViewModel: ObservableObject {
    @Published var selectedPeriod: TransactionPeriod = .daily

    private var cancellables = Set<AnyCancellable>()
    let store: TransactionStore

    // MARK: - Init
    init(store: TransactionStore = .shared) {
        self.store = store

        // Re-publish when store changes
        store.objectWillChange
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in self?.objectWillChange.send() }
            .store(in: &cancellables)
    }

    // MARK: - Computed from Store

    var currentTransactions: [TransactionGroupData] {
        store.groupedTransactions(for: selectedPeriod)
    }

    var dateLabel: String {
        let now = Date()
        let formatter = DateFormatter()
        switch selectedPeriod {
        case .daily:
            formatter.dateFormat = "MMMM d, yyyy"
            return formatter.string(from: now)
        case .weekly:
            let calendar = Calendar.current
            let weekStart = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: now))!
            let weekEnd = calendar.date(byAdding: .day, value: 6, to: weekStart)!
            let dayFmt = DateFormatter()
            dayFmt.dateFormat = "d"
            let monthFmt = DateFormatter()
            monthFmt.dateFormat = "MMMM yyyy"
            return "\(dayFmt.string(from: weekStart)) - \(dayFmt.string(from: weekEnd)) \(monthFmt.string(from: now))"
        case .monthly:
            formatter.dateFormat = "MMMM yyyy"
            return formatter.string(from: now)
        }
    }

    // Period-filtered totals
    var totalIncome: Double { store.filteredIncome(for: selectedPeriod) }
    var totalExpense: Double { store.filteredExpense(for: selectedPeriod) }
    var totalBalance: Double { totalIncome - totalExpense }

    var formattedIncome: String { formatRupiah(totalIncome) }
    var formattedExpense: String { formatRupiah(totalExpense) }
    var formattedTotal: String {
        let net = totalBalance
        return "\(net >= 0 ? "+" : "-")Rp\(formatNumber(abs(net)))"
    }

    private func formatRupiah(_ value: Double) -> String {
        "Rp\(formatNumber(value))"
    }

    private func formatNumber(_ value: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = "."
        formatter.maximumFractionDigits = 0
        return formatter.string(from: NSNumber(value: value)) ?? "0"
    }
}

