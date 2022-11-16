//
//  MainViewModel.swift
//  MoneyTracker
//
//  Created by Roman Korobskoy on 15.11.2022.
//

import SwiftUI

protocol MainViewModelType {
    func addItem()
    func deleteAllItems(_ cards: FetchedResults<Card>)
    func saveItem(name: String,
                  number: String,
                  limit: String,
                  type: String,
                  month: Int,
                  year: Int,
                  timestamp: Date,
                  balance: String,
                  color: Color)
}

final class MainViewModel: MainViewModelType  {

    private var coreDataService: CoreDataService = CoreDataService()

    func addItem() {
        coreDataService.addItem()
    }

    func deleteAllItems(_ cards: FetchedResults<Card>) {
        coreDataService.deleteAllItems(cards)
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
        coreDataService.saveItem(name: name,
                                 number: number,
                                 limit: limit,
                                 type: type,
                                 month: month,
                                 year: year,
                                 timestamp: timestamp,
                                 balance: balance,
                                 color: color)
    }
}
