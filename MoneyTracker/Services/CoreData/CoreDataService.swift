//
//  CoreDataService.swift
//  MoneyTracker
//
//  Created by Roman Korobskoy on 15.11.2022.
//

import CoreData
import SwiftUI

final class CoreDataService: ObservableObject {
    private let viewContext = PersistenceController.shared.container.viewContext

    func addItem() {
        let card = Card(context: viewContext)
        card.timestamp = Date()

        do {
            try viewContext.save()
        } catch {
            print(error)
        }
    }

    func saveItem(name: String,
                  number: String,
                  limit: String,
                  type: String,
                  month: Int,
                  year: Int,
                  timestamp: Date,
                  balance: String,
                  color: Color) {
        let card = Card(context: viewContext)

        card.name = name
        card.number = number
        card.limit = Int32(limit) ?? 0
        card.expMonth = Int16(month)
        card.expYear = Int16(year)
        card.timestamp = timestamp
        card.balance = Int64(balance) ?? 0
        card.color = UIColor(color).encode()

        do {
            try viewContext.save()
        } catch {
            print(error)
        }
    }

    func deleteAllItems(_ cards: FetchedResults<Card>) {
        cards.forEach { card in
            viewContext.delete(card)
        }

        do {
            try viewContext.save()
        } catch {
            print(error)
        }
    }
}
