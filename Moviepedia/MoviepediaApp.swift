//
//  MoviepediaApp.swift
//  Moviepedia
//
//  Created by Max on 28.11.2024.
//

import SwiftUI
import Firebase

@main
struct MovieApp: App {
    init() {
        FirebaseApp.configure()
        let firestoreManager = FirestoreService()
    }
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

