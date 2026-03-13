import SwiftUI

struct Question4View: View {
    @ObservedObject var data: PersonalizationViewModel
    @Binding var currentStep: Int
    @State private var isExpanded: Bool = true
    var onFinish: (() -> Void)? = nil
    var onDirectionChange: ((Bool) -> Void)? = nil

    let expenseOptions = [
        "Less than Rp1,000,000",
        "Rp1,000,000 – Rp3,000,000",
        "Rp3,000,000 – Rp5,000,000",
        "Rp5,000,000 – Rp10,000,000",
        "More than Rp10,000,000"
    ]

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Question Header
            VStack(alignment: .leading, spacing: 6) {
                Text("Question 4")
                    .font(.system(size: 24, weight: .bold))
                
                Text("What are your total fixed monthly expenses?")
                    .font(.system(size: 16))
                    .foregroundColor(.black)
                
                Text("*Choose only 1 answer that suits you")
                    .font(.system(size: 13))
                    .foregroundColor(.gray)
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 24)

            // Dropdown (same pattern as Q2)
            VStack(spacing: 0) {
                Button(action: {
                    withAnimation(.easeInOut(duration: 0.25)) {
                        isExpanded.toggle()
                    }
                }) {
                    HStack {
                        Text(data.selectedExpense.isEmpty ? "Select one" : data.selectedExpense)
                            .font(.system(size: 15))
                            .foregroundColor(data.selectedExpense.isEmpty ? Color(.systemGray3) : .black)
                        Spacer()
                        Image(systemName: "chevron.down")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.gray)
                            .rotationEffect(.degrees(isExpanded ? 180 : 0))
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 16)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color(.systemGray4), lineWidth: 1.2)
                    )
                }
                .padding(.horizontal, 20)

                if isExpanded {
                    VStack(spacing: 0) {
                        ForEach(expenseOptions, id: \.self) { option in
                            Button(action: {
                                withAnimation(.easeInOut(duration: 0.15)) {
                                    data.selectedExpense = option
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                        withAnimation { isExpanded = false }
                                    }
                                }
                            }) {
                                HStack {
                                    Text(option)
                                        .font(.system(size: 15))
                                        .foregroundColor(
                                            data.selectedExpense == option ? AppTheme.Colors.primary : .black
                                        )
                                    Spacer()
                                }
                                .padding(.horizontal, 16)
                                .padding(.vertical, 16)
                                .background(
                                    data.selectedExpense == option
                                        ? Color.blue.opacity(0.08)
                                        : Color.white
                                )
                            }

                            if option != expenseOptions.last {
                                Divider().padding(.horizontal, 16)
                            }
                        }
                    }
                    .background(Color.white)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color(.systemGray4), lineWidth: 1.2)
                    )
                    .cornerRadius(10)
                    .padding(.horizontal, 20)
                    .padding(.top, 8)
                    .transition(.opacity.combined(with: .move(edge: .top)))
                }
            }

            Spacer()

            BottomNavButtons(
                currentStep: $currentStep,
                canGoNext: !data.selectedExpense.isEmpty,
                totalSteps: 4,
                onFinish: onFinish,
                onDirectionChange: onDirectionChange
            )
        }.navigationBarBackButtonHidden(true)
    }
}

#Preview("Question 3") {
    let data = PersonalizationViewModel()
    data.selectedExpense = "Rp1,000,000 – Rp3,000,000"
    return NavigationStack {
        VStack(spacing: 0) {
            HStack {
                Image(systemName: "chevron.left").font(.system(size: 18, weight: .semibold))
                Spacer()
                Text("Personalization").font(.system(size: 17, weight: .semibold))
                Spacer()
                Image(systemName: "chevron.left").opacity(0)
            }
            .padding(.horizontal, 20).padding(.vertical, 12)
            HStack(spacing: 6) {
                ForEach(1...3, id: \.self) { _ in
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color.blue)
                        .frame(height: 5)
                }
            }
            .padding(.horizontal, 20).padding(.bottom, 28)
            Question3View(data: data, currentStep: .constant(3))
        }
    }
}
