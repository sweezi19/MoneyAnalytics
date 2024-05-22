//
//  MoneyAnalyticsApp.swift
//  MoneyAnalytics
//
//  Created by Theo Tar on 17/05/2024.
//

// Импортируем необходимые модули. SwiftUI используется для создания пользовательского интерфейса, а SwiftData для работы с базой данных и моделями.
import SwiftUI
import SwiftData

@main
struct MoneyAnalyticsApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .modelContainer(for: [Income.self, Expense.self], inMemory: false)
        }
    }
}
