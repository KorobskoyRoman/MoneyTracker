//
//  Persistence.swift
//  MoneyTracker
//
//  Created by Roman Korobskoy on 11.11.2022.
//

import CoreData
import UIKit

struct PersistenceController {
    static let shared = PersistenceController()
    static let hasSeedDataKey = "hasSeedDataKey"

    static var preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
        for _ in 0..<10 {
            let newItem = Item(context: viewContext)
            newItem.timestamp = Date()
        }
        do {
            try viewContext.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        return result
    }()

    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "MoneyTracker")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.

                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        container.viewContext.automaticallyMergesChangesFromParent = true

        seedInitialData()
    }

    private func seedInitialData() {
        guard UserDefaults.standard.bool(forKey: Self.hasSeedDataKey) else {
            let context = container.viewContext
            let cat = TransactionCategory(context: context)
            cat.name = "Продукты питания"
            cat.colorData = UIColor.blue.encode()
            cat.timestamp = Date()

            do {
                try context.save()
                UserDefaults.standard.set(true, forKey: Self.hasSeedDataKey)
            } catch {
                print(error)
            }
            return
        }
    }
}
