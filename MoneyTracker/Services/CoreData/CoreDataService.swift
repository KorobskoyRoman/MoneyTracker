//
//  CoreDataService.swift
//  MoneyTracker
//
//  Created by Roman Korobskoy on 15.11.2022.
//

import CoreData
import SwiftUI

final class CoreDataService: ObservableObject {
    let viewContext = PersistenceController.shared.container.viewContext

    func addItem() {
        let card = Card(context: viewContext)
        card.timestamp = Date()

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
