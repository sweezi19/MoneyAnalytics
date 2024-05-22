//
//  Models.swift
//  MoneyAnalytics
//
//  Created by Theo Tar on 21/05/2024.
//

// Импортируем необходимые модули. Foundation предоставляет основные функциональные возможности для работы с данными и объектами, а SwiftData используется для работы с базой данных и моделями.
import Foundation
import SwiftData

// Аннотация @Model указывает, что класс является моделью данных, которую можно использовать с SwiftData для управления данными.
@Model
class Income: Identifiable {
    // Переменная id представляет собой уникальный идентификатор для каждого дохода. UUID генерируется автоматически при создании нового объекта дохода.
    var id: UUID = UUID()
    // Переменная amount представляет собой сумму дохода.
    var amount: Double
    // Переменная category представляет собой категорию дохода.
    var category: String
    
    // Инициализатор класса Income, который принимает два параметра: amount (сумма дохода) и category (категория дохода), и инициализирует соответствующие свойства.
    init(amount: Double, category: String) {
        self.amount = amount
        self.category = category
    }
}

@Model
class Expense: Identifiable {
    // Переменная id представляет собой уникальный идентификатор для каждого расхода. UUID генерируется автоматически при создании нового объекта расхода.
    var id: UUID = UUID()
    // Переменная amount представляет собой сумму расхода.
    var amount: Double
    // Переменная category представляет собой категорию расхода.
    var category: String
    
    // Инициализатор класса Expense, который принимает два параметра: amount (сумма расхода) и category (категория расхода), и инициализирует соответствующие свойства.
    init(amount: Double, category: String) {
        self.amount = amount
        self.category = category
    }
}
