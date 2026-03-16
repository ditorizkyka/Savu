// TransactionViewModel.swift
// savuapp > Views > Transaction

import SwiftUI
import Combine

@MainActor
final class TransactionViewModel: ObservableObject {
    @Published var selectedPeriod: TransactionPeriod = .daily {
        didSet {
            // Reset to today when switching periods
            currentDate = Date()
        }
    }
    
    @Published var currentDate: Date = Date()

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
    
    // MARK: - Navigation
    func moveDate(by step: Int) {
        let calendar = Calendar.current
        switch selectedPeriod {
        case .daily:
            currentDate = calendar.date(byAdding: .day, value: step, to: currentDate) ?? currentDate
        case .weekly:
            currentDate = calendar.date(byAdding: .weekOfYear, value: step, to: currentDate) ?? currentDate
        case .monthly:
            currentDate = calendar.date(byAdding: .month, value: step, to: currentDate) ?? currentDate
        }
    }

    // MARK: - Computed from Store

    var currentTransactions: [TransactionGroupData] {
        store.groupedTransactions(for: selectedPeriod, referenceDate: currentDate)
    }

    var dateLabel: String {
        let formatter = DateFormatter()
        switch selectedPeriod {
        case .daily:
            formatter.dateFormat = "MMMM d, yyyy"
            return formatter.string(from: currentDate)
        case .weekly:
            let calendar = Calendar.current
            let weekStart = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: currentDate))!
            let weekEnd = calendar.date(byAdding: .day, value: 6, to: weekStart)!
            let dayFmt = DateFormatter()
            dayFmt.dateFormat = "d"
            let monthFmt = DateFormatter()
            monthFmt.dateFormat = "MMMM yyyy"
            return "\(dayFmt.string(from: weekStart)) - \(dayFmt.string(from: weekEnd)) \(monthFmt.string(from: currentDate))"
        case .monthly:
            formatter.dateFormat = "MMMM yyyy"
            return formatter.string(from: currentDate)
        }
    }

    // Period-filtered totals
    var totalIncome: Double { store.filteredIncome(for: selectedPeriod, referenceDate: currentDate) }
    var totalExpense: Double { store.filteredExpense(for: selectedPeriod, referenceDate: currentDate) }
    var totalBalance: Double { totalIncome - totalExpense }

    var formattedIncome: String { CurrencyFormatter.format(totalIncome) }
    var formattedExpense: String { CurrencyFormatter.format(totalExpense) }
    var formattedTotal: String { CurrencyFormatter.formatSigned(totalBalance) }
}

