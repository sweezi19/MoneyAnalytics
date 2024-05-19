//
//  AddExpenseView.swift
//  MoneyAnalytics
//
//  Created by Theo Tar on 17/05/2024.
//

import SwiftUI
import CoreData

struct AddExpenseView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.presentationMode) var presentationMode
    @State private var expense: String = ""
    @State private var selectedCategory = "Transport"
    @Binding var balance: Double
    
    let categories = ["Transport", "Food", "Subscriptions", "Entertainment", "Bills", "Rent", "Tax", "Tickets", "Clothes", "Transfers", "Other"]

    var body: some View {
        NavigationView {
            VStack {
                TextField("Enter expense amount", text: $expense)
                    .keyboardType(.decimalPad)
                    .padding()
                    .textFieldStyle(RoundedBorderTextFieldStyle())

                Picker("Category", selection: $selectedCategory) {
                    ForEach(categories, id: \.self) { category in
                        Text(category)
                    }
                }
                .pickerStyle(WheelPickerStyle())
                .padding()

                Button(action: {
                    if let expenseValue = Double(expense) {
                        balance -= expenseValue  // Вычитаем сумму из баланса
                        let newExpense = Expense(context: viewContext)
                        newExpense.amount = expenseValue
                        newExpense.category = selectedCategory
                        do {
                            try viewContext.save()
                            print("Expense saved: \(expenseValue), category: \(selectedCategory)")
                            self.presentationMode.wrappedValue.dismiss()
                        } catch {
                            print("Failed to save expense: \(error.localizedDescription)")
                        }
                    } else {
                        print("Invalid expense value")
                    }
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

                Spacer()
            }
            .padding()
            .navigationBarTitle("Add Expense", displayMode: .inline)
        }
    }
}
