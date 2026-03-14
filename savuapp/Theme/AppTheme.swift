//
//  AppTheme.swift
//  savuapp
//
//  Created by Andito Rizkyka Rianto on 13/03/26.
//

import SwiftUI

enum AppTheme {
    
    // MARK: - Colors
    enum Colors {
        // Primary States
        static let primary = Color(hex: "#014ce6")        // Primary (Main)
        static let primaryHover = Color(hex: "#0144cf")   // Normal :hover
        static let primaryActive = Color(hex: "#013db8")  // Normal :active
        
        // Light Variants (Cocok untuk background chat, alert, atau selected state)
        static let light = Color(hex: "#e6edfd")          // Light
        static let lightHover = Color(hex: "#d9e4fb")     // Light :hover
        static let lightActive = Color(hex: "#b0c8f7")    // Light :active
        
        // Dark Variants (Cocok untuk teks pada bg terang atau elemen penekanan)
        static let dark = Color(hex: "#0139ad")           // Dark
        static let darkHover = Color(hex: "#012e8a")      // Dark :hover
        static let darkActive = Color(hex: "#002267")     // Dark :active
        static let darker = Color(hex: "#001b51")         // Darker
        
        // UI Functional Colors — adaptive for dark mode
        static let background = Color(.systemBackground)
        static let textPrimary = Color(.label)
        static let textSecondary = Color(.secondaryLabel)
        static let textDisabled = Color(.tertiaryLabel)
        static let divider = Color(.separator)
        
        // Card / Surface background (white in light, elevated dark in dark)
        static let cardBackground = Color(.secondarySystemGroupedBackground)
        
        // Semantic Helpers menggunakan palette baru
        static let selectedBg = light                     // Menggunakan Light #e6edfd
        static let buttonDisabled = primary.opacity(0.35)
        static let grayButton = Color(.tertiarySystemFill)
    }
    
    // MARK: - Typography
    enum Typography {
        static let largeTitle = Font.system(size: 34, weight: .bold)
        static let title1 = Font.system(size: 28, weight: .bold)
        static let title2 = Font.system(size: 24, weight: .bold)
        static let title3 = Font.system(size: 22, weight: .bold)
        static let headline = Font.system(size: 17, weight: .semibold)
        static let body = Font.system(size: 16)
        static let bodyMedium = Font.system(size: 15)
        static let subheadline = Font.system(size: 14)
        static let caption = Font.system(size: 13)
        static let small = Font.system(size: 12)
    }
    
    // MARK: - Spacing
    enum Spacing {
        static let xs: CGFloat = 4
        static let sm: CGFloat = 8
        static let md: CGFloat = 12
        static let lg: CGFloat = 16
        static let xl: CGFloat = 20
        static let xxl: CGFloat = 24
        static let xxxl: CGFloat = 32
    }
    
    // MARK: - Radius
    enum Radius {
        static let sm: CGFloat = 8
        static let md: CGFloat = 10
        static let lg: CGFloat = 16
        static let button: CGFloat = 30
        static let card: CGFloat = 12
    }
    
    // MARK: - Button Height
    enum ButtonHeight {
        static let primary: CGFloat = 54
        static let secondary: CGFloat = 48
    }
}

// MARK: - Color Hex Extension
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let r, g, b, a: Double
        switch hex.count {
        case 6:
            (r, g, b, a) = (
                Double((int >> 16) & 0xFF) / 255,
                Double((int >> 8) & 0xFF) / 255,
                Double(int & 0xFF) / 255,
                1.0
            )
        case 8:
            (r, g, b, a) = (
                Double((int >> 24) & 0xFF) / 255,
                Double((int >> 16) & 0xFF) / 255,
                Double((int >> 8) & 0xFF) / 255,
                Double(int & 0xFF) / 255
            )
        default:
            (r, g, b, a) = (0, 0, 0, 1)
        }
        self.init(.sRGB, red: r, green: g, blue: b, opacity: a)
    }
}
