//
//  AddIncomeView.swift
//  MoneyAnalytics
//
//  Created by Theo Tar on 17/05/2024.
//

import SwiftUI
import CoreData

struct AddIncomeView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.presentationMode) var presentationMode
    @Binding var balance: Double
    @State private var income: String = ""
    @State private var selectedCategory = "Salary"
    
    let categories = ["Salary", "Transfers"]

    var body: some View {
        NavigationView {
            VStack {
                TextField("Enter income amount", text: $income)
                    .keyboardType(.decimalPad)
                    .padding()
                    .textFieldStyle(RoundedBorderTextFieldStyle())

                Picker("Category", selection: $selectedCategory) {
                    ForEach(categories, id: \.self) { category in
                        Text(category)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()

                Button(action: {
                    if let incomeValue = Double(income) {
                        balance += incomeValue
                        let newIncome = Income(context: viewContext)
                        newIncome.amount = incomeValue
                        newIncome.category = selectedCategory
                        do {
                            try viewContext.save()
                            print("Income saved: \(incomeValue)")
                            self.presentationMode.wrappedValue.dismiss()
                        } catch {
                            print("Failed to save income: \(error.localizedDescription)")
                        }
                    } else {
                        print("Invalid income value")
                    }
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

                Spacer()
            }
            .padding()
            .navigationBarTitle("Add Income", displayMode: .inline)
        }
    }
}
