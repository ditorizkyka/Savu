//
//  Question2IncomeView.swift
//  savuapp
//
//  Created by Andito Rizkyka Rianto on 13/03/26.
//

import SwiftUI

struct Question3View: View {
    @ObservedObject var data: PersonalizationViewModel
    @Binding var currentStep: Int
    @State private var isExpanded = false
    var onDirectionChange: ((Bool) -> Void)? = nil
    
    let incomeOptions = [
        "Less than Rp3,000,000",
        "Rp3,000,001 – Rp5,000,000",
        "Rp5,000,001 – Rp15,000,000",
        "Rp15,000,001 – Rp50,000,000",
        "More than Rp50,000,000"
    ]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            VStack(alignment: .leading, spacing: 6) {
                Text("Question 3")
                    .font(.system(size: 22, weight: .bold))
                
                Text("What is your average monthly income?")
                    .font(.system(size: 16))
                
                Text("*Choose only 1 answer that suits you")
                    .font(.system(size: 12))
                    .foregroundColor(.gray)
            }
            .padding(.horizontal, 20)
            
            Spacer().frame(height: 24)
            
            // Dropdown
            VStack(spacing: 0) {
                // Trigger
                Button(action: { withAnimation { isExpanded.toggle() } }) {
                    HStack {
                        Text(data.selectedIncome.isEmpty ? "Select one" : data.selectedIncome)
                            .foregroundColor(data.selectedIncome.isEmpty ? .gray : .black)
                            .font(.system(size: 15))
                        Spacer()
                        Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                            .foregroundColor(.gray)
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 16)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color(.systemGray4), lineWidth: 1)
                    )
                }
                .padding(.horizontal, 20)
                
                // Options list
                if isExpanded {
                    VStack(spacing: 0) {
                        ForEach(incomeOptions, id: \.self) { option in
                            OptionRowView(
                                title: option,
                                isSelected: data.selectedIncome == option
                            ) {
                                data.selectedIncome = option
                                withAnimation { isExpanded = false }
                            }
                            if option != incomeOptions.last {
                                Divider().padding(.horizontal, 20)
                            }
                        }
                    }
                    .background(AppTheme.Colors.cardBackground)
                    .shadow(color: .black.opacity(0.08), radius: 8, y: 4)
                    .padding(.horizontal, 20)
                }
            }
            
            Spacer()
            
            // Bottom Buttons
            BottomNavButtons(
                currentStep: $currentStep,
                canGoNext: !data.selectedIncome.isEmpty,
                totalSteps: 4,
                onDirectionChange: onDirectionChange
            )
        }.navigationBarBackButtonHidden(true)
    }
}
