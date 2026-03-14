//
//  GeminiResponse.swift
//  savuapp
//

import Foundation
import SwiftUI

struct GeminiResponse: Codable {
    let insights: [GeminiInsight]
}

struct GeminiInsight: Codable {
    let title: String
    let amount: String?
    let description: String
    let colorTheme: String // "warning", "positive", "neutral", "info"
    
    // Map the string theme to raw color names for WrapCard
    var rawColors: [String] {
        switch colorTheme.lowercased() {
        case "warning":
            return ["orange", "red"]
        case "positive":
            return ["teal", "green"]
        case "info":
            return ["purple", "blue"]
        default:
            return ["blue", "black"]
        }
    }
}
