//
//  AddIncomeView.swift
//  MoneyAnalytics
//
//  Created by Theo Tar on 17/05/2024.
//

// Импортируем необходимые модули. SwiftUI используется для создания пользовательского интерфейса, а SwiftData для работы с базой данных и моделями.
import SwiftUI
import SwiftData

// Экран для добавления нового дохода
struct AddIncomeView: View {
    // Используем модельный контекст для работы с базой данных.
    @Environment(\.modelContext) private var viewContext
    
    // Управление режимом представления для закрытия представления после сохранения данных.
    @Environment(\.presentationMode) var presentationMode
    
    // Привязка к переменной баланса из родительского представления для обновления баланса после добавления дохода.
    @Binding var balance: Double
    
    // Переменная для хранения суммы дохода, введенной пользователем.
    @State private var income: String = ""
    
    // Переменная для хранения выбранной категории дохода.
    @State private var selectedCategory = "salary"
    
    // Список категорий доходов.
    let categories = ["salary", "transfers"]
    
    var body: some View {
        VStack {
            // Поле ввода суммы дохода.
            TextField("Enter income amount", text: $income)
                .keyboardType(.decimalPad)
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            // Выпадающий список для выбора категории дохода.
            Picker("Category", selection: $selectedCategory) {
                ForEach(categories, id: \.self) {
                    Text($0.capitalized)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()
            
            // Кнопка для сохранения дохода.
            Button(action: {
                // Проверка, что введенное значение является числом.
                if let incomeValue = Double(income) {
                    // Обновление баланса после добавления дохода.
                    balance += incomeValue
                    // Создание нового объекта дохода.
                    let newIncome = Income(amount: incomeValue, category: selectedCategory)
                    // Вставка нового дохода в контекст.
                    viewContext.insert(newIncome)
                    do {
                        // Сохранение контекста.
                        try viewContext.save()
                        print("Income saved: \(incomeValue), category: \(selectedCategory)")
                        // Закрытие представления после сохранения данных.
                        self.presentationMode.wrappedValue.dismiss()
                    } catch {
                        print("Failed to save income: \(error.localizedDescription)")
                    }
                } else {
                    print("Invalid income value")
                }
                // Очистка поля ввода.
                income = ""
            }) {
                Text("Save Income")
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
        .navigationBarTitle("Add Income", displayMode: .inline)
    }
}

// Структура для предварительного просмотра представления
struct AddIncomeView_Previews: PreviewProvider {
    static var previews: some View {
        // Создаем предварительный просмотр для AddIncomeView, передавая фиктивное значение для баланса.
        AddIncomeView(balance: .constant(1000.0))
            // Указываем модельный контейнер для предварительного просмотра, чтобы SwiftUI знал, какие модели данных используются.
            .modelContainer(for: [Income.self])
    }
}
