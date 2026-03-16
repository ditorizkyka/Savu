// HomeView.swift
// savuapp > Views > HomePage

// MARK: - Imports
import SwiftUI

// MARK: - Main Type Declaration
struct HomeView: View {
    // MARK: - Properties
    @StateObject private var viewModel = HomeViewModel()
    @State private var showAddTransaction = false
    @State private var showTodaysWrap = false
    @Environment(\.scenePhase) private var scenePhase

    // MARK: - Body
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            ScrollView {
                VStack(spacing: 0) {
                    // MARK: - Header & Card Layering
                    ZStack(alignment: .top) {
                        // 1. Dark navy background (bottom layer)
                        headerBackground

                        // 2. Profile header + balance card (top layer)
                        VStack(spacing: 0) {
                            profileHeader
                            balanceCard
                        }
                    }

                    // MARK: - Main Content Area
                    VStack(spacing: 24) {
                        suggestionSection
                        overviewSection
                    }
                    .padding(20)
                    .padding(.bottom, 80)
                }
            }
            .background(Color(uiColor: .systemBackground))

            floatingActionButton
        }
        .edgesIgnoringSafeArea(.top)
        .navigationBarHidden(true)
        .navigationDestination(isPresented: $showAddTransaction) {
            AddTransactionView(store: viewModel.store)
        }
        .fullScreenCover(isPresented: $showTodaysWrap) {
            TodaysWrapView()
        }
        .onAppear {
            let appearance = UITabBarAppearance()
            appearance.configureWithTransparentBackground()
            appearance.backgroundEffect = UIBlurEffect(style: .systemUltraThinMaterial)
            appearance.backgroundColor = UIColor.systemBackground.withAlphaComponent(0.3)
            UITabBar.appearance().standardAppearance = appearance
            UITabBar.appearance().scrollEdgeAppearance = appearance
            Task { await viewModel.triggerAutoGenerationIfNeeded() }
        }
        .onChange(of: scenePhase) { _, newPhase in
            if newPhase == .active {
                Task { await viewModel.triggerAutoGenerationIfNeeded() }
            }
        }
    }
}

// MARK: - Private Subviews
extension HomeView {

    private var headerBackground: some View {
        Color(red: 0.02, green: 0.05, blue: 0.12)
            .frame(height: 220)
    }

    private var profileHeader: some View {
        HStack(spacing: 16) {
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
                        .foregroundStyle(.white.opacity(0.8))
                }
            }

            VStack(alignment: .leading, spacing: 2) {
                Text("Good \(greetingTime), \(viewModel.userName)")
                    .font(.system(size: 16, weight: .bold))
                Text("You Are The \(viewModel.spendingTagline)")
                    .font(.system(size: 12))
                    .opacity(0.6)
            }
            .foregroundStyle(.white)

            Spacer()
        }
        .padding(.horizontal, 24)
        .padding(.top, 60)
        .padding(.bottom, 24)
    }

    private var balanceCard: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Total Balance")
                .font(.system(size: 14))
                .opacity(0.9)

            Text(viewModel.formattedBalance)
                .font(.system(size: 32, weight: .bold))

            HStack {
                summaryItem(label: "Income", amount: viewModel.formattedIncome)
                Spacer()
                summaryItem(label: "Expense", amount: viewModel.formattedExpense)
                Spacer()
            }
        }
        .padding(24)
        .background(
            RoundedRectangle(cornerRadius: 24)
                .fill(LinearGradient(
                    colors: [Color(red: 0.05, green: 0.3, blue: 0.9), Color(red: 0.1, green: 0.2, blue: 0.7)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                ))
        )
        .foregroundStyle(.white)
        .padding(.horizontal, 20)
        .shadow(color: Color.black.opacity(0.2), radius: 20, x: 0, y: 12)
    }

    private func summaryItem(label: String, amount: String) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(label).font(.caption).opacity(0.8)
            Text(amount).font(.system(size: 14, weight: .bold))
        }
    }

    // MARK: - Suggestion Section
    private var suggestionSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Our Suggestion")
                .font(.headline)

            Button(action: {
                if viewModel.hasSuggestion {
                    showTodaysWrap = true
                } else {
                    showAddTransaction = true
                }
            }) {
                HStack(spacing: 16) {
                    // Leading icon
                    ZStack {
                        Circle()
                            .fill(viewModel.hasSuggestion
                                  ? Color.white.opacity(0.2)
                                  : Color.white.opacity(0.08))
                            .frame(width: 48, height: 48)

                        Image(systemName: viewModel.hasSuggestion
                              ? "checkmark.circle.fill"
                              : viewModel.hasTransactionsToday
                                ? "rays"
                                : "plus.circle")
                            .font(.system(size: viewModel.hasSuggestion ? 28 : 22, weight: .semibold))
                            .foregroundStyle(viewModel.hasSuggestion ? .white : .white.opacity(0.6))
                            .symbolEffect(.pulse, isActive: !viewModel.hasSuggestion && viewModel.hasTransactionsToday)
                    }

                    // Text content
                    VStack(alignment: .leading, spacing: 4) {
                        Text(viewModel.hasSuggestion
                             ? "Your Daily Suggestion is Ready!"
                             : viewModel.hasTransactionsToday
                               ? "Your Daily Suggestion Is Being Prepared"
                               : "No Transactions Yet Today")
                            .font(.system(size: 15, weight: .bold))
                            .multilineTextAlignment(.leading)

                        Text(viewModel.hasSuggestion
                             ? "Tap to see your insights →"
                             : viewModel.hasTransactionsToday
                               ? "Ready around \(nextSuggestionTime)"
                               : "Add a transaction to get today's insight")
                            .font(.caption)
                            .opacity(0.75)
                    }

                    Spacer()
                }
                .padding(20)
                .foregroundStyle(.white)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(
                            viewModel.hasSuggestion
                            ? LinearGradient(
                                stops: [
                                    .init(color: Color(red: 0.05, green: 0.65, blue: 0.45), location: 0),
                                    .init(color: Color(red: 0.02, green: 0.45, blue: 0.35), location: 1)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                            : LinearGradient(
                                stops: [
                                    .init(color: Color(red: 0.22, green: 0.18, blue: 0.1), location: 0),
                                    .init(color: Color(red: 0.1, green: 0.1, blue: 0.1), location: 1)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(
                            viewModel.hasSuggestion
                            ? Color.white.opacity(0.25)
                            : Color.white.opacity(0.05),
                            lineWidth: 1
                        )
                )
                .shadow(
                    color: viewModel.hasSuggestion
                        ? Color(red: 0.05, green: 0.65, blue: 0.45).opacity(0.4)
                        : .clear,
                    radius: 12, x: 0, y: 6
                )
            }
            .buttonStyle(.plain)
            .animation(.easeInOut(duration: 0.35), value: viewModel.hasSuggestion)
        }
    }


    // MARK: - Overview Section
    private var overviewSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Overview").font(.headline)

            VStack(spacing: 24) {
                // Month navigation (chevron-based, same logic as before)
                HStack {
                    Spacer()
                    HStack(spacing: 12) {
                        Button(action: {
                            withAnimation { viewModel.previousMonth() }
                        }) {
                            Image(systemName: "chevron.left")
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundStyle(AppTheme.Colors.textPrimary)
                                .padding(8)
                        }

                        Text(viewModel.currentMonthName)
                            .font(.system(size: 14, weight: .medium))
                            .foregroundStyle(AppTheme.Colors.textPrimary)
                            .frame(minWidth: 100)
                            .multilineTextAlignment(.center)

                        Button(action: {
                            withAnimation { viewModel.nextMonth() }
                        }) {
                            Image(systemName: "chevron.right")
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundStyle(viewModel.hasNextMonth ? AppTheme.Colors.textPrimary : .gray.opacity(0.3))
                                .padding(8)
                        }
                        .disabled(!viewModel.hasNextMonth)
                    }
                    .padding(.horizontal, 8)
                    .padding(.vertical, 2)
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(AppTheme.Colors.divider, lineWidth: 1)
                    )
                    Spacer()
                }

                // Donut Chart
                if viewModel.expenseCategorySlices.isEmpty {
                    ZStack {
                        Circle()
                            .stroke(AppTheme.Colors.light, lineWidth: 20)
                            .frame(width: 160, height: 160)
                        VStack(spacing: 2) {
                            Text("No Data")
                                .font(.system(size: 13))
                                .foregroundStyle(AppTheme.Colors.textSecondary)
                            Text("Rp 0")
                                .font(.system(size: 18, weight: .bold))
                                .foregroundStyle(AppTheme.Colors.textPrimary)
                        }
                    }
                    .frame(height: 200)
                } else {
                    ZStack {
                        DonutChart(slices: viewModel.expenseCategorySlices)
                            .frame(width: 180, height: 180)
                        VStack(spacing: 2) {
                            if let top = viewModel.expenseCategorySlices.first {
                                Text(top.name)
                                    .font(.system(size: 12))
                                    .foregroundStyle(AppTheme.Colors.textSecondary)
                            }
                            Text(viewModel.formattedTotalMonthExpense)
                                .font(.system(size: 17, weight: .bold))
                                .foregroundStyle(AppTheme.Colors.textPrimary)
                        }
                    }
                    .frame(height: 200)

                    // Legend
                    VStack(spacing: 12) {
                        ForEach(viewModel.expenseCategorySlices) { slice in
                            legendItem(color: slice.color, label: slice.name, percent: "\(Int(slice.percentage * 100))%")
                        }
                    }
                }
            }
            .padding(24)
            .background(
                RoundedRectangle(cornerRadius: 24)
                    .fill(.white)
                    .shadow(color: .black.opacity(0.05), radius: 10)
            )
            .shadow(color: Color.black.opacity(0.15), radius: 20, x: 0, y: 10)
        }
    }

    private func legendItem(color: Color, label: String, percent: String) -> some View {
        HStack {
            Circle().fill(color).frame(width: 10, height: 10)
            Text(label).font(.caption).foregroundStyle(.secondary)
            Spacer()
            Text(percent).font(.caption).fontWeight(.bold)
        }
    }

    private var floatingActionButton: some View {
        Button(action: { showAddTransaction = true }) {
            Image(systemName: "plus")
                .font(.system(size: 24, weight: .bold))
                .foregroundStyle(.white)
                .frame(width: 60, height: 60)
                .background(Circle().fill(Color.blue))
                .shadow(color: .blue.opacity(0.3), radius: 10, y: 5)
        }
        .padding(.trailing, 24)
        .padding(.bottom, 20)
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

    // MARK: - Next Suggestion Time Helper
    /// Returns the fixed auto-generation time of 8:00 PM.
    private var nextSuggestionTime: String {
        var components = DateComponents()
        components.hour = 20
        components.minute = 0
        guard let eightPM = Calendar.current.date(from: components) else { return "8:00 PM" }
        let fmt = DateFormatter()
        fmt.dateFormat = "h:mm a"
        return fmt.string(from: eightPM)
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

// MARK: - Preview
#Preview {
    NavigationStack {
        HomeView()
    }
}
