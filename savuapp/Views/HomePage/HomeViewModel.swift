// HomeViewModel.swift
// savuapp > Views > HomePage

import SwiftUI
import Combine

// MARK: - Category Slice Model
struct CategorySlice: Identifiable {
    let id = UUID()
    let name: String
    let amount: Double
    let color: Color
    var percentage: Double = 0
}

@MainActor
final class HomeViewModel: ObservableObject {
    @Published var selectedMonth: Date = Date()
    
    var savingsGoalPercent: Double {
        let income = store.totalIncome
        guard income > 0 else { return 0 }
        return max(0, min(1, (income - store.totalExpense) / income))
    }

    private var cancellables = Set<AnyCancellable>()
    let store: TransactionStore
    let userStore: UserStore

    // MARK: - Init
    init(store: TransactionStore = .shared, userStore: UserStore = .shared) {
        self.store = store
        self.userStore = userStore

        // Re-publish when store changes
        store.objectWillChange
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in self?.objectWillChange.send() }
            .store(in: &cancellables)

        // Re-publish when userStore changes
        userStore.objectWillChange
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in self?.objectWillChange.send() }
            .store(in: &cancellables)

        // Poll every 60 seconds so we catch the 8 PM crossover while the app is open
        Timer.publish(every: 60, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                guard let self else { return }
                let hour = Calendar.current.component(.hour, from: Date())
                let minute = Calendar.current.component(.minute, from: Date())
                print("🕐 [AutoGen Timer] Tick — current time: \(hour):\(String(format: "%02d", minute))")
                Task { await self.triggerAutoGenerationIfNeeded() }
            }
            .store(in: &cancellables)
    }

    // MARK: - User Data
    var userName: String {
        let name = userStore.username
        return name.isEmpty ? "User" : name
    }

    var profileImage: UIImage? {
        let docs = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let url = docs.appendingPathComponent("savu_profile.jpg")
        guard FileManager.default.fileExists(atPath: url.path),
              let data = try? Data(contentsOf: url) else { return nil }
        return UIImage(data: data)
    }

    // MARK: - Computed from Store

    var totalIncome: Double { store.totalIncome }
    var totalExpense: Double { store.totalExpense }
    var totalBalance: Double { store.totalBalance }

    var formattedBalance: String { CurrencyFormatter.format(totalBalance) }
    var formattedIncome: String { CurrencyFormatter.format(totalIncome) }
    var formattedExpense: String { CurrencyFormatter.format(totalExpense) }

    var recentTransactions: [StoredTransaction] { store.recentTransactions }

    // MARK: - Suggestion Banner Data

    var spendingTagline: String { userStore.spendingTagline }

    var suggestionIcon: String {
        if savingsGoalPercent >= 0.5 { return "leaf.fill" }
        if savingsGoalPercent >= 0.2 { return "scale.3d" }
        return "exclamationmark.triangle.fill"
    }

    /// True only if AI-generated suggestion cards exist AND were generated today.
    var hasSuggestion: Bool {
        guard
            let lastDate = UserDefaults.standard.object(forKey: "savu_last_generated_date") as? Date,
            Calendar.current.isDateInToday(lastDate),
            let data = UserDefaults.standard.data(forKey: "savu_daily_cards_cache"),
            let cards = try? JSONDecoder().decode([WrapCard].self, from: data),
            !cards.isEmpty
        else { return false }
        return true
    }

    /// True if there is at least one transaction recorded today.
    var hasTransactionsToday: Bool {
        store.transactions.contains {
            Calendar.current.isDateInToday($0.date)
        }
    }

    // MARK: - 8 PM Auto-Generation

    private let dailyCardsCacheKey = "savu_daily_cards_cache"
    private let lastGeneratedDateKey = "savu_last_generated_date"

    /// Called on every foreground event. Silently generates suggestions if:
    ///   - The current time is 8 PM or later
    ///   - Today has at least one transaction
    ///   - No suggestion has been generated and cached today yet
    func triggerAutoGenerationIfNeeded() async {
        let now = Date()
        let hour = Calendar.current.component(.hour, from: now)
        let minute = Calendar.current.component(.minute, from: now)
        print("🔍 [AutoGen] Checking conditions at \(hour):\(String(format: "%02d", minute))…")

        guard hour >= 20 else {
            print("⛔️ [AutoGen] Too early — hour is \(hour), need >= 20 (8 PM). Skipping.")
            return
        }
        guard hasTransactionsToday else {
            print("⛔️ [AutoGen] No transactions today. Skipping.")
            return
        }
        guard !hasSuggestion else {
            print("⛔️ [AutoGen] Suggestion already cached for today. Skipping.")
            return
        }

        print("⏰ [AutoGen] All conditions met — generating suggestions in background…")
        do {
            let engine = SuggestionEngine()
            print("🤖 [AutoGen] Calling SuggestionEngine.generate()…")
            let cards = try await engine.generate(transactionStore: store, userStore: userStore)
            print("📦 [AutoGen] Engine returned \(cards.count) card(s).")
            guard !cards.isEmpty else {
                print("⚠️ [AutoGen] Engine returned empty cards — no transactions today? Skipping cache.")
                return
            }
            let reversed = Array(cards.reversed())
            if let encoded = try? JSONEncoder().encode(reversed) {
                UserDefaults.standard.set(encoded, forKey: dailyCardsCacheKey)
                UserDefaults.standard.set(Date(), forKey: lastGeneratedDateKey)
                print("✅ [AutoGen] Saved \(reversed.count) cards to cache. UI will refresh.")
            }
            objectWillChange.send()
        } catch {
            print("❌ [AutoGen] Generation failed: \(error.localizedDescription)")
        }
    }

    var suggestionMessage: String {
        if totalIncome == 0 && totalExpense == 0 {
            return "Start tracking your finances by adding your first transaction!"
        }
        if savingsGoalPercent >= 0.5 {
            return "Great job! You're saving \(Int(savingsGoalPercent * 100))% of your income. Keep it up!"
        } else if savingsGoalPercent >= 0.2 {
            return "You're doing okay. Try to reduce some expenses to save more."
        } else if savingsGoalPercent > 0 {
            return "Your expenses are high. Consider reviewing your spending habits."
        } else {
            return "Your expenses exceed your income. Time to cut back on spending!"
        }
    }

    // MARK: - Overview / Donut Chart Data

    /// Month Navigation
    func previousMonth() {
        if let newDate = Calendar.current.date(byAdding: .month, value: -1, to: selectedMonth) {
            selectedMonth = newDate
        }
    }
    
    func nextMonth() {
        if hasNextMonth, let newDate = Calendar.current.date(byAdding: .month, value: 1, to: selectedMonth) {
            selectedMonth = newDate
        }
    }
    
    var hasNextMonth: Bool {
        let currentMonth = Calendar.current.component(.month, from: Date())
        let currentYear = Calendar.current.component(.year, from: Date())
        let selectedMonthNum = Calendar.current.component(.month, from: selectedMonth)
        let selectedYear = Calendar.current.component(.year, from: selectedMonth)
        
        return selectedYear < currentYear || (selectedYear == currentYear && selectedMonthNum < currentMonth)
    }

    /// Predefined category colors
    private let categoryColors: [Color] = [
        Color(hex: "002267"),   // Dark navy
        Color(hex: "014CE6"),   // Primary blue
        Color(hex: "5B8DEF"),   // Light blue
        Color(hex: "A3C4F7"),   // Lighter blue
        Color(hex: "0139AD"),   // Medium blue
        Color(hex: "7AA8F2"),   // Soft blue
    ]

    /// Current month name
    var currentMonthName: String {
        let fmt = DateFormatter()
        fmt.dateFormat = "MMMM yyyy"
        return fmt.string(from: selectedMonth)
    }

    /// Expense breakdown by category for the current month
    var expenseCategorySlices: [CategorySlice] {
        let calendar = Calendar.current
        let monthExpenses = store.transactions.filter {
            $0.type == .expenses &&
            calendar.component(.month, from: $0.date) == calendar.component(.month, from: selectedMonth) &&
            calendar.component(.year, from: $0.date) == calendar.component(.year, from: selectedMonth)
        }

        let grouped = Dictionary(grouping: monthExpenses) { $0.category }
        let totalExpenseMonth = monthExpenses.reduce(0.0) { $0 + $1.amount }

        var slices: [CategorySlice] = []
        for (index, (category, transactions)) in grouped.sorted(by: { $0.value.reduce(0) { $0 + $1.amount } > $1.value.reduce(0) { $0 + $1.amount } }).enumerated() {
            let amount = transactions.reduce(0.0) { $0 + $1.amount }
            let pct = totalExpenseMonth > 0 ? amount / totalExpenseMonth : 0
            slices.append(CategorySlice(
                name: category,
                amount: amount,
                color: categoryColors[index % categoryColors.count],
                percentage: pct
            ))
        }
        return slices
    }

    var totalMonthExpense: Double {
        let calendar = Calendar.current
        return store.transactions.filter {
            $0.type == .expenses &&
            calendar.component(.month, from: $0.date) == calendar.component(.month, from: selectedMonth) &&
            calendar.component(.year, from: $0.date) == calendar.component(.year, from: selectedMonth)
        }.reduce(0.0) { $0 + $1.amount }
    }

    var formattedTotalMonthExpense: String { CurrencyFormatter.format(totalMonthExpense) }
}
