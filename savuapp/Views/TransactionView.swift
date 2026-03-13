// MARK: - Imports
import SwiftUI

// MARK: - Supporting Types
enum TransactionPeriod: String, CaseIterable {
    case daily = "Daily"
    case weekly = "Weekly"
    case monthly = "Monthly"
}

struct TransactionItem: Identifiable {
    let id = UUID()
    let title: String
    let category: String
    let time: String
    let amount: String
    let isExpense: Bool
}

// MARK: - Main View
struct TransactionView: View {
    // MARK: - Properties
    @State private var selectedPeriod: TransactionPeriod = .daily
    
    // MARK: - Body
    var body: some View {
        VStack(spacing: 0) {
            headerSection
            
            ScrollView {
                VStack(spacing: 20) {
                    periodPicker
                    dateNavigation
                    summaryCard
                    
                    // Detail list berdasarkan tab yang dipilih
                    transactionListContent
                }
                .padding(20)
            }
            
            customTabBar
        }
        .edgesIgnoringSafeArea(.bottom)
    }
}

// MARK: - Private Methods (Subviews)
extension TransactionView {
    
    private var headerSection: some View {
        Text("Transaction")
            .font(.system(size: 20, weight: .bold))
            .padding(.vertical, 16)
    }
    
    private var periodPicker: some View {
        HStack(spacing: 0) {
            ForEach(TransactionPeriod.allCases, id: \.self) { period in
                Text(period.rawValue)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity)
                    .frame(height: 40)
                    .background(selectedPeriod == period ? Color.blue : Color.clear)
                    .foregroundStyle(selectedPeriod == period ? .white : .white.opacity(0.7))
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .onTapGesture {
                        withAnimation(.spring()) { selectedPeriod = period }
                    }
            }
        }
        .padding(4)
        .background(Color.blue.opacity(0.9))
        .clipShape(RoundedRectangle(cornerRadius: 24))
    }
    
    private var dateNavigation: some View {
        HStack {
            Button(action: {}) { Image(systemName: "chevron.left") }
            Spacer()
            Text(selectedPeriod == .daily ? "March 12, 2026" :
                 selectedPeriod == .weekly ? "9 - 15 March 2026" : "March 2026")
                .font(.system(size: 16, weight: .medium))
            Spacer()
            Button(action: {}) { Image(systemName: "chevron.right") }
        }
        .foregroundStyle(.secondary)
        .padding(.horizontal, 8)
    }
    
    private var summaryCard: some View {
        HStack(spacing: 0) {
            summaryItem(label: "Income", amount: "Rp3.000.000", color: .blue)
            Divider().frame(height: 30).padding(.horizontal, 10)
            summaryItem(label: "Expense", amount: "Rp500.000", color: .red)
            Divider().frame(height: 30).padding(.horizontal, 10)
            summaryItem(label: "Total", amount: "+Rp2.500.000", color: .green)
        }
        .padding(.vertical, 10)
    }
    
    private func summaryItem(label: String, amount: String, color: Color) -> some View {
        VStack(spacing: 4) {
            Text(label).font(.caption).foregroundStyle(.secondary)
            Text(amount).font(.system(size: 14, weight: .bold)).foregroundStyle(color)
        }
        .frame(maxWidth: .infinity)
    }
    
    @ViewBuilder
    private var transactionListContent: some View {
        switch selectedPeriod {
        case .daily:
            VStack(spacing: 16) {
                DailyTransactionGroup(
                    date: "12", day: "Today", monthYear: "March 2026", total: "+Rp100.000",
                    items: [
                        TransactionItem(title: "Beli seblak ceker mak puan", category: "Food & Beverages", time: "11.32", amount: "-Rp50.000", isExpense: true),
                        TransactionItem(title: "Beli bensin etanol bahlil", category: "Transport", time: "12.05", amount: "-Rp50.000", isExpense: true),
                        TransactionItem(title: "Bonus Project Savu", category: "Work", time: "14.00", amount: "+Rp200.000", isExpense: false)
                    ]
                )
            }
        case .weekly:
            VStack(spacing: 16) {
                DailyTransactionGroup(
                    date: "12", day: "Today", monthYear: "March 2026", total: "+Rp100.000",
                    items: [
                        TransactionItem(title: "Beli seblak ceker mak puan", category: "Food & Beverages", time: "11.32", amount: "-Rp50.000", isExpense: true),
                        TransactionItem(title: "Beli bensin etanol bahlil", category: "Transport", time: "12.05", amount: "-Rp50.000", isExpense: true),
                        TransactionItem(title: "Bonus Project Savu", category: "Work", time: "14.00", amount: "+Rp200.000", isExpense: false)
                    ]
                )
                DailyTransactionGroup(
                    date: "11", day: "Wed", monthYear: "March 2026", total: "-Rp70.000",
                    items: [
                        TransactionItem(title: "Makan Malam", category: "Food", time: "19.00", amount: "-Rp50.000", isExpense: true),
                        TransactionItem(title: "Parkir Mall", category: "Transport", time: "20.00", amount: "-Rp20.000", isExpense: true)
                    ]
                )
                DailyTransactionGroup(
                    date: "10", day: "Tue", monthYear: "March 2026", total: "-Rp30.000",
                    items: [
                        TransactionItem(title: "Kopi Senja", category: "Food", time: "17.00", amount: "-Rp30.000", isExpense: true)
                    ]
                )
            }
        case .monthly:
            VStack(spacing: 16) {
                DailyTransactionGroup(
                    date: "12", day: "Today", monthYear: "March 2026", total: "+Rp100.000",
                    items: [
                        TransactionItem(title: "Beli seblak ceker mak puan", category: "Food & Beverages", time: "11.32", amount: "-Rp50.000", isExpense: true),
                        TransactionItem(title: "Beli bensin etanol bahlil", category: "Transport", time: "12.05", amount: "-Rp50.000", isExpense: true),
                        TransactionItem(title: "Bonus Project Savu", category: "Work", time: "14.00", amount: "+Rp200.000", isExpense: false)
                    ]
                )
                DailyTransactionGroup(
                    date: "11", day: "Wed", monthYear: "March 2026", total: "-Rp70.000",
                    items: [
                        TransactionItem(title: "Makan Malam", category: "Food", time: "19.00", amount: "-Rp50.000", isExpense: true),
                        TransactionItem(title: "Parkir Mall", category: "Transport", time: "20.00", amount: "-Rp20.000", isExpense: true)
                    ]
                )
                DailyTransactionGroup(
                    date: "10", day: "Tue", monthYear: "March 2026", total: "-Rp30.000",
                    items: [
                        TransactionItem(title: "Kopi Senja", category: "Food", time: "17.00", amount: "-Rp30.000", isExpense: true)
                    ]
                )
            }
        }
    }
    
    private var customTabBar: some View {
        HStack {
            tabItem(icon: "house", label: "Home", isActive: false)
            tabItem(icon: "wallet.pass", label: "Transaction", isActive: true)
            tabItem(icon: "person", label: "Profile", isActive: false)
        }
        .padding(.top, 12)
        .padding(.bottom, 34)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 30))
        .shadow(color: .black.opacity(0.05), radius: 10, y: -5)
    }
    
    private func tabItem(icon: String, label: String, isActive: Bool) -> some View {
        VStack(spacing: 4) {
            Image(systemName: isActive ? "\(icon).fill" : icon).font(.system(size: 20))
            Text(label).font(.caption2)
        }
        .frame(maxWidth: .infinity)
        .foregroundStyle(isActive ? .blue : .gray)
    }
}

// MARK: - Supporting Components
struct DailyTransactionGroup: View {
    let date: String
    let day: String
    let monthYear: String
    let total: String
    let items: [TransactionItem]
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(alignment: .top, spacing: 12) {
                Text(date).font(.system(size: 32, weight: .medium))
                VStack(alignment: .leading, spacing: 2) {
                    if !day.isEmpty { Text(day).font(.caption).foregroundStyle(.secondary) }
                    Text(monthYear).font(.subheadline).foregroundStyle(.secondary)
                }
                Spacer()
                Text(total).font(.system(size: 16, weight: .bold))
                    .foregroundStyle(total.contains("+") ? .green : .red)
            }
            .padding()
            .background(Color(uiColor: .systemGray6).opacity(0.5))
            
            VStack(spacing: 0) {
                ForEach(items) { item in
                    TransactionRow(title: item.title, category: item.category, time: item.time, amount: item.amount, isExpense: item.isExpense)
                }
            }
        }
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.gray.opacity(0.1), lineWidth: 1))
    }
}

struct TransactionRow: View {
    let title: String
    let category: String
    let time: String
    let amount: String
    let isExpense: Bool
    
    var body: some View {
        HStack(spacing: 12) {
            ZStack {
                Circle().fill(Color.blue.opacity(0.1))
                Image(systemName: isExpense ? "fork.knife" : "dollarsign.circle").font(.system(size: 12)).foregroundStyle(.blue)
            }
            .frame(width: 36, height: 36)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title).font(.system(size: 14, weight: .medium)).lineLimit(1)
                HStack(spacing: 8) {
                    Text(category).font(.system(size: 10)).padding(.horizontal, 6).padding(.vertical, 2)
                        .background(Color.blue.opacity(0.1)).foregroundStyle(.blue).cornerRadius(4)
                    Label(time, systemImage: "clock").font(.system(size: 10)).foregroundStyle(.secondary)
                }
            }
            Spacer()
            Text(amount).font(.system(size: 14, weight: .bold)).foregroundStyle(isExpense ? .red : .green)
        }
        .padding(.horizontal)
        .padding(.vertical, 12)
        Divider().padding(.leading, 60)
    }
}

// MARK: - Preview
#Preview {
    TransactionView()
}
