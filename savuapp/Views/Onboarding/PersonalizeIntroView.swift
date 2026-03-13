//
//  PersonalizeIntroView.swift
//  savuapp
//
//  Created by Andito Rizkyka Rianto on 13/03/26.
//

import SwiftUI

struct PersonalizeIntroView: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack(spacing: 50) {
            // Avatar placeholder
            Circle()
                .fill(Color(.systemGray4))
                .frame(width: 220, height: 220)
            
            VStack(spacing: 12) {
                Text("Let's Personalize Your Financial Experience")
                    .font(.system(size: 22, weight: .bold))
                    .multilineTextAlignment(.center)
                
                Text("Just a few quick questions will help SAVU create\nsmarter financial suggestions just for you.")
                    .font(.system(size: 14))
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
            }
            .padding(.horizontal, 32)
            
            NavigationLink(destination: PersonalizationContainerView()) {
                Text("Start Personalization")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 52)
                    .background(AppTheme.Colors.primary)
                    .cornerRadius(30)
                    .padding(.horizontal, 32)
            }
            .padding(.bottom, 48)
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button { dismiss() } label: {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.black)
                }
            }
        }
    }
}

#Preview {
    PersonalizeIntroView()
}
