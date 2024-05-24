//
//  TransactionDetailView.swift
//  MoneyAnalytics
//
//  Created by Theo Tar on 23/05/2024.
//

// Импортируем необходимые модули. SwiftUI используется для создания пользовательского интерфейса.
import SwiftUI

// Экран деталей транзакции
struct TransactionDetailView: View {
    // Параметры для отображения суммы, категории и валюты
    let type: String  // Тип транзакции (доход или расход)
    let amount: Double  // Сумма транзакции
    let date: Date  // Дата транзакции
    let currency: String  // Валюта транзакции

    var body: some View {
        VStack {
            // Заголовок
            Text("Transaction Details")
                .font(.largeTitle)
                .padding()
            // Отображение типа транзакции
            Text("Type: \(type.capitalized)")
                .font(.title2)
                .padding()
            // Отображение суммы и валюты
            Text("Amount: \(amount, specifier: "%.2f") \(currency)")
                .font(.title)
                .padding()
            // Отображение даты
            Text("Date: \(date, style: .date) \(date, style: .time)")
                .font(.title2)
                .padding()
            Spacer()
        }
        .navigationBarTitle("Transaction Details", displayMode: .inline)
    }
}

struct TransactionDetailView_Previews: PreviewProvider {
    static var previews: some View {
        TransactionDetailView(type: "income", amount: 100.0, date: Date(), currency: "$")
    }
}
