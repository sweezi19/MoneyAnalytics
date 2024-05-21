//
//  AddExpenseView.swift
//  MoneyAnalytics
//
//  Created by Theo Tar on 17/05/2024.
//

import SwiftUI
import SwiftData

struct AddExpenseView: View {
    @Environment(\.modelContext) private var viewContext
    @Environment(\.presentationMode) var presentationMode
    @Binding var balance: Double
    @State private var expense: String = ""
    @State private var selectedCategory = "transport"

    let categories = ["transport", "food", "subscriptions", "entertainment", "bills", "rent", "tax", "tickets", "clothes", "transfers", "other"]

    var body: some View {
        VStack {
            TextField("Enter expense amount", text: $expense)
                .keyboardType(.decimalPad)
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())

            Picker("Category", selection: $selectedCategory) {
                ForEach(categories, id: \.self) {
                    Text($0.capitalized)
                }
            }
            .pickerStyle(WheelPickerStyle())
            .padding()

            Button(action: {
                if let expenseValue = Double(expense) {
                    balance -= expenseValue
                    let newExpense = Expense(amount: expenseValue, category: selectedCategory)
                    viewContext.insert(newExpense)
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
