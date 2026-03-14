// TransactionModels.swift
// savuapp > Views > Transaction

import Foundation

// MARK: - TransactionPeriod
enum TransactionPeriod: String, CaseIterable {
    case daily = "Daily"
    case weekly = "Weekly"
    case monthly = "Monthly"
}

// MARK: - TransactionType
enum TransactionType: String, CaseIterable, Codable {
    case income = "Income"
    case expenses = "Expenses"
}

// MARK: - StoredTransaction (Codable — persisted to UserDefaults)
struct StoredTransaction: Identifiable, Codable {
    let id: UUID
    let title: String
    let amount: Double
    let category: String
    let iconName: String
    let type: TransactionType
    let date: Date

    init(
        id: UUID = UUID(),
        title: String,
        amount: Double,
        category: String,
        iconName: String,
        type: TransactionType,
        date: Date = Date()
    ) {
        self.id = id
        self.title = title
        self.amount = amount
        self.category = category
        self.iconName = iconName
        self.type = type
        self.date = date
    }

    var isExpense: Bool { type == .expenses }

    var formattedAmount: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = "."
        formatter.maximumFractionDigits = 0
        let formatted = formatter.string(from: NSNumber(value: amount)) ?? "0"
        return "\(isExpense ? "-" : "+")Rp\(formatted)"
    }

    var formattedTime: String {
        let fmt = DateFormatter()
        fmt.dateFormat = "HH.mm"
        return fmt.string(from: date)
    }
}

// MARK: - TransactionItem (display model for grouped lists)
struct TransactionItem: Identifiable {
    let id: UUID
    let title: String
    let category: String
    let iconName: String
    let time: String
    let amount: String
    let isExpense: Bool

    init(id: UUID = UUID(), title: String, category: String, iconName: String = "questionmark.circle", time: String, amount: String, isExpense: Bool) {
        self.id = id
        self.title = title
        self.category = category
        self.iconName = iconName
        self.time = time
        self.amount = amount
        self.isExpense = isExpense
    }

    /// Convenience init from StoredTransaction
    init(from stored: StoredTransaction) {
        self.id = stored.id
        self.title = stored.title
        self.category = stored.category
        self.iconName = stored.iconName
        self.time = stored.formattedTime
        self.amount = stored.formattedAmount
        self.isExpense = stored.isExpense
    }
}

// MARK: - TransactionGroupData (grouped by day for list display)
struct TransactionGroupData: Identifiable {
    let id = UUID()
    let date: String
    let day: String
    let monthYear: String
    let total: String
    let items: [TransactionItem]
}
