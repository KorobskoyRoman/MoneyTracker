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

    // MARK: - Cards
    func addItem() {
        let card = Card(context: viewContext)
        card.timestamp = Date()

        do {
            try viewContext.save()
        } catch {
            print(error)
        }
    }

    func saveItem(card: Card?,
                  name: String,
                  number: String,
                  limit: String,
                  type: String,
                  month: Int,
                  year: Int,
                  timestamp: Date,
                  balance: String,
                  color: Color) {

        let newCard = card != nil ? card! : Card(context: viewContext)

        newCard.name = name
        newCard.number = number
        newCard.limit = Int32(limit) ?? 0
        newCard.expMonth = Int16(month)
        newCard.expYear = Int16(year)
        newCard.timestamp = timestamp
        newCard.balance = Int64(balance) ?? 0
        newCard.color = UIColor(color).encode()
        newCard.type = type

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

    func deleteItem(_ card: Card) {
        viewContext.delete(card)

        do {
            try viewContext.save()
        } catch {
            print(error)
        }
    }

    // MARK: - Transactions
    func saveTransaction(name: String,
                         amount: String,
                         timestamp: Date,
                         photoData: Data?,
                         card: Card) {
        let transaction = CardTransaction(context: viewContext)
        transaction.name = name
        transaction.amount = Float(amount) ?? 0
        transaction.timestamp = timestamp
        transaction.photoData = photoData

        transaction.card = card

        do {
            try viewContext.save()
        } catch {
            print(error)
        }
    }

    func deleteTransaction(_ transaction: CardTransaction) {
        viewContext.delete(transaction)

        do {
            try viewContext.save()
        } catch {
            print(error)
        }
    }

    // MARK: - Create transaction category
    func createCategory(name: String, color: Data) {
        let category = TransactionCategory(context: viewContext)
        category.name = name
        category.colorData = color
        category.timestamp = Date()

        do {
            try viewContext.save()
        } catch {
            print(error)
        }
    }

    func deleteCategory(_ cat: TransactionCategory) {
        viewContext.delete(cat)

        do {
            try viewContext.save()
        } catch {
            print(error)
        }
    }
}
