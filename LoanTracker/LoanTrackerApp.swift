//
//  LoanTrackerApp.swift
//  LoanTracker
//
//  Created by Othmar Gispert on 9/27/22.
//

import SwiftUI

@main
struct LoanTrackerApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            LoansView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
