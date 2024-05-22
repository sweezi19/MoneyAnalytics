//
//  ExpenseDetailView.swift
//  MoneyAnalytics
//
//  Created by Theo Tar on 18/05/2024.
//

import SwiftUI

struct ExpenseDetailView: View {
    var amount: Double
    var category: String?
    
    var body: some View {
        VStack {
            // Отображение суммы и валюты
            Text("Amount: \(amount, specifier: "%.2f") \(currency)")
                .font(.title)
                .padding()
            
            if let category = category {
                Text("Category: \(category)")
                    .font(.title2)
                    .padding()
            } else {
                Text("Category: N/A")
                    .font(.title2)
                    .padding()
            }
            
            Spacer()
        }
        .padding()
        .navigationBarTitle("Details", displayMode: .inline)
    }
}

struct ExpenseDetailView_Previews: PreviewProvider {
    static var previews: some View {
        ExpenseDetailView(amount: 100.0, category: "Food")
    }
}

