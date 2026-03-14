//
//  Config.swift
//  savuapp
//

import Foundation

enum Config {
    static var geminiAPIKey: String {
        guard let url = Bundle.main.url(forResource: "Secrets", withExtension: "plist"),
              let data = try? Data(contentsOf: url),
              let dict = try? PropertyListSerialization.propertyList(from: data, options: [], format: nil) as? [String: Any],
              let key = dict["GEMINI_API_KEY"] as? String,
              key != "YOUR_API_KEY_HERE" && !key.isEmpty else {
            print("⚠️ WARNING: Gemini API Key is missing from Secrets.plist")
            return ""
        }
        return key
    }
}
