// UserStore.swift
// savuapp

import Foundation
import Combine

@MainActor
final class UserStore: ObservableObject {

    // MARK: - Singleton
    static let shared = UserStore()

    // MARK: - UserDefaults Keys
    private enum Keys {
        static let username = "savu_username"
        static let email = "savu_email"
        static let selectedAge = "savu_selected_age"
        static let selectedIncome = "savu_selected_income"
        static let selectedExpense = "savu_selected_expense"
        static let hasCompletedOnboarding = "savu_has_completed_onboarding"
    }

    // MARK: - Published State
    @Published var username: String {
        didSet { UserDefaults.standard.set(username, forKey: Keys.username) }
    }
    @Published var email: String {
        didSet { UserDefaults.standard.set(email, forKey: Keys.email) }
    }
    @Published var selectedAge: String {
        didSet { UserDefaults.standard.set(selectedAge, forKey: Keys.selectedAge) }
    }
    @Published var selectedIncome: String {
        didSet { UserDefaults.standard.set(selectedIncome, forKey: Keys.selectedIncome) }
    }
    @Published var selectedExpense: String {
        didSet { UserDefaults.standard.set(selectedExpense, forKey: Keys.selectedExpense) }
    }
    @Published var hasCompletedOnboarding: Bool {
        didSet { UserDefaults.standard.set(hasCompletedOnboarding, forKey: Keys.hasCompletedOnboarding) }
    }

    // MARK: - Init
    init() {
        let defaults = UserDefaults.standard
        self.username = defaults.string(forKey: Keys.username) ?? ""
        self.email = defaults.string(forKey: Keys.email) ?? ""
        self.selectedAge = defaults.string(forKey: Keys.selectedAge) ?? ""
        self.selectedIncome = defaults.string(forKey: Keys.selectedIncome) ?? ""
        self.selectedExpense = defaults.string(forKey: Keys.selectedExpense) ?? ""
        self.hasCompletedOnboarding = defaults.bool(forKey: Keys.hasCompletedOnboarding)
    }

    // MARK: - Save from PersonalizationViewModel
    func savePersonalization(from vm: PersonalizationViewModel) {
        username = vm.username
        email = vm.email
        selectedAge = vm.selectedAge
        selectedIncome = vm.selectedIncome
        selectedExpense = vm.selectedExpense
    }

    // MARK: - Load into PersonalizationViewModel (for re-personalization)
    func loadInto(vm: PersonalizationViewModel) {
        vm.username = username
        vm.email = email
        vm.selectedAge = selectedAge
        vm.selectedIncome = selectedIncome
        vm.selectedExpense = selectedExpense
    }

    // MARK: - Complete Onboarding
    func completeOnboarding() {
        hasCompletedOnboarding = true
    }

    // MARK: - Computed
    var spendingTagline: String {
        guard !selectedExpense.isEmpty else { return "Saver" }
        if selectedExpense.contains("Less than") || selectedExpense.contains("Rp1,000,000 –") {
            return "Smart Saver"
        } else if selectedExpense.contains("Rp3,000,000 –") {
            return "Balanced Spender"
        } else {
            return "Big Spender"
        }
    }
}
