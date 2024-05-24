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

                // Кнопки для добавления доходов и расходов
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
                    // Используем List для поддержки свайпа для удаления
                    List {
                        // Объединяем доходы и расходы в один список
                        let transactions = (incomes.map { ("income", $0.date, $0.amount, $0.id) } + expenses.map { ("expense", $0.date, $0.amount, $0.id) })
                            .sorted(by: { $0.1 > $1.1 })

                        ForEach(transactions, id: \.3) { transaction in
                            NavigationLink(destination: TransactionDetailView(type: transaction.0, amount: transaction.2, date: transaction.1, currency: selectedCurrency)) {
                                HStack {
                                    if transaction.0 == "income" {
                                        Text("+\(transaction.2, specifier: "%.2f") \(selectedCurrency)")
                                            .foregroundColor(.green)
                                    } else {
                                        Text("-\(transaction.2, specifier: "%.2f") \(selectedCurrency)")
                                            .foregroundColor(.red)
                                    }
                                    Spacer()
                                    Text(transaction.1, style: .date)
                                }
                            }
                            // Добавляем свайп действия для удаления транзакции
                            .swipeActions {
                                Button(role: .destructive) {
                                    deleteTransaction(type: transaction.0, id: transaction.3, amount: transaction.2)
                                } label: {
                                    Label("Delete", systemImage: "trash")
                                }
                            }
                        }
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

    // Удаление транзакции и обновление баланса
    private func deleteTransaction(type: String, id: UUID, amount: Double) {
        if type == "income" {
            if let income = incomes.first(where: { $0.id == id }) {
                balance -= income.amount  // Вычитаем сумму из баланса
                viewContext.delete(income)
            }
        } else {
            if let expense = expenses.first(where: { $0.id == id }) {
                balance += expense.amount  // Возвращаем сумму на баланс
                viewContext.delete(expense)
            }
        }
        do {
            try viewContext.save()
        } catch {
            print("Failed to delete transaction: \(error.localizedDescription)")
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
