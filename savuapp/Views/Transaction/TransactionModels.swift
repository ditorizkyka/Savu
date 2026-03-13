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
enum TransactionType: String, CaseIterable {
    case income = "Income"
    case expenses = "Expenses"
}

// MARK: - TransactionItem
struct TransactionItem: Identifiable {
    let id = UUID()
    let title: String
    let category: String
    let time: String
    let amount: String
    let isExpense: Bool
}

// MARK: - TransactionGroupData
struct TransactionGroupData: Identifiable {
    let id = UUID()
    let date: String
    let day: String
    let monthYear: String
    let total: String
    let items: [TransactionItem]
}
