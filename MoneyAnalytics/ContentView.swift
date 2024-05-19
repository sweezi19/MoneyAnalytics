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

    @FetchRequest(
        entity: MandatoryExpense.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \MandatoryExpense.amount, ascending: true)]
    ) var mandatoryExpenses: FetchedResults<MandatoryExpense>

    @State private var showAddIncome = false
    @State private var showAddMandatoryExpense = false
    @State private var showAddExpense = false
    @State private var isMenuOpen = false

    var body: some View {
        NavigationView {
            VStack {
                Text("Current Balance: \(balance, specifier: "%.2f") $")
                    .font(.largeTitle)
                    .padding()

                Menu {
                    Button(action: {
                        showAddIncome = true
                        isMenuOpen = false
                    }) {
                        Text("Add Income")
                    }
                    Button(action: {
                        showAddMandatoryExpense = true
                        isMenuOpen = false
                    }) {
                        Text("Add Mandatory Expense")
                    }
                    Button(action: {
                        showAddExpense = true
                        isMenuOpen = false
                    }) {
                        Text("Add Expense")
                    }
                } label: {
                    Image(systemName: "plus.circle.fill")
                        .resizable()
                        .frame(width: 50, height: 50)
                        .foregroundColor(isMenuOpen ? .red : .blue)
                        .rotationEffect(Angle(degrees: isMenuOpen ? 45 : 0))
                        .animation(.spring(), value: isMenuOpen)
                        .onTapGesture {
                            isMenuOpen.toggle()
                        }
                        .padding()
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

                    ForEach(mandatoryExpenses, id: \.self) { expense in
                        NavigationLink(destination: ExpenseDetailView(amount: expense.amount, category: expense.category)) {
                            HStack {
                                Text("-\(expense.amount, specifier: "%.2f") $")
                                    .foregroundColor(.red)
                                Spacer()
                            }
                        }
                    }
                    .onDelete(perform: deleteMandatoryExpense)
                }
                .navigationBarItems(trailing: EditButton())
            }
            .navigationBarTitle("Expense Tracker", displayMode: .inline)
            .sheet(isPresented: $showAddIncome) {
                AddIncomeView(balance: $balance)
            }
            .sheet(isPresented: $showAddMandatoryExpense) {
                AddMandatoryExpenseView(balance: $balance)
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

    private func deleteMandatoryExpense(at offsets: IndexSet) {
        for index in offsets {
            let expense = mandatoryExpenses[index]
            balance += expense.amount  // Возвращаем сумму на баланс
            viewContext.delete(expense)
        }
        do {
            try viewContext.save()
        } catch {
            print("Failed to delete mandatory expense: \(error.localizedDescription)")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
