// HomeViewModel.swift
// savuapp > Views > HomePage

import SwiftUI
import Combine

@MainActor
final class HomeViewModel: ObservableObject {
    @Published var userName: String = "Dema"
    @Published var totalBalance: Double = 2_500_000
    @Published var totalIncome: Double = 3_000_000
    @Published var totalExpense: Double = 500_000
    @Published var savingsGoalPercent: Double = 0.65

    @Published var recentTransactions: [HomeTransaction] = [
        HomeTransaction(title: "Beli seblak ceker", category: "Food & Beverages", amount: -50_000, date: "Today, 11:32", iconName: "fork.knife"),
        HomeTransaction(title: "Beli bensin", category: "Transport", amount: -50_000, date: "Today, 12:05", iconName: "car.fill"),
        HomeTransaction(title: "Bonus Project Savu", category: "Work", amount: 200_000, date: "Today, 14:00", iconName: "dollarsign.circle"),
    ]

    var formattedBalance: String {
        formatRupiah(totalBalance)
    }

    var formattedIncome: String {
        formatRupiah(totalIncome)
    }

    var formattedExpense: String {
        formatRupiah(totalExpense)
    }

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

// MARK: - HomeTransaction Model
struct HomeTransaction: Identifiable {
    let id = UUID()
    let title: String
    let category: String
    let amount: Double
    let date: String
    let iconName: String

    var isExpense: Bool { amount < 0 }

    var formattedAmount: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = "."
        formatter.maximumFractionDigits = 0
        let formatted = formatter.string(from: NSNumber(value: abs(amount))) ?? "0"
        return "\(amount < 0 ? "-" : "+")Rp\(formatted)"
    }
}
