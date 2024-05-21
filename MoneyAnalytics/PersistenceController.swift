//
//  PersistenceController.swift
//  MoneyAnalytics
//
//  Created by Theo Tar on 18/05/2024.
//

import Foundation
import SwiftData

class PersistenceController {
    static let shared = PersistenceController()
    
    let container: ModelContainer
    
    private init() {
        do {
            container = try ModelContainer(for: Income.self, Expense.self)
        } catch {
            fatalError("Failed to initialize ModelContainer: \(error)")
        }
    }
}
