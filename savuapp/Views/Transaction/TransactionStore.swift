// TransactionStore.swift
// savuapp > Views > Transaction

import Foundation
import Combine

@MainActor
final class TransactionStore: ObservableObject {

    // MARK: - Singleton
    static let shared = TransactionStore()

    // MARK: - Published State
    @Published private(set) var transactions: [StoredTransaction] = []

    // MARK: - UserDefaults Key
    private let storageKey = "savu_transactions"

    // MARK: - Init
    init() {
        load()
    }

    // MARK: - Computed Properties

    var totalIncome: Double {
        transactions.filter { $0.type == .income }.reduce(0) { $0 + $1.amount }
    }

    var totalExpense: Double {
        transactions.filter { $0.type == .expenses }.reduce(0) { $0 + $1.amount }
    }

    var totalBalance: Double {
        totalIncome - totalExpense
    }

    /// Recent transactions sorted by date descending, limited to 5
    var recentTransactions: [StoredTransaction] {
        Array(
            transactions
                .sorted { $0.date > $1.date }
                .prefix(5)
        )
    }

    /// Transactions grouped by day, sorted by date descending
    func groupedTransactions(for period: TransactionPeriod) -> [TransactionGroupData] {
        let calendar = Calendar.current
        let now = Date()

        // Filter by period
        let filtered: [StoredTransaction]
        switch period {
        case .daily:
            filtered = transactions.filter { calendar.isDate($0.date, inSameDayAs: now) }
        case .weekly:
            let weekStart = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: now))!
            let weekEnd = calendar.date(byAdding: .day, value: 7, to: weekStart)!
            filtered = transactions.filter { $0.date >= weekStart && $0.date < weekEnd }
        case .monthly:
            filtered = transactions.filter {
                calendar.component(.month, from: $0.date) == calendar.component(.month, from: now) &&
                calendar.component(.year, from: $0.date) == calendar.component(.year, from: now)
            }
        }

        // Group by day
        let grouped = Dictionary(grouping: filtered) { tx in
            calendar.startOfDay(for: tx.date)
        }

        let dayFormatter = DateFormatter()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM yyyy"

        let amountFormatter = NumberFormatter()
        amountFormatter.numberStyle = .decimal
        amountFormatter.groupingSeparator = "."
        amountFormatter.maximumFractionDigits = 0

        return grouped
            .sorted { $0.key > $1.key }
            .map { (dayDate, dayTxs) in
                let dayNum = calendar.component(.day, from: dayDate)
                let isToday = calendar.isDateInToday(dayDate)
                let isYesterday = calendar.isDateInYesterday(dayDate)

                dayFormatter.dateFormat = "EEE"
                let dayLabel = isToday ? "Today" : (isYesterday ? "Yesterday" : dayFormatter.string(from: dayDate))
                let monthYear = dateFormatter.string(from: dayDate)

                let income = dayTxs.filter { $0.type == .income }.reduce(0.0) { $0 + $1.amount }
                let expense = dayTxs.filter { $0.type == .expenses }.reduce(0.0) { $0 + $1.amount }
                let net = income - expense
                let totalStr = "\(net >= 0 ? "+" : "-")Rp\(amountFormatter.string(from: NSNumber(value: abs(net))) ?? "0")"

                let items = dayTxs
                    .sorted { $0.date > $1.date }
                    .map { TransactionItem(from: $0) }

                return TransactionGroupData(
                    date: "\(dayNum)",
                    day: dayLabel,
                    monthYear: monthYear,
                    total: totalStr,
                    items: items
                )
            }
    }

    // MARK: - CRUD

    func add(_ transaction: StoredTransaction) {
        transactions.append(transaction)
        save()
    }

    func delete(_ transaction: StoredTransaction) {
        transactions.removeAll { $0.id == transaction.id }
        save()
    }

    // MARK: - Persistence

    private func save() {
        if let data = try? JSONEncoder().encode(transactions) {
            UserDefaults.standard.set(data, forKey: storageKey)
        }
    }

    private func load() {
        guard let data = UserDefaults.standard.data(forKey: storageKey),
              let decoded = try? JSONDecoder().decode([StoredTransaction].self, from: data) else {
            // Load with sample data on first launch
            loadSampleData()
            return
        }
        transactions = decoded
    }

    private func loadSampleData() {
        let calendar = Calendar.current
        let now = Date()

        transactions = [
            StoredTransaction(title: "Morning Coffee", amount: 45000, category: "Food & Beverage", iconName: "cup.and.saucer.fill", type: .expenses, date: now),
            StoredTransaction(title: "Lunch Set", amount: 120000, category: "Food & Beverage", iconName: "fork.knife", type: .expenses, date: now.addingTimeInterval(-3600 * 2)),
            StoredTransaction(title: "Transport", amount: 35000, category: "Transport", iconName: "car.fill", type: .expenses, date: now.addingTimeInterval(-3600 * 4)),
            StoredTransaction(title: "Salary Bonus", amount: 1500000, category: "Income", iconName: "dollarsign.circle.fill", type: .income, date: calendar.date(byAdding: .day, value: -1, to: now)!)
        ]
        save()
    }
}
