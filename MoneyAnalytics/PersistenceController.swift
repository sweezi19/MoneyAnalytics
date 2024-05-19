//
//  PersistenceController.swift
//  MoneyAnalytics
//
//  Created by Theo Tar on 18/05/2024.
//

import CoreData

struct PersistenceController {
    static let shared = PersistenceController()

    static var preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
        // Создание примеров данных для предпросмотра
        let newIncome = Income(context: viewContext)
        newIncome.amount = 1000.0

        let newExpense = Expense(context: viewContext)
        newExpense.amount = 200.0
        newExpense.category = "Food"

        let newMandatoryExpense = MandatoryExpense(context: viewContext)
        newMandatoryExpense.amount = 500.0
        newMandatoryExpense.category = "Rent"

        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }

        return result
    }()

    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "ExpenseTrackerModel")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores { (description, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
    }
}
