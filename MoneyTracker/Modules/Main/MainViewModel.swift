//
//  MainViewModel.swift
//  MoneyTracker
//
//  Created by Roman Korobskoy on 15.11.2022.
//

import SwiftUI

protocol MainViewModelType {
    var dateFormatter: DateFormatter { get }
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
                         photoData: Data?,
                         card: Card,
                         selectedCategories: Set<TransactionCategory>)
    func deleteTransaction(_ transaction: CardTransaction, _ card: Card)
    func createCategory(name: String, color: Color)
    func deleteCategory(_ cat: TransactionCategory)
    func getColor(cat: TransactionCategory) -> Color?
    func sortCats(_ cats: Set<TransactionCategory>) -> [TransactionCategory]
    func prefetchCategory() -> TransactionCategory?
}

final class MainViewModel: MainViewModelType  {

    private var coreDataService: CoreDataService = CoreDataService()

    var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .none
        return formatter
    }()

    func addItem() {
        coreDataService.addItem()
    }

    func deleteAllItems(_ cards: FetchedResults<Card>) {
        coreDataService.deleteAllItems(cards)
    }

    func getColor(cat: TransactionCategory) -> Color? {
        if let data = cat.colorData,
           let uiColor = UIColor.color(data: data) {
            let color = Color(uiColor)
            return color
        }
        return nil
    }

    func sortCats(_ cats: Set<TransactionCategory>) -> [TransactionCategory] {
        return Array(cats).sorted(by: {
            $0.timestamp?.compare($1.timestamp ?? Date()) == .orderedDescending
        })
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
                         photoData: Data?,
                         card: Card,
                         selectedCategories: Set<TransactionCategory>) {
        coreDataService.saveTransaction(
            name: name,
            amount: amount,
            timestamp: timestamp,
            photoData: photoData,
            card: card,
            selectedCategories: selectedCategories
        )
    }

    func deleteTransaction(_ transaction: CardTransaction, _ card: Card) {
        coreDataService.deleteTransaction(transaction, card)
    }

    func createCategory(name: String, color: Color) {
        if let colorData = UIColor(color).encode() {
            coreDataService.createCategory(name: name, color: colorData)
        }
    }

    func deleteCategory(_ cat: TransactionCategory) {
        coreDataService.deleteCategory(cat)
    }

    func prefetchCategory() -> TransactionCategory? {
        return coreDataService.prefetchCategory()
    }
}
