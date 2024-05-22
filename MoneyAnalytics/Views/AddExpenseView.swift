//
//  AddExpenseView.swift
//  MoneyAnalytics
//
//  Created by Theo Tar on 17/05/2024.
//

// Импортируем необходимые модули. SwiftUI используется для создания пользовательского интерфейса, а SwiftData для работы с базой данных и моделями.
import SwiftUI
import SwiftData

// Экран для добавления нового расхода
struct AddExpenseView: View {
    // Используем модельный контекст для работы с базой данных.
    @Environment(\.modelContext) private var viewContext
    
    // Управление режимом представления для закрытия представления после сохранения данных.
    @Environment(\.presentationMode) var presentationMode
    
    // Привязка к переменной баланса из родительского представления для обновления баланса после добавления расхода.
    @Binding var balance: Double
    
    // Переменная для хранения суммы расхода, введенной пользователем.
    @State private var expense: String = ""
    
    // Переменная для хранения выбранной категории расхода.
    @State private var selectedCategory = "transport"
    
    // Список категорий расходов.
    let categories = ["transport", "food", "subscriptions", "entertainment", "bills", "rent", "tax", "tickets", "clothes", "transfers", "other"]
    
    var body: some View {
        VStack {
            // Поле ввода суммы расхода.
            TextField("Enter expense amount", text: $expense)
                .keyboardType(.decimalPad)
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            // Выпадающий список для выбора категории расхода.
            Picker("Category", selection: $selectedCategory) {
                ForEach(categories, id: \.self) {
                    Text($0.capitalized)
                }
            }
            .pickerStyle(WheelPickerStyle())
            .padding()
            
            // Кнопка для сохранения расхода.
            Button(action: {
                // Проверка, что введенное значение является числом.
                if let expenseValue = Double(expense) {
                    // Обновление баланса после добавления расхода.
                    balance -= expenseValue
                    // Создание нового объекта расхода.
                    let newExpense = Expense(amount: expenseValue, category: selectedCategory)
                    // Вставка нового расхода в контекст.
                    viewContext.insert(newExpense)
                    do {
                        // Сохранение контекста.
                        try viewContext.save()
                        print("Expense saved: \(expenseValue), category: \(selectedCategory)")
                        // Закрытие представления после сохранения данных.
                        self.presentationMode.wrappedValue.dismiss()
                    } catch {
                        print("Failed to save expense: \(error.localizedDescription)")
                    }
                } else {
                    print("Invalid expense value")
                }
                // Очистка поля ввода.
                expense = ""
            }) {
                Text("Save Expense")
                    .font(.title2)
                    .padding()
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding()
            
            // Добавление пространства для выравнивания элементов в представлении.
            Spacer()
        }
        .padding()
        // Установка заголовка навигационной панели.
        .navigationBarTitle("Add Expense", displayMode: .inline)
    }
}

// Структура для предварительного просмотра представления
struct AddExpenseView_Previews: PreviewProvider {
    static var previews: some View {
        // Создаем предварительный просмотр для AddExpenseView, передавая фиктивное значение для баланса.
        AddExpenseView(balance: .constant(1000.0))
            // Указываем модельный контейнер для предварительного просмотра, чтобы SwiftUI знал, какие модели данных используются.
            .modelContainer(for: [Expense.self])
    }
}
