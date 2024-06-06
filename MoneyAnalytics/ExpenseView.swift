//
//  ExpenseView.swift
//  MoneyAnalytics
//
//  Created by Theo Tar on 26/05/2024.
//

import SwiftUI

// Вид для отображения расходов
struct ExpenseView: View {
    var expenses: [Expense]
    @Binding var selectedCurrency: String

    var body: some View {
        VStack {
            if expenses.isEmpty {
                Spacer()
                Text("No expenses yet")
                    .font(.title)
                    .foregroundColor(.gray)
                Spacer()
            } else {
                ScrollView {
                    ExpenseBarChart(expenses: expenses)
                        .padding()
                }

                List {
                    ForEach(expenses.groupedByCategory.keys.sorted(), id: \.self) { category in
                        NavigationLink(destination: CategoryDetailView(expenses: expenses.filter { $0.category == category }, category: category, selectedCurrency: $selectedCurrency)) {
                            HStack {
                                Text(category.capitalized)
                                Spacer()
                                Text("\(expenses.filter { $0.category == category }.map { $0.amount }.reduce(0, +), specifier: "%.2f") \(selectedCurrency)")
                            }
                        }
                    }
                }
            }
        }
        .navigationBarTitle("Expenses", displayMode: .inline)
    }
}

// Вид для отображения горизонтальной шкалы расходов
struct ExpenseBarChart: View {
    var expenses: [Expense]

    var body: some View {
        VStack(alignment: .leading) {
            let totalExpenses = expenses.reduce(0) { $0 + $1.amount }
            ForEach(expenses.groupedByCategory.keys.sorted(), id: \.self) { category in
                let categoryTotal = expenses.filter { $0.category == category }.map { $0.amount }.reduce(0, +)
                let percentage = (categoryTotal / totalExpenses) * 100

                VStack(alignment: .leading) {
                    HStack {
                        Text(category.capitalized)
                            .font(.headline)
                        Spacer()
                        Text("\(percentage, specifier: "%.2f")%")
                            .font(.subheadline)
                    }
                    .padding(.bottom, 2)

                    GeometryReader { geometry in
                        HStack {
                            Rectangle()
                                .fill(Color.blue)
                                .frame(width: geometry.size.width * CGFloat(categoryTotal / totalExpenses), height: 10)
//                                .cornerRadius(5)
                            Spacer()
                        }
                    }
                    .frame(height: 1)
                }
                .padding(.bottom, 10)
            }
        }
        .padding(.horizontal)
    }
}

// Вид для отображения расходов по категории
struct CategoryDetailView: View {
    var expenses: [Expense]
    var category: String
    @Binding var selectedCurrency: String

    var body: some View {
        List {
            ForEach(expenses, id: \.id) { expense in
                NavigationLink(destination: TransactionDetailView(type: "expense", amount: expense.amount, date: expense.date, currency: selectedCurrency)) {
                    HStack {
                        Text(expense.date, style: .date)
                        Spacer()
                        Text("-\(expense.amount, specifier: "%.2f") \(selectedCurrency)")
                            .foregroundColor(.red)
                    }
                }
            }
        }
        .navigationBarTitle(category.capitalized, displayMode: .inline)
    }
}

// Расширение для группировки массива расходов по категории
extension Array where Element == Expense {
    var groupedByCategory: [String: [Expense]] {
        Dictionary(grouping: self, by: { $0.category })
    }
}

struct ExpenseView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ExpenseView(expenses: [
                Expense(amount: 50, category: "food"),
                Expense(amount: 100, category: "transport"),
                Expense(amount: 30, category: "entertainment"),
                Expense(amount: 80, category: "food"),
                Expense(amount: 80, category: "dev"),
                Expense(amount: 80, category: "wvwv"),
                Expense(amount: 80, category: "we"),
                Expense(amount: 80, category: "qd"),
                Expense(amount: 70, category: "tax"),
                Expense(amount: 80, category: "ed"),
            ], selectedCurrency: .constant("$"))
        }
    }
}
