//
//  OptionRowView.swift
//  savuapp
//
//  Created by Andito Rizkyka Rianto on 13/03/26.
//
import SwiftUI

struct OptionRowView: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Text(title)
                    .font(.system(size: 15))
                    .foregroundColor(isSelected ? AppTheme.Colors.primary : .black)
                Spacer()
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
            .background(isSelected ? AppTheme.Colors.primary.opacity(0.08) : Color.clear)
        }
    }
}
