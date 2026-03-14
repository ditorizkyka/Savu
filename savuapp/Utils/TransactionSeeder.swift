//
//  TransactionSeeder.swift
//  savuapp
//

import Foundation

@MainActor
struct TransactionSeeder {
    static func seedData(into store: TransactionStore) {
        let calendar = Calendar.current
        let today = Date()
        
        let sampleTransactions: [StoredTransaction] = [
            StoredTransaction(title: "Morning Coffee", amount: 45000, category: "Food & Beverage", iconName: "cup.and.saucer.fill", type: .expenses, date: today.addingTimeInterval(-3600 * 8)),
            StoredTransaction(title: "Lunch Set", amount: 120000, category: "Food & Beverage", iconName: "fork.knife", type: .expenses, date: today.addingTimeInterval(-3600 * 4)),
            StoredTransaction(title: "Transport", amount: 35000, category: "Transport", iconName: "car.fill", type: .expenses, date: today.addingTimeInterval(-3600 * 2)),
            StoredTransaction(title: "Movie Tickets", amount: 150000, category: "Entertainment", iconName: "film", type: .expenses, date: today.addingTimeInterval(-3600)),
            
            // Yesterday
            StoredTransaction(title: "Groceries", amount: 500000, category: "Shopping", iconName: "cart.fill", type: .expenses, date: calendar.date(byAdding: .day, value: -1, to: today)!),
            
            // Two days ago income
            StoredTransaction(title: "Salary Bonus", amount: 2500000, category: "Income", iconName: "dollarsign.circle.fill", type: .income, date: calendar.date(byAdding: .day, value: -2, to: today)!)
        ]
        
        for tx in sampleTransactions {
            store.add(tx)
        }
        
        print("✅ Seeded \(sampleTransactions.count) transactions to TransactionStore")
    }
}
