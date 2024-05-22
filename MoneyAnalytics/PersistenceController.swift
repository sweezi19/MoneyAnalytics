//
//  PersistenceController.swift
//  MoneyAnalytics
//
//  Created by Theo Tar on 18/05/2024.
//

// Импортируем необходимые модули. Foundation предоставляет основные функциональные возможности для работы с данными и объектами, а SwiftData используется для работы с базой данных и моделями.
import Foundation
import SwiftData

// Класс для управления модельным контейнером данных
class PersistenceController {
    // Создание синглтона (единственного экземпляра класса)
    static let shared = PersistenceController()
    
    // Переменная для хранения контейнера моделей
    let container: ModelContainer
    
    // Приватный инициализатор для предотвращения создания новых экземпляров класса
    private init() {
        do {
            // Инициализация контейнера моделей с указанными типами моделей
            container = try ModelContainer(for: Income.self, Expense.self)
        } catch {
            // Обработка ошибки инициализации контейнера
            fatalError("Failed to initialize ModelContainer: \(error)")
        }
    }
}
