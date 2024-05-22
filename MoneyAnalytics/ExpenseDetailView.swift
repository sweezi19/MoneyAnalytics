//
//  ExpenseDetailView.swift
//  MoneyAnalytics
//
//  Created by Theo Tar on 18/05/2024.
//

// Импортируем необходимый модуль SwiftUI для создания пользовательского интерфейса.
import SwiftUI

// Экран деталей расхода
struct ExpenseDetailView: View {
    // Параметры для отображения суммы, категории и валюты
    let amount: Double  // Добавлен параметр для выбранной суммы
    let category: String  // Добавлен параметр для выбранной категории
    let currency: String  // Добавлен параметр для выбранной валюты

    var body: some View {
        VStack {
            // Заголовок
//            Text("Expense Details")
//                .font(.largeTitle)
//                .padding()
            // Отображение суммы и валюты
            Text("Amount: \(amount, specifier: "%.2f") \(currency)")
                .font(.title)
                .padding()
            // Отображение категории
            Text("Category: \(category)")
                .font(.title2)
                .padding()
            Spacer()
        }
        // Установка заголовка навигационной панели
        .navigationBarTitle("Expense Details", displayMode: .inline)
    }
}

// Структура для предварительного просмотра представления
struct ExpenseDetailView_Previews: PreviewProvider {
    static var previews: some View {
        // Создаем предварительный просмотр для ExpenseDetailView, передавая фиктивные значения для суммы, категории и валюты.
        ExpenseDetailView(amount: 100.0, category: "Food", currency: "$")
    }
}
