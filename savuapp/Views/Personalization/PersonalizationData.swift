//
//  PersonalizationViewModel.swift
//  savuapp
//
//  Created by Andito Rizkyka Rianto on 13/03/26.
//

import Foundation
import Combine

class PersonalizationViewModel: ObservableObject {
    @Published var username: String = ""
    @Published var email: String = ""
    @Published var selectedAge: String = ""
    @Published var selectedIncome: String = ""
    @Published var selectedExpense: String = ""
}
