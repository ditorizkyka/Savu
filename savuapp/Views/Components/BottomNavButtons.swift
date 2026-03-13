//
//  BottomNavButtons.swift
//  savuapp
//
//  Created by Andito Rizkyka Rianto on 13/03/26.
//

import SwiftUI

struct BottomNavButtons: View {
    @Binding var currentStep: Int
    var canGoNext: Bool
    var totalSteps: Int
    var onFinish: (() -> Void)? = nil

    var isFirstStep: Bool { currentStep == 1 }
    var isLastStep: Bool { currentStep == totalSteps }

    var body: some View {
        HStack(spacing: 12) {
            // Previous
            Button(action: {
                withAnimation(.easeInOut(duration: 0.3)) {
                    if currentStep > 1 { currentStep -= 1 }
                }
            }) {
                Text("Previous")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(isFirstStep ? Color(.systemGray3) : .black)
                    .frame(maxWidth: .infinity)
                    .frame(height: 54)
                    .background(Color(.systemGray5))
                    .cornerRadius(30)
            }
            .disabled(isFirstStep)

            // Next / Finish
            Button(action: {
                guard canGoNext else { return }
                if isLastStep {
                    onFinish?()
                } else {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        currentStep += 1
                    }
                }
            }) {
                Text(isLastStep ? "Finish" : "Next")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 54)
                    .background(canGoNext ? AppTheme.Colors.primary : AppTheme.Colors.primary.opacity(0.35))
                    .cornerRadius(30)
            }
            .disabled(!canGoNext)
        }
        .padding(.horizontal, 20)
        .padding(.bottom, 36)
    }
}
