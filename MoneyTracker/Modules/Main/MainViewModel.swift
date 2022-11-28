//
//  MainViewModel.swift
//  MoneyTracker
//
//  Created by Roman Korobskoy on 15.11.2022.
//

import SwiftUI

protocol MainViewModelType {
    var dateFormatter: DateFormatter { get }
    func getCountOfCards() -> Int
    func addItem()
    func deleteAllItems(_ cards: FetchedResults<Card>)
    func saveItem(card: Card?,
                  name: String,
                  number: String,
                  limit: String,
                  type: String,
                  month: Int,
                  year: Int,
                  timestamp: Date,
                  balance: String,
                  color: Color)
    func deleteItem(_ card: Card)
    func saveTransaction(name: String,
                         timestamp: Date,
                         amount: String,
                         photoData: Data?)
    func deleteTransaction(_ transaction: CardTransaction)
}

final class MainViewModel: MainViewModelType  {

    private var coreDataService: CoreDataService = CoreDataService()

    var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .none
        return formatter
    }()

    func getCountOfCards() -> Int {
        coreDataService.getCount()
    }

    func addItem() {
        coreDataService.addItem()
    }

    func deleteAllItems(_ cards: FetchedResults<Card>) {
        coreDataService.deleteAllItems(cards)
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
        coreDataService.saveItem(card: card,
                                 name: name,
                                 number: number,
                                 limit: limit,
                                 type: type,
                                 month: month,
                                 year: year,
                                 timestamp: timestamp,
                                 balance: balance,
                                 color: color)
    }

    func deleteItem(_ card: Card) {
        coreDataService.deleteItem(card)
    }

    func saveTransaction(name: String,
                         timestamp: Date,
                         amount: String,
                         photoData: Data?) {
        coreDataService.saveTransaction(name: name,
                                        amount: amount,
                                        timestamp: timestamp,
                                        photoData: photoData)
    }

    func deleteTransaction(_ transaction: CardTransaction) {
        coreDataService.deleteTransaction(transaction)
    }
}
