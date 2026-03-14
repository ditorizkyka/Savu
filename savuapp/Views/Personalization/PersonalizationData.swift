//
//  PersonalizationData.swift
//  savuapp
//
//  Created by Andito Rizkyka Rianto on 13/03/26.
//

import Foundation
import Combine

class PersonalizationData: ObservableObject {
    @Published var selectedAge: String = ""
    @Published var selectedIncome: String = ""
    @Published var selectedExpense: String = ""
}
