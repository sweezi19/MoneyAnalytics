//
//  ContentView.swift
//  MoneyAnalytics
//
//  Created by Theo Tar on 17/05/2024.
//

// Импортируем необходимые модули. SwiftUI используется для создания пользовательского интерфейса, а SwiftData для работы с базой данных и моделями.
import SwiftUI
import SwiftData

struct ContentView: View {
    // Используем модельный контекст для работы с Core Data (или SwiftData)
    @Environment(\.modelContext) private var viewContext

    // Переменная для хранения баланса
    @State private var balance: Double = 0.0

    // Переменная для хранения выбранной валюты
    @State private var selectedCurrency: String = "$"

    // Переменная для управления отображением окна выбора валюты
    @State private var showCurrencyPicker = false

    // Запросы для получения данных о доходах и расходах из базы данных
    @Query var incomes: [Income]
    @Query var expenses: [Expense]

    // Переменные для управления отображением окон добавления доходов и расходов
    @State private var showAddIncome = false
    @State private var showAddExpense = false

    // Переменная для управления состоянием меню добавления
    @State private var isMenuOpen = false

    var body: some View {
        NavigationView {
            VStack {
                // Отображение текущего баланса
                Text("Balance: \(balance, specifier: "%.2f") \(selectedCurrency)")
                    .font(.largeTitle)
                    .padding()

                // Кнопки
                HStack {
                    if isMenuOpen {
                        // Кнопка для добавления доходов
                        Button(action: {
                            showAddIncome = true
                            isMenuOpen = false
                        }) {
                            Image(systemName: "arrow.down.circle")
                                .resizable()
                                .frame(width: 40, height: 40)
                                .foregroundColor(.green)
                                .padding(.trailing, 10)
                        }
                    }
                    // Кнопка (+)
                    Button(action: {
                        withAnimation {
                            isMenuOpen.toggle()
                        }
                    }) {
                        Image(systemName: "plus.circle.fill")
                            .resizable()
                            .frame(width: 50, height: 50)
                            .foregroundColor(isMenuOpen ? .red : .blue)
                            .rotationEffect(Angle(degrees: isMenuOpen ? 45 : 0))
                            .animation(.spring(), value: isMenuOpen)
                            .padding()
                    }

                    if isMenuOpen {
                        // Кнопка для добавления расходов
                        Button(action: {
                            showAddExpense = true
                            isMenuOpen = false
                        }) {
                            Image(systemName: "arrow.up.circle")
                                .resizable()
                                .frame(width: 40, height: 40)
                                .foregroundColor(.red)
                                .padding(.leading, 10)
                        }
                    }
                }

                // Отображение списка транзакций или сообщения об отсутствии транзакций
                if incomes.isEmpty && expenses.isEmpty {
                    Spacer()
                    Text("No transactions yet")
                        .font(.title)
                        .foregroundColor(.gray)
                    Spacer()
                } else {
                    List {
                        // Отображение доходов
                        ForEach(incomes) { income in
                            HStack {
                                Text("+\(income.amount, specifier: "%.2f") \(selectedCurrency)")
                                    .foregroundColor(.green)
                                Spacer()
                            }
                        }
                        .onDelete(perform: deleteIncome)

                        // Отображение расходов
                        ForEach(expenses) { expense in
                            NavigationLink(destination: ExpenseDetailView(amount: expense.amount, category: expense.category, currency: selectedCurrency)) {
                                HStack {
                                    Text("-\(expense.amount, specifier: "%.2f") \(selectedCurrency)")
                                        .foregroundColor(.red)
                                    Spacer()
                                }
                            }
                        }
                        .onDelete(perform: deleteExpense)
                    }
                }
            }
            // Установка заголовка навигационной панели
            .navigationBarTitle("Expense Tracker", displayMode: .inline)
            // Кнопка выбора валюты
            .navigationBarItems(trailing: Button(action: {
                showCurrencyPicker.toggle()
            }) {
                Text(selectedCurrency)
                    .font(.title2)
                    .padding()
            })
            .sheet(isPresented: $showCurrencyPicker) {
                // Отображение окна выбора валюты
                CurrencyPickerView(selectedCurrency: $selectedCurrency, showCurrencyPicker: $showCurrencyPicker, currencies: currencies)
            }
            .sheet(isPresented: $showAddIncome) {
                // Отображение окна добавления доходов
                AddIncomeView(balance: $balance)
            }
            .sheet(isPresented: $showAddExpense) {
                // Отображение окна добавления расходов
                AddExpenseView(balance: $balance)
            }
        }
    }

    // Удаление дохода и обновление баланса
    private func deleteIncome(at offsets: IndexSet) {
        for index in offsets {
            let income = incomes[index]
            balance -= income.amount  // Вычитаем сумму из баланса
            viewContext.delete(income)
        }
        do {
            try viewContext.save()
        } catch {
            print("Failed to delete income: \(error.localizedDescription)")
        }
    }

    // Удаление расхода и обновление баланса
    private func deleteExpense(at offsets: IndexSet) {
        for index in offsets {
            let expense = expenses[index]
            balance += expense.amount  // Возвращаем сумму на баланс
            viewContext.delete(expense)
        }
        do {
            try viewContext.save()
        } catch {
            print("Failed to delete expense: \(error.localizedDescription)")
        }
    }
}

struct CurrencyPickerView: View {
    // Привязка к выбранной валюте и состоянию отображения окна выбора валюты
    @Binding var selectedCurrency: String
    @Binding var showCurrencyPicker: Bool

    // Список валют
    let currencies: [(String, String)]

    var body: some View {
        NavigationView {
            List {
                ForEach(currencies, id: \.0) { currency in
                    Button(action: {
                        selectedCurrency = currency.0
                        showCurrencyPicker = false
                    }) {
                        HStack {
                            Text(currency.0)
                            Text(currency.1)
                                .foregroundColor(.gray)
                        }
                        .foregroundColor(currency.0 == selectedCurrency ? .blue : .primary)
                    }
                }
            }
            .navigationBarTitle("Select Currency", displayMode: .inline)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .modelContainer(for: [Income.self, Expense.self])
    }
}
