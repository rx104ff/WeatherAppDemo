//
//  WeatherAppApp.swift
//  WeatherApp
//
//  Created by Ningyuan Gao on 11/19/22.
//

import SwiftUI

@main
struct WeatherAppApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            CityListView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
