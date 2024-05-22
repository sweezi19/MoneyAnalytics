//
//  ContentView.swift
//  MoneyAnalytics
//
//  Created by Theo Tar on 17/05/2024.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var viewContext
    @State private var balance: Double = 0.0
    @State private var selectedCurrency: String = "$"
    @State private var showCurrencyPicker = false

    @Query var incomes: [Income]
    @Query var expenses: [Expense]

    @State private var showAddIncome = false
    @State private var showAddExpense = false
    @State private var isMenuOpen = false

    var body: some View {
        NavigationView {
            VStack {
                Text("Balance: \(balance, specifier: "%.2f") \(selectedCurrency)")
                    .font(.largeTitle)
                    .padding()

                HStack {
                    if isMenuOpen {
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

                if incomes.isEmpty && expenses.isEmpty {
                    Spacer()
                    Text("No transactions yet")
                        .font(.title)
                        .foregroundColor(.gray)
                    Spacer()
                } else {
                    List {
                        ForEach(incomes) { income in
                            HStack {
                                Text("+\(income.amount, specifier: "%.2f") \(selectedCurrency)")
                                    .foregroundColor(.green)
                                Spacer()
                            }
                        }
                        .onDelete(perform: deleteIncome)

                        ForEach(expenses) { expense in
                            NavigationLink(destination: ExpenseDetailView(amount: expense.amount, category: expense.category)) {
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
            .navigationBarTitle("Expense Tracker", displayMode: .inline)
            .navigationBarItems(trailing: Button(action: {
                showCurrencyPicker.toggle()
            }) {
                Text(selectedCurrency)
                    .font(.title2)
                    .padding()
                    .cornerRadius(8)
            })
            .sheet(isPresented: $showCurrencyPicker) {
                CurrencyPickerView(selectedCurrency: $selectedCurrency, showCurrencyPicker: $showCurrencyPicker, currencies: currencies)
            }
            .sheet(isPresented: $showAddIncome) {
                AddIncomeView(balance: $balance)
            }
            .sheet(isPresented: $showAddExpense) {
                AddExpenseView(balance: $balance)
            }
        }
    }

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
    @Binding var selectedCurrency: String
    @Binding var showCurrencyPicker: Bool
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
