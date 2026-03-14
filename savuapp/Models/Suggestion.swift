//
//  Suggestion.swift
//  savuapp
//

// MARK: - Imports
import Foundation
import SwiftData

// MARK: - Protocol (if applicable)

// MARK: - Main Type Declaration

enum SuggestionType: String, Codable {
    case warning
    case insight
    case tip
    case goal
}

@Model
final class Suggestion {
    
    // MARK: - Properties
    
    var id: UUID
    var title: String
    var message: String
    var type: SuggestionType
    var isRead: Bool
    var relatedCashflowId: UUID?
    var createdAt: Date
    var lastModifiedAt: Date
    
    // MARK: - Initializer
    
    init(
        id: UUID = UUID(),
        title: String,
        message: String,
        type: SuggestionType,
        isRead: Bool = false,
        relatedCashflowId: UUID? = nil
    ) {
        self.id = id
        self.title = title
        self.message = message
        self.type = type
        self.isRead = isRead
        self.relatedCashflowId = relatedCashflowId
        
        let now = Date()
        self.createdAt = now
        self.lastModifiedAt = now
    }
}
