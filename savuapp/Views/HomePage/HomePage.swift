// HomeView.swift
// savuapp > Views > HomePage

import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel()
    @State private var showAddTransaction = false

    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            ScrollView {
                VStack(spacing: 0) {
                    // Dark navy header area
                    headerAndBalanceSection

                    // Content below header
                    VStack(spacing: 20) {
                        suggestionSection
                        overviewSection
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                    .padding(.bottom, 120)
                }
            }
            .background(Color(.systemGroupedBackground))
            .ignoresSafeArea(edges: .top)

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
        .onAppear {
            // Reinforce glass tab bar appearance
            let appearance = UITabBarAppearance()
            appearance.configureWithTransparentBackground()
            appearance.backgroundEffect = UIBlurEffect(style: .systemUltraThinMaterial)
            appearance.backgroundColor = UIColor.systemBackground.withAlphaComponent(0.3)
            UITabBar.appearance().standardAppearance = appearance
            UITabBar.appearance().scrollEdgeAppearance = appearance
        }
    }

    // MARK: - Header + Balance (Dark Navy Section)
    private var headerAndBalanceSection: some View {
        VStack(spacing: 16) {
            Spacer().frame(height: 54) // status bar space

            // Greeting row
            HStack(spacing: 12) {
                // Avatar
                ZStack {
                    Circle()
                        .fill(Color.white.opacity(0.2))
                        .frame(width: 44, height: 44)
                    if let img = viewModel.profileImage {
                        Image(uiImage: img)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 40, height: 40)
                            .clipShape(Circle())
                    } else {
                        Image(systemName: "person.crop.circle.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 40, height: 40)
                            .foregroundColor(.white.opacity(0.8))
                    }
                }

                VStack(alignment: .leading, spacing: 2) {
                    Text("Good \(greetingTime), \(viewModel.userName)")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.white)
                    Text("You Are The \(viewModel.spendingTagline)")
                        .font(.system(size: 13))
                        .foregroundColor(.white.opacity(0.7))
                }
                Spacer()
            }
            .padding(.horizontal, 20)

            // Balance Card
            VStack(alignment: .leading, spacing: 8) {
                Text("Total Balance")
                    .font(.system(size: 13))
                    .foregroundColor(.white.opacity(0.8))
                Text(viewModel.formattedBalance)
                    .font(.system(size: 32, weight: .bold))
                    .foregroundColor(.white)

                // Income / Expense row - left aligned
                HStack(spacing: 24) {
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Income")
                            .font(.system(size: 12))
                            .foregroundColor(.white.opacity(0.7))
                        Text(viewModel.formattedIncome)
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(.white)
                    }
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Expense")
                            .font(.system(size: 12))
                            .foregroundColor(.white.opacity(0.7))
                        Text(viewModel.formattedExpense)
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(.white)
                    }
                }
                .padding(.top, 4)
            }
            .padding(.vertical, 20)
            .padding(.horizontal, 20)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(
                        LinearGradient(
                            stops: [
                                Gradient.Stop(color: Color(red: 0, green: 0.28, blue: 0.85), location: 0.0),
                                Gradient.Stop(color: Color(red: 0.05, green: 0.35, blue: 0.95), location: 1.0),
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
            )
            .padding(.horizontal, 20)
            .padding(.bottom, 20)
        }
        .background(
            Color(hex: "001B51")
                .ignoresSafeArea(edges: .top)
        )
    }

    // MARK: - Our Suggestion Section
    private var suggestionSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Our Suggestion")
                .font(.system(size: 17, weight: .bold))
                .foregroundColor(AppTheme.Colors.textPrimary)

            // Suggestion Card with blue-to-gold gradient matching mockup
            ZStack(alignment: .bottomTrailing) {
                // Gradient background
                LinearGradient(
                    stops: [
                        Gradient.Stop(color: Color(red: 0.12, green: 0.15, blue: 0.25), location: 0.0),
                        Gradient.Stop(color: Color(red: 0.15, green: 0.25, blue: 0.5), location: 0.3),
                        Gradient.Stop(color: Color(red: 0.6, green: 0.5, blue: 0.15), location: 0.85),
                        Gradient.Stop(color: Color(red: 0.75, green: 0.6, blue: 0.1), location: 1.0),
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )

                // Decorative checkmark circle
                ZStack {
                    Circle()
                        .fill(Color.white.opacity(0.08))
                        .frame(width: 80, height: 80)
                    Image(systemName: "checkmark")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(.white.opacity(0.15))
                }
                .offset(x: -10, y: -10)

                // Text content
                VStack(alignment: .leading, spacing: 6) {
                    Text(viewModel.hasSuggestion
                         ? "Your Daily Suggestion is Ready!"
                         : "Your Daily Suggestion Is Being Prepared")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.white)
                        .lineLimit(2)
                    Text(viewModel.hasSuggestion
                         ? "Tap to see"
                         : "Click to add new transaction")
                        .font(.system(size: 13))
                        .foregroundColor(.white.opacity(0.7))
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomLeading)
                .padding(18)
            }
            .frame(height: 140)
            .cornerRadius(16)
        }
    }

    // MARK: - Overview Section
    private var overviewSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Overview")
                .font(.system(size: 17, weight: .bold))
                .foregroundColor(AppTheme.Colors.textPrimary)

            VStack(spacing: 16) {
                // Month picker
                HStack {
                    Spacer()
                    HStack(spacing: 6) {
                        Text(viewModel.currentMonthName)
                            .font(.system(size: 14))
                            .foregroundColor(AppTheme.Colors.textPrimary)
                        Image(systemName: "chevron.down")
                            .font(.system(size: 11))
                            .foregroundColor(AppTheme.Colors.textSecondary)
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(AppTheme.Colors.divider, lineWidth: 1)
                    )
                    Spacer()
                }

                // Donut Chart
                if viewModel.expenseCategorySlices.isEmpty {
                    VStack(spacing: 8) {
                        ZStack {
                            Circle()
                                .stroke(AppTheme.Colors.light, lineWidth: 20)
                                .frame(width: 160, height: 160)
                            VStack(spacing: 2) {
                                Text("No Data")
                                    .font(.system(size: 13))
                                    .foregroundColor(AppTheme.Colors.textSecondary)
                                Text("Rp 0")
                                    .font(.system(size: 18, weight: .bold))
                                    .foregroundColor(AppTheme.Colors.textPrimary)
                            }
                        }
                        .frame(height: 200)
                    }
                } else {
                    ZStack {
                        DonutChart(slices: viewModel.expenseCategorySlices)
                            .frame(width: 180, height: 180)
                        VStack(spacing: 2) {
                            if let top = viewModel.expenseCategorySlices.first {
                                Text(top.name)
                                    .font(.system(size: 12))
                                    .foregroundColor(AppTheme.Colors.textSecondary)
                            }
                            Text(viewModel.formattedTotalMonthExpense)
                                .font(.system(size: 17, weight: .bold))
                                .foregroundColor(AppTheme.Colors.textPrimary)
                        }
                    }
                    .frame(height: 200)

                    // Legend
                    VStack(spacing: 8) {
                        ForEach(viewModel.expenseCategorySlices) { slice in
                            HStack(spacing: 8) {
                                Circle()
                                    .fill(slice.color)
                                    .frame(width: 10, height: 10)
                                Text(slice.name)
                                    .font(.system(size: 13))
                                    .foregroundColor(AppTheme.Colors.textPrimary)
                                Spacer()
                                Text("\(Int(slice.percentage * 100))%")
                                    .font(.system(size: 13, weight: .medium))
                                    .foregroundColor(AppTheme.Colors.textSecondary)
                            }
                        }
                    }
                    .padding(.horizontal, 8)
                }
            }
            .padding(16)
            .background(AppTheme.Colors.cardBackground)
            .cornerRadius(AppTheme.Radius.card)
            .shadow(color: .black.opacity(0.04), radius: 6, x: 0, y: 2)
        }
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

// MARK: - Donut Chart View
struct DonutChart: View {
    let slices: [CategorySlice]
    let lineWidth: CGFloat = 22

    var body: some View {
        GeometryReader { geo in
            let size = min(geo.size.width, geo.size.height)
            ZStack {
                ForEach(Array(slices.enumerated()), id: \.element.id) { index, slice in
                    let startAngle = angle(for: index)
                    let endAngle = angle(for: index + 1)
                    DonutSlice(
                        startAngle: startAngle,
                        endAngle: endAngle,
                        lineWidth: lineWidth
                    )
                    .fill(slice.color)
                }
            }
            .frame(width: size, height: size)
            .position(x: geo.size.width / 2, y: geo.size.height / 2)
        }
    }

    private func angle(for index: Int) -> Angle {
        let total = slices.reduce(0) { $0 + $1.percentage }
        guard total > 0 else { return .degrees(-90) }
        let sumBefore = slices.prefix(index).reduce(0) { $0 + $1.percentage }
        return .degrees((sumBefore / total) * 360 - 90)
    }
}

struct DonutSlice: Shape {
    let startAngle: Angle
    let endAngle: Angle
    let lineWidth: CGFloat

    func path(in rect: CGRect) -> Path {
        var path = Path()
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let radius = min(rect.width, rect.height) / 2 - lineWidth / 2
        path.addArc(
            center: center,
            radius: radius,
            startAngle: startAngle,
            endAngle: endAngle,
            clockwise: false
        )
        return path.strokedPath(.init(lineWidth: lineWidth, lineCap: .butt))
    }
}

#Preview {
    NavigationStack {
        HomeView()
    }
}
