//
//  MoneyTrackerApp.swift
//  MoneyTracker
//
//  Created by Roman Korobskoy on 11.11.2022.
//

import SwiftUI

@main
struct MoneyTrackerApp: App {
    let persistenceController = PersistenceController.shared
    private var mainVm = MainViewModel()

    var body: some Scene {
        WindowGroup {
            MainView(vm: mainVm)
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
