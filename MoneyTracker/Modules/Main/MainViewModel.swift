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
}

final class MainViewModel: MainViewModelType  {

    private var coreDataService: CoreDataService = CoreDataService()

    func addItem() {
        coreDataService.addItem()
    }

    func deleteAllItems(_ cards: FetchedResults<Card>) {
        coreDataService.deleteAllItems(cards)
    }
}
