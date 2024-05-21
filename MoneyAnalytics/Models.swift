//
//  Models.swift
//  MoneyAnalytics
//
//  Created by Theo Tar on 21/05/2024.
//

import Foundation
import SwiftData

@Model
class Income: Identifiable {
    var id: UUID = UUID()
    var amount: Double
    var category: String
    
    init(amount: Double, category: String) {
        self.amount = amount
        self.category = category
    }
}

@Model
class Expense: Identifiable {
    var id: UUID = UUID()
    var amount: Double
    var category: String
    
    init(amount: Double, category: String) {
        self.amount = amount
        self.category = category
    }
}
