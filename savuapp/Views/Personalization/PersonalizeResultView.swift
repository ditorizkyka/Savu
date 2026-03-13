// PersonalizeResultView.swift
// savuapp > Views > Personalization

import SwiftUI

struct PersonalizeResultView: View {
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var userStore: UserStore
    @State private var showContent = false

    var isRepersonalizing: Bool = false
    var dismissAll: (() -> Void)? = nil

    var body: some View {
        VStack(spacing: 0) {
            Spacer()

            // Success icon
            ZStack {
                Circle()
                    .fill(AppTheme.Colors.light)
                    .frame(width: 100, height: 100)
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 52))
                    .foregroundColor(AppTheme.Colors.primary)
            }
            .scaleEffect(showContent ? 1.0 : 0.5)
            .opacity(showContent ? 1.0 : 0)
            .animation(.spring(response: 0.5, dampingFraction: 0.6), value: showContent)
            .padding(.bottom, 24)

            // Title
            Text(isRepersonalizing ? "Updated!" : "You're All Set! ")
                .font(AppTheme.Typography.title2)
                .foregroundColor(AppTheme.Colors.textPrimary)
                .opacity(showContent ? 1.0 : 0)
                .animation(.easeIn.delay(0.2), value: showContent)
                .padding(.bottom, 8)

            Text(isRepersonalizing ? "Your personalization has been updated" : "Your personalized experience is ready")
                .font(AppTheme.Typography.subheadline)
                .foregroundColor(AppTheme.Colors.textSecondary)
                .opacity(showContent ? 1.0 : 0)
                .animation(.easeIn.delay(0.3), value: showContent)
                .padding(.bottom, 32)

            // Summary card
            VStack(spacing: 0) {
                summaryRow(icon: "person.fill", label: "Name", value: userStore.username)
                Divider().padding(.leading, 52)
                summaryRow(icon: "envelope.fill", label: "Email", value: userStore.email)
                Divider().padding(.leading, 52)
                summaryRow(icon: "calendar", label: "Age", value: userStore.selectedAge)
                Divider().padding(.leading, 52)
                summaryRow(icon: "arrow.down.circle.fill", label: "Income", value: shortLabel(userStore.selectedIncome))
                Divider().padding(.leading, 52)
                summaryRow(icon: "arrow.up.circle.fill", label: "Expense", value: shortLabel(userStore.selectedExpense))
            }
            .background(Color.white)
            .cornerRadius(16)
            .shadow(color: .black.opacity(0.06), radius: 8, x: 0, y: 4)
            .padding(.horizontal, 24)
            .opacity(showContent ? 1.0 : 0)
            .offset(y: showContent ? 0 : 20)
            .animation(.easeOut.delay(0.4), value: showContent)

            Spacer()

            // Action button
            Button(action: {
                if isRepersonalizing {
                    // Dismiss the entire fullScreenCover back to Profile
                    dismissAll?()
                } else {
                    // First-time onboarding: complete and go to main app
                    userStore.completeOnboarding()
                    appState.isOnboardingComplete = true
                }
            }) {
                Text(isRepersonalizing ? "Back to Profile" : "Get Started")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 54)
                    .background(AppTheme.Colors.primary)
                    .cornerRadius(30)
            }
            .padding(.horizontal, 32)
            .padding(.bottom, 48)
            .opacity(showContent ? 1.0 : 0)
            .animation(.easeIn.delay(0.6), value: showContent)
        }
        .background(Color(.systemGroupedBackground))
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
        .toolbar(.hidden, for: .navigationBar)
        .onAppear {
            withAnimation {
                showContent = true
            }
        }
    }

    // MARK: - Row
    private func summaryRow(icon: String, label: String, value: String) -> some View {
        HStack(spacing: 14) {
            ZStack {
                Circle()
                    .fill(AppTheme.Colors.light)
                    .frame(width: 36, height: 36)
                Image(systemName: icon)
                    .font(.system(size: 14))
                    .foregroundColor(AppTheme.Colors.primary)
            }
            VStack(alignment: .leading, spacing: 2) {
                Text(label)
                    .font(AppTheme.Typography.caption)
                    .foregroundColor(AppTheme.Colors.textSecondary)
                Text(value.isEmpty ? "—" : value)
                    .font(AppTheme.Typography.bodyMedium)
                    .foregroundColor(AppTheme.Colors.textPrimary)
                    .lineLimit(1)
            }
            Spacer()
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
    }

    private func shortLabel(_ text: String) -> String {
        if text.contains("Less than") { return "< Rp1jt" }
        if text.contains("More than") { return "> Rp10jt" }
        return text
            .replacingOccurrences(of: ",000,000", with: "jt")
            .replacingOccurrences(of: ",000", with: "k")
    }
}

#Preview {
    PersonalizeResultView()
        .environmentObject(AppState())
        .environmentObject(UserStore.shared)
}
