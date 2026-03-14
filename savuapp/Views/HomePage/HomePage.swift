// HomeView.swift
// savuapp > Views > HomePage

import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel()
    @State private var showAddTransaction = false

    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            ScrollView {
                VStack(spacing: 20) {
                    headerSection
                    balanceCard
                    incomeExpenseRow
                    savingsProgressSection
                    recentTransactionsSection
                }
                .padding(.horizontal, 20)
                .padding(.top, 12)
                .padding(.bottom, 120)
            }
            .background(Color(.systemGroupedBackground))

            // MARK: - Floating Action Button
            Button(action: { showAddTransaction = true }) {
                ZStack {
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [AppTheme.Colors.primary, AppTheme.Colors.primary.opacity(0.8)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 60, height: 60)
                        .shadow(color: AppTheme.Colors.primary.opacity(0.4), radius: 12, x: 0, y: 6)

                    Image(systemName: "plus")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(.white)
                }
            }
            .padding(.trailing, 24)
            .padding(.bottom, 90)
        }
        .navigationBarHidden(true)
        .navigationDestination(isPresented: $showAddTransaction) {
            AddTransactionView(store: viewModel.store)
        }
    }

    // MARK: - Header
    private var headerSection: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("Good \(greetingTime),")
                    .font(AppTheme.Typography.subheadline)
                    .foregroundColor(AppTheme.Colors.textSecondary)
                Text(viewModel.userName)
                    .font(AppTheme.Typography.title2)
                    .foregroundColor(AppTheme.Colors.textPrimary)
            }
            Spacer()
            ZStack {
                Circle()
                    .fill(AppTheme.Colors.light)
                    .frame(width: 44, height: 44)
                Image(systemName: "bell")
                    .font(.system(size: 18))
                    .foregroundColor(AppTheme.Colors.primary)
            }
        }
        .padding(.top, 8)
    }

    // MARK: - Balance Card
    private var balanceCard: some View {
        VStack(spacing: 8) {
            Text("Total Balance")
                .font(AppTheme.Typography.caption)
                .foregroundColor(.white.opacity(0.8))
            Text(viewModel.formattedBalance)
                .font(.system(size: 32, weight: .bold))
                .foregroundColor(.white)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 28)
        .background(
            LinearGradient(
                stops: [
                    Gradient.Stop(color: Color(red: 0, green: 0.22, blue: 0.68), location: 0.00),
                    Gradient.Stop(color: Color(red: 0, green: 0.3, blue: 0.9), location: 0.82),
                    Gradient.Stop(color: Color(red: 0.1, green: 0.4, blue: 1.0), location: 1.00),
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .cornerRadius(AppTheme.Radius.lg)
        .shadow(color: AppTheme.Colors.primary.opacity(0.25), radius: 12, x: 0, y: 6)
    }

    // MARK: - Income / Expense Row
    private var incomeExpenseRow: some View {
        HStack(spacing: 12) {
            summaryTile(
                icon: "arrow.down.circle.fill",
                label: "Income",
                amount: viewModel.formattedIncome,
                color: Color.green,
                bgColor: Color.green.opacity(0.1)
            )
            summaryTile(
                icon: "arrow.up.circle.fill",
                label: "Expense",
                amount: viewModel.formattedExpense,
                color: Color.red,
                bgColor: Color.red.opacity(0.1)
            )
        }
    }

    private func summaryTile(icon: String, label: String, amount: String, color: Color, bgColor: Color) -> some View {
        HStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(bgColor)
                    .frame(width: 40, height: 40)
                Image(systemName: icon)
                    .font(.system(size: 18))
                    .foregroundColor(color)
            }
            VStack(alignment: .leading, spacing: 2) {
                Text(label)
                    .font(AppTheme.Typography.caption)
                    .foregroundColor(AppTheme.Colors.textSecondary)
                Text(amount)
                    .font(.system(size: 15, weight: .bold))
                    .foregroundColor(AppTheme.Colors.textPrimary)
            }
            Spacer()
        }
        .padding(14)
        .background(Color.white)
        .cornerRadius(AppTheme.Radius.card)
        .shadow(color: .black.opacity(0.04), radius: 6, x: 0, y: 2)
    }

    // MARK: - Savings Progress
    private var savingsProgressSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Savings Goal")
                    .font(AppTheme.Typography.headline)
                    .foregroundColor(AppTheme.Colors.textPrimary)
                Spacer()
                Text("\(Int(viewModel.savingsGoalPercent * 100))%")
                    .font(AppTheme.Typography.bodyMedium)
                    .foregroundColor(AppTheme.Colors.primary)
                    .fontWeight(.bold)
            }

            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 6)
                        .fill(AppTheme.Colors.light)
                        .frame(height: 10)
                    RoundedRectangle(cornerRadius: 6)
                        .fill(
                            LinearGradient(
                                colors: [AppTheme.Colors.primary, AppTheme.Colors.primary.opacity(0.7)],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .frame(width: geo.size.width * viewModel.savingsGoalPercent, height: 10)
                }
            }
            .frame(height: 10)
        }
        .padding(16)
        .background(Color.white)
        .cornerRadius(AppTheme.Radius.card)
        .shadow(color: .black.opacity(0.04), radius: 6, x: 0, y: 2)
    }

    // MARK: - Recent Transactions
    private var recentTransactionsSection: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack {
                Text("Recent Transactions")
                    .font(AppTheme.Typography.headline)
                    .foregroundColor(AppTheme.Colors.textPrimary)
                Spacer()
                Text("See all")
                    .font(AppTheme.Typography.caption)
                    .foregroundColor(AppTheme.Colors.primary)
            }

            if viewModel.recentTransactions.isEmpty {
                VStack(spacing: 8) {
                    Image(systemName: "tray")
                        .font(.system(size: 32))
                        .foregroundColor(AppTheme.Colors.textSecondary)
                    Text("No transactions yet")
                        .font(AppTheme.Typography.caption)
                        .foregroundColor(AppTheme.Colors.textSecondary)
                    Text("Tap + to add your first transaction")
                        .font(AppTheme.Typography.small)
                        .foregroundColor(AppTheme.Colors.textDisabled)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 24)
            } else {
                VStack(spacing: 0) {
                    ForEach(viewModel.recentTransactions) { item in
                        HStack(spacing: 12) {
                            ZStack {
                                Circle()
                                    .fill(item.isExpense ? Color.red.opacity(0.1) : Color.green.opacity(0.1))
                                    .frame(width: 40, height: 40)
                                Image(systemName: item.iconName)
                                    .font(.system(size: 16))
                                    .foregroundColor(item.isExpense ? .red : .green)
                            }

                            VStack(alignment: .leading, spacing: 3) {
                                Text(item.title)
                                    .font(.system(size: 14, weight: .medium))
                                    .lineLimit(1)
                                HStack(spacing: 6) {
                                    Text(item.category)
                                        .font(.system(size: 11))
                                        .padding(.horizontal, 6)
                                        .padding(.vertical, 2)
                                        .background(AppTheme.Colors.light)
                                        .foregroundColor(AppTheme.Colors.primary)
                                        .cornerRadius(4)
                                    Text(item.formattedTime)
                                        .font(.system(size: 11))
                                        .foregroundColor(AppTheme.Colors.textSecondary)
                                }
                            }

                            Spacer()

                            Text(item.formattedAmount)
                                .font(.system(size: 14, weight: .bold))
                                .foregroundColor(item.isExpense ? .red : .green)
                        }
                        .padding(.vertical, 12)

                        if item.id != viewModel.recentTransactions.last?.id {
                            Divider()
                        }
                    }
                }
            }
        }
        .padding(16)
        .background(Color.white)
        .cornerRadius(AppTheme.Radius.card)
        .shadow(color: .black.opacity(0.04), radius: 6, x: 0, y: 2)
    }

    // MARK: - Greeting Helper
    private var greetingTime: String {
        let hour = Calendar.current.component(.hour, from: Date())
        switch hour {
        case 5..<12: return "Morning"
        case 12..<17: return "Afternoon"
        case 17..<21: return "Evening"
        default: return "Night"
        }
    }
}

#Preview {
    NavigationStack {
        HomeView()
    }
}
