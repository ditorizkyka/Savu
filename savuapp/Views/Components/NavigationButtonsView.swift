//
//  NavigationButtonsView.swift
//  savuapp
//
//  Created by Andito Rizkyka Rianto on 13/03/26.
//


import SwiftUI

struct NavigationButtonsView: View {
    @Binding var currentStep: Int
    var canGoNext: Bool
    var isLastStep: Bool = false
    
    var body: some View {
        HStack(spacing: 16) {
            // Previous
            Button(action: { if currentStep > 1 { currentStep -= 1 } }) {
                Text("Previous")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(currentStep > 1 ? .black : .gray)
                    .frame(maxWidth: .infinity)
                    .frame(height: 52)
                    .background(Color(.systemGray5))
                    .cornerRadius(30)
            }
            .disabled(currentStep <= 1)
            
            // Next / Finish
            Button(action: { if canGoNext { currentStep += 1 } }) {
                Text(isLastStep ? "Finish" : "Next")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 52)
                    .background(canGoNext ? Color.blue : Color.blue.opacity(0.4))
                    .cornerRadius(30)
            }
            .disabled(!canGoNext)
        }
        .padding(.horizontal, 20)
        .padding(.bottom, 40)
    }
}


