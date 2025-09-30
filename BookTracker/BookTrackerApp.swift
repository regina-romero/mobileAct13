//
//  BookTrackerApp.swift
//  BookTracker
//
//  Created by Regina Romero on 9/29/25.
//

import SwiftUI
import SwiftData

@main
struct BookTrackerApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: [Book.self])
        
    }
}

