//
//  ContentView.swift
//  MoneyAnalytics
//
//  Created by Theo Tar on 17/05/2024.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @State private var balance: Double = 0.0

    @FetchRequest(
        entity: Income.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \Income.amount, ascending: true)]
    ) var incomes: FetchedResults<Income>

    @FetchRequest(
        entity: Expense.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \Expense.amount, ascending: true)]
    ) var expenses: FetchedResults<Expense>

    @State private var showAddIncome = false
    @State private var showAddExpense = false
    @State private var isMenuOpen = false

    var body: some View {
        NavigationView {
            VStack {
                Text("Current Balance: \(balance, specifier: "%.2f") $")
                    .font(.largeTitle)
                    .padding()

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
                    VStack(spacing: 10) {
                        Button(action: {
                            showAddIncome = true
                            isMenuOpen = false
                        }) {
                            Text("Add Income")
                                .font(.title2)
                                .padding()
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }

                        Button(action: {
                            showAddExpense = true
                            isMenuOpen = false
                        }) {
                            Text("Add Expense")
                                .font(.title2)
                                .padding()
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                    }
                    .transition(.opacity)
                }

                List {
                    ForEach(incomes, id: \.self) { income in
                        HStack {
                            Text("+\(income.amount, specifier: "%.2f") $")
                                .foregroundColor(.green)
                            Spacer()
                        }
                    }
                    .onDelete(perform: deleteIncome)

                    ForEach(expenses, id: \.self) { expense in
                        NavigationLink(destination: ExpenseDetailView(amount: expense.amount, category: expense.category)) {
                            HStack {
                                Text("-\(expense.amount, specifier: "%.2f") $")
                                    .foregroundColor(.red)
                                Spacer()
                            }
                        }
                    }
                    .onDelete(perform: deleteExpense)
                }
                .navigationBarItems(trailing: EditButton())
            }
            .navigationBarTitle("Expense Tracker", displayMode: .inline)
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

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
