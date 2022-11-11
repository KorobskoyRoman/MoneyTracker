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

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
