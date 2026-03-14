//
//  SuggestionViewModel.swift
//  savuapp
//

import SwiftUI
import Combine

@MainActor
final class SuggestionViewModel: ObservableObject {
    
    // MARK: - Published State
    @Published var activeCards: [WrapCard] = []
    @Published var fullCards: [WrapCard] = []
    @Published var isGenerating: Bool = false
    @Published var errorMessage: String? = nil
    
    private var cancellables = Set<AnyCancellable>()
    let transactionStore: TransactionStore
    let userStore: UserStore
    
    // MARK: - Init
    init(transactionStore: TransactionStore = .shared, userStore: UserStore = .shared) {
        self.transactionStore = transactionStore
        self.userStore = userStore
        
        // We won't auto-generate on init for AI, to save API calls.
        // It will be triggered manually from the View.
        
        // Clear old insights if transactions change
        transactionStore.objectWillChange
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in
                self?.skipAll()
            }
            .store(in: &cancellables)
    }
    
    // MARK: - Core Logic AI
    
    // Cache Key
    private let dailyCardsCacheKey = "savu_daily_cards_cache"
    private let lastGeneratedDateKey = "savu_last_generated_date"
    
    func generateAIInsights() async {
        guard !isGenerating else { return }
        
        isGenerating = true
        errorMessage = nil
        
        do {
            // 1. Check if we already generated insights today
            if let lastDate = UserDefaults.standard.object(forKey: lastGeneratedDateKey) as? Date,
               Calendar.current.isDateInToday(lastDate),
               let cachedData = UserDefaults.standard.data(forKey: dailyCardsCacheKey),
               let cachedCards = try? JSONDecoder().decode([WrapCard].self, from: cachedData) {
                
                print("✅ [Cache Hit] Loaded today's AI insights from UserDefaults")
                self.activeCards = cachedCards
                self.fullCards = cachedCards
                self.isGenerating = false
                return
            }
            
            // 2. Otherwise generate new ones
            print("🤖 [Cache Miss] Generating new AI insights...")
            let engine = SuggestionEngine()
            let newCards = try await engine.generate(transactionStore: transactionStore, userStore: userStore)
            
            // Reverse so the most general card is at the bottom of the stack
            let generated = Array(newCards.reversed()) 
            
            // 3. Save to cache
            if let encodedData = try? JSONEncoder().encode(generated) {
                UserDefaults.standard.set(encodedData, forKey: dailyCardsCacheKey)
                UserDefaults.standard.set(Date(), forKey: lastGeneratedDateKey)
                print("💾 Saved new AI insights to cache")
            }
            
            self.activeCards = generated
            self.fullCards = generated
            
        } catch {
            self.errorMessage = error.localizedDescription
            print("❌ AI Generation Error: \(error)")
        }
        
        isGenerating = false
    }
    
    // MARK: - Actions
    func dismissCard(id: UUID) {
        withAnimation(.spring()) {
            activeCards.removeAll { $0.id == id }
        }
    }
    
    func skipAll() {
        withAnimation {
            activeCards.removeAll()
        }
    }
    
    // MARK: - Summary Data
    var todaysExpenseAmount: String {
        let today = Date()
        let amount = transactionStore.transactions
            .filter { Calendar.current.isDate($0.date, inSameDayAs: today) && $0.type == .expenses }
            .reduce(0) { $0 + $1.amount }
        return formatAmount(amount)
    }
    
    var todaysIncomeAmount: String {
        let today = Date()
        let amount = transactionStore.transactions
            .filter { Calendar.current.isDate($0.date, inSameDayAs: today) && $0.type == .income }
            .reduce(0) { $0 + $1.amount }
        return formatAmount(amount)
    }
    
    var todaysBalanceAmount: String {
        let today = Date()
        let income = transactionStore.transactions
            .filter { Calendar.current.isDate($0.date, inSameDayAs: today) && $0.type == .income }
            .reduce(0) { $0 + $1.amount }
        let expense = transactionStore.transactions
            .filter { Calendar.current.isDate($0.date, inSameDayAs: today) && $0.type == .expenses }
            .reduce(0) { $0 + $1.amount }
        return formatAmount(income - expense)
    }
    
    // MARK: - Formatting Helper
    private func formatAmount(_ amount: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = "."
        formatter.maximumFractionDigits = 0
        let formatted = formatter.string(from: NSNumber(value: abs(amount))) ?? "0"
        return "\(amount < 0 ? "-" : "")Rp \(formatted)"
    }
}
