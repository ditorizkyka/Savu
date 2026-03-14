//
//  SuggestionEngine.swift
//  savuapp
//

import Foundation

@MainActor
final class SuggestionEngine {
    private let apiKey: String
    private let modelName = "gemini-2.5-flash"
    
    init() {
        self.apiKey = Config.geminiAPIKey
    }
    
    func generate(transactionStore: TransactionStore, userStore: UserStore) async throws -> [WrapCard] {
        if apiKey.isEmpty {
            throw NSError(domain: "SuggestionEngine", code: 1, userInfo: [NSLocalizedDescriptionKey: "Gemini API Key missing."])
        }
        
        // --- Validation: A (7-Day Summary) ---
        let calendar = Calendar.current
        let today = Date()
        let sevenDaysAgo = calendar.date(byAdding: .day, value: -7, to: today)!
        
        let last7DaysTx = transactionStore.transactions.filter {
            $0.date >= sevenDaysAgo && $0.date <= today
        }
        
        let weekIncome = last7DaysTx.filter { $0.type == .income }.reduce(0) { $0 + $1.amount }
        let weekExpense = last7DaysTx.filter { $0.type == .expenses }.reduce(0) { $0 + $1.amount }
        
        let categories = Dictionary(grouping: last7DaysTx.filter { $0.type == .expenses }, by: { $0.category })
            .mapValues { $0.reduce(0) { sum, tx in sum + tx.amount } }
            .sorted { $0.value > $1.value }
            .prefix(3)
            .map { "\($0.key) (Rp \($0.value))" }
            .joined(separator: ", ")
        
        let contextA = "In the last 7 days, the user spent Rp \(weekExpense), earned Rp \(weekIncome). Top expenses: \(categories.isEmpty ? "None" : categories)."
        
        // --- Validation: B (Personalization) ---
        let contextB = "User is \(userStore.selectedAge), earns \(userStore.selectedIncome), spends \(userStore.selectedExpense), archetype: \(userStore.spendingTagline)."
        
        // --- Validation: C (Today's Logs) ---
        let todaysTx = transactionStore.transactions.filter {
            calendar.isDate($0.date, inSameDayAs: today)
        }
        
        // Ensure not empty
        if todaysTx.isEmpty {
            return [] // Abort if no transactions today
        }
        
        let todaysLogs = todaysTx.map { "\($0.formattedTime) - \($0.title) (\($0.category)): \($0.type == .income ? "+" : "-")Rp \($0.amount)" }
            .joined(separator: "\n")
        let contextC = "Today's log:\n\(todaysLogs)"
        
        // --- Construct Prompt (D & E) ---
        let prompt = """
        You are a financial advisor AI inside a budgeting app. Generate exactly 3 to 5 financial insights for the user's "Today's Wrap" based on the following data.
        Make the tone encouraging but realistic. Output MUST be valid JSON matching this exact structure:
        {
          "insights": [
            {
              "title": "Short Catchy Title",
              "amount": "Rp X (if applicable, else null)",
              "description": "2-sentence insightful breakdown.",
              "colorTheme": "warning" // choose from: warning, positive, info, neutral
            }
          ]
        }
        
        [DATA]
        \(contextA)
        \(contextB)
        \(contextC)
        """
        
        // --- Call Gemini REST API ---
        guard let url = URL(string: "https://generativelanguage.googleapis.com/v1beta/models/\(modelName):generateContent?key=\(apiKey)") else {
            throw NSError(domain: "SuggestionEngine", code: 2, userInfo: [NSLocalizedDescriptionKey: "Invalid API URL"])
        }
        
        // Construct Request Body
        let requestBody: [String: Any] = [
            "contents": [
                [
                    "parts": [
                        ["text": prompt]
                    ]
                ]
            ],
            "generationConfig": [
                "responseMimeType": "application/json"
            ]
        ]
        
        let jsonData = try JSONSerialization.data(withJSONObject: requestBody)
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NSError(domain: "SuggestionEngine", code: 3, userInfo: [NSLocalizedDescriptionKey: "Invalid HTTP Response"])
        }
        
        if httpResponse.statusCode != 200 {
            let errorMsg = String(data: data, encoding: .utf8) ?? "Unknown Error"
            throw NSError(domain: "SuggestionEngine", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: "API Error: \(errorMsg)"])
        }
        
        // Parse the Gemini REST Response Wrapper
        let wrappedResponse = try JSONDecoder().decode(GeminiRESTResponse.self, from: data)
        guard let text = wrappedResponse.candidates.first?.content.parts.first?.text else {
            throw NSError(domain: "SuggestionEngine", code: 5, userInfo: [NSLocalizedDescriptionKey: "No text in response"])
        }
        
        // Parse the actual JSON payload we requested
        var jsonString = text.trimmingCharacters(in: .whitespacesAndNewlines)
        if jsonString.hasPrefix("```json") {
            jsonString = String(jsonString.dropFirst(7))
            if jsonString.hasSuffix("```") {
                jsonString = String(jsonString.dropLast(3))
            }
        }
        
        guard let payloadData = jsonString.data(using: .utf8) else {
            throw NSError(domain: "SuggestionEngine", code: 4, userInfo: [NSLocalizedDescriptionKey: "Failed to parse JSON text into data"])
        }
        
        let geminiResponse = try JSONDecoder().decode(GeminiResponse.self, from: payloadData)
        
        // --- Map to WrapCards ---
        return geminiResponse.insights.map { insight in
            WrapCard(
                title: insight.title,
                amount: insight.amount ?? "",
                description: insight.description,
                rawColors: insight.rawColors
            )
        }
    }
}

// MARK: - REST API Response Models
struct GeminiRESTResponse: Codable {
    let candidates: [GeminiCandidate]
}

struct GeminiCandidate: Codable {
    let content: GeminiContent
}

struct GeminiContent: Codable {
    let parts: [GeminiPart]
}

struct GeminiPart: Codable {
    let text: String
}
