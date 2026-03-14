import SwiftUI

struct Question2View: View {
    @ObservedObject var data: PersonalizationViewModel
    @Binding var currentStep: Int
    var onDirectionChange: ((Bool) -> Void)? = nil
    
    let ageOptions = ["Under 18", "18 – 24", "25 – 34", "35 – 44", "More than 45"]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            
            // Question Header
            VStack(alignment: .leading, spacing: 6) {
                Text("Question 2")
                    .font(AppTheme.Typography.title2)
                
                Text("What is your range of age?")
                    .font(AppTheme.Typography.body)
                    .foregroundColor(AppTheme.Colors.textPrimary)
                
                Text("*Choose only 1 answer that suits you")
                    .font(AppTheme.Typography.caption)
                    .foregroundColor(AppTheme.Colors.textSecondary)
            }
            .padding(.horizontal, AppTheme.Spacing.xl)
            .padding(.bottom, AppTheme.Spacing.xxl)
            
            // Options
            VStack(spacing: 10) {
                ForEach(ageOptions, id: \.self) { option in
                    Button(action: {
                        withAnimation(.easeInOut(duration: 0.15)) {
                            data.selectedAge = option
                        }
                    }) {
                        HStack {
                            Text(option)
                                .font(AppTheme.Typography.bodyMedium)
                                .foregroundColor(
                                    data.selectedAge == option
                                        ? AppTheme.Colors.primary
                                        : AppTheme.Colors.textPrimary
                                )
                            Spacer()
                        }
                        .padding(.horizontal, AppTheme.Spacing.lg)
                        .padding(.vertical, AppTheme.Spacing.lg)
                        .background(
                            RoundedRectangle(cornerRadius: AppTheme.Radius.md)
                                .fill(
                                    data.selectedAge == option
                                        ? AppTheme.Colors.selectedBg
                                        : AppTheme.Colors.background
                                )
                                .overlay(
                                    RoundedRectangle(cornerRadius: AppTheme.Radius.md)
                                        .stroke(
                                            data.selectedAge == option
                                                ? AppTheme.Colors.primary
                                                : AppTheme.Colors.divider,
                                            lineWidth: 1.2
                                        )
                                )
                        )
                    }
                }
            }
            .padding(.horizontal, AppTheme.Spacing.xl)
            
            Spacer()
            
            // Bottom Buttons
            BottomNavButtons(
                currentStep: $currentStep,
                canGoNext: !data.selectedAge.isEmpty,
                totalSteps: 4,
                onDirectionChange: onDirectionChange
            )
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarHidden(true)
        .toolbar(.hidden, for: .navigationBar)
    }
}

// MARK: - Preview
#Preview("Question 1 - Empty") {
    PersonalizationContainerView()
}

#Preview("Question 1 - Selected") {
    let data = PersonalizationViewModel()
    data.selectedAge = "18 – 24"
    return NavigationStack {
        Question1View(data: data, currentStep: .constant(1))
    }
}
