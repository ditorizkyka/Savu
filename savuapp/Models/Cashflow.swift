//
//  Cashflow.swift
//  savuapp
//

// MARK: - Imports
import Foundation
import SwiftData

// MARK: - Protocol (if applicable)

// MARK: - Main Type Declaration

enum CashflowTransactionType: String, Codable {
    case income
    case expense
}

@Model
final class Cashflow {
    
    // MARK: - Properties
    
    var id: UUID
    var amount: Double
    var type: CashflowTransactionType
    var category: String
    var note: String
    var date: Date
    var createdAt: Date
    var lastModifiedAt: Date
    
    // MARK: - Initializer
    
    init(
        id: UUID = UUID(),
        amount: Double,
        type: CashflowTransactionType,
        category: String,
        note: String = "",
        date: Date = Date()
    ) {
        self.id = id
        self.amount = amount
        self.type = type
        self.category = category
        self.note = note
        self.date = date
        
        let now = Date()
        self.createdAt = now
        self.lastModifiedAt = now
    }
}
