// MARK: - Imports
import SwiftUI

// MARK: - Main View
struct TransactionView: View {
    // MARK: - Properties
    @StateObject private var viewModel = TransactionViewModel()
    
    // MARK: - Body
    var body: some View {
        VStack(spacing: 0) {
            headerSection
            
            ScrollView {
                VStack(spacing: 20) {
                    periodPicker
                    dateNavigation
                    summaryCard
                    transactionListContent
                }
                .padding(20)
            }
        }
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
                PeriodPill(
                    title: period.rawValue,
                    isSelected: viewModel.selectedPeriod == period,
                    onTap: {
                        withAnimation(.spring()) { viewModel.selectedPeriod = period }
                    }
                )
            }
        }
        .padding(4)
        .background(AppTheme.Colors.primary.opacity(0.9))
        .clipShape(RoundedRectangle(cornerRadius: 24))
    }
    
    private var dateNavigation: some View {
        HStack {
            Button(action: {}) { Image(systemName: "chevron.left") as Image }
            Spacer()
            Text(viewModel.dateLabel)
                .font(.system(size: 16, weight: .medium))
            Spacer()
            Button(action: {}) { Image(systemName: "chevron.right") as Image }
        }
        .foregroundStyle(.secondary)
        .padding(.horizontal, 8)
    }
    
    private var summaryCard: some View {
        HStack(spacing: 0) {
            summaryItem(label: "Income", amount: "Rp3.000.000", color: AppTheme.Colors.primary)
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
        VStack(spacing: 16) {
            ForEach(viewModel.currentTransactions) { group in
                DailyTransactionGroup(
                    date: group.date,
                    day: group.day,
                    monthYear: group.monthYear,
                    total: group.total,
                    items: group.items
                )
            }
        }
    }
}

private struct PeriodPill: View {
    let title: String
    let isSelected: Bool
    let onTap: () -> Void

    var body: some View {
        Text(title)
            .font(.subheadline)
            .fontWeight(.semibold)
            .frame(maxWidth: .infinity)
            .frame(height: 40)
            .background(backgroundColor)
            .foregroundStyle(foregroundColor)
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .contentShape(RoundedRectangle(cornerRadius: 20))
            .onTapGesture(perform: onTap)
    }

    private var backgroundColor: Color {
        isSelected ? AppTheme.Colors.primary : .clear
    }

    private var foregroundColor: Color {
        isSelected ? .white : .white.opacity(0.7)
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
                Circle().fill(AppTheme.Colors.primary.opacity(0.1))
                Image(systemName: isExpense ? "fork.knife" : "dollarsign.circle").font(.system(size: 12)).foregroundStyle(AppTheme.Colors.primary)
            }
            .frame(width: 36, height: 36)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title).font(.system(size: 14, weight: .medium)).lineLimit(1)
                HStack(spacing: 8) {
                    Text(category).font(.system(size: 10)).padding(.horizontal, 6).padding(.vertical, 2)
                        .background(AppTheme.Colors.primary.opacity(0.1)).foregroundStyle(AppTheme.Colors.primary).cornerRadius(4)
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
