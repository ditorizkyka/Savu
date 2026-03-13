// TransactionViewModel.swift
// savuapp > Views > Transaction

import SwiftUI
import Combine

@MainActor
final class TransactionViewModel: ObservableObject {
    @Published var selectedPeriod: TransactionPeriod = .daily

    @Published var dailyTransactions: [TransactionGroupData] = [
        TransactionGroupData(
            date: "12", day: "Today", monthYear: "March 2026", total: "+Rp100.000",
            items: [
                TransactionItem(title: "Beli seblak ceker mak puan", category: "Food & Beverages", time: "11.32", amount: "-Rp50.000", isExpense: true),
                TransactionItem(title: "Beli bensin etanol bahlil", category: "Transport", time: "12.05", amount: "-Rp50.000", isExpense: true),
                TransactionItem(title: "Bonus Project Savu", category: "Work", time: "14.00", amount: "+Rp200.000", isExpense: false)
            ]
        )
    ]

    @Published var weeklyTransactions: [TransactionGroupData] = [
        TransactionGroupData(
            date: "12", day: "Today", monthYear: "March 2026", total: "+Rp100.000",
            items: [
                TransactionItem(title: "Beli seblak ceker mak puan", category: "Food & Beverages", time: "11.32", amount: "-Rp50.000", isExpense: true),
                TransactionItem(title: "Beli bensin etanol bahlil", category: "Transport", time: "12.05", amount: "-Rp50.000", isExpense: true),
                TransactionItem(title: "Bonus Project Savu", category: "Work", time: "14.00", amount: "+Rp200.000", isExpense: false)
            ]
        ),
        TransactionGroupData(
            date: "11", day: "Wed", monthYear: "March 2026", total: "-Rp70.000",
            items: [
                TransactionItem(title: "Makan Malam", category: "Food", time: "19.00", amount: "-Rp50.000", isExpense: true),
                TransactionItem(title: "Parkir Mall", category: "Transport", time: "20.00", amount: "-Rp20.000", isExpense: true)
            ]
        ),
        TransactionGroupData(
            date: "10", day: "Tue", monthYear: "March 2026", total: "-Rp30.000",
            items: [
                TransactionItem(title: "Kopi Senja", category: "Food", time: "17.00", amount: "-Rp30.000", isExpense: true)
            ]
        )
    ]

    @Published var monthlyTransactions: [TransactionGroupData] = [
        TransactionGroupData(
            date: "12", day: "Today", monthYear: "March 2026", total: "+Rp100.000",
            items: [
                TransactionItem(title: "Beli seblak ceker mak puan", category: "Food & Beverages", time: "11.32", amount: "-Rp50.000", isExpense: true),
                TransactionItem(title: "Beli bensin etanol bahlil", category: "Transport", time: "12.05", amount: "-Rp50.000", isExpense: true),
                TransactionItem(title: "Bonus Project Savu", category: "Work", time: "14.00", amount: "+Rp200.000", isExpense: false)
            ]
        ),
        TransactionGroupData(
            date: "11", day: "Wed", monthYear: "March 2026", total: "-Rp70.000",
            items: [
                TransactionItem(title: "Makan Malam", category: "Food", time: "19.00", amount: "-Rp50.000", isExpense: true),
                TransactionItem(title: "Parkir Mall", category: "Transport", time: "20.00", amount: "-Rp20.000", isExpense: true)
            ]
        ),
        TransactionGroupData(
            date: "10", day: "Tue", monthYear: "March 2026", total: "-Rp30.000",
            items: [
                TransactionItem(title: "Kopi Senja", category: "Food", time: "17.00", amount: "-Rp30.000", isExpense: true)
            ]
        )
    ]

    var currentTransactions: [TransactionGroupData] {
        switch selectedPeriod {
        case .daily:   return dailyTransactions
        case .weekly:  return weeklyTransactions
        case .monthly: return monthlyTransactions
        }
    }

    var dateLabel: String {
        switch selectedPeriod {
        case .daily:   return "March 12, 2026"
        case .weekly:  return "9 - 15 March 2026"
        case .monthly: return "March 2026"
        }
    }
}
