//
//  MoviepediaApp.swift
//  Moviepedia
//
//  by Max on 28.11.2024.
//

import SwiftUI
import Firebase

@main
struct MovieApp: App {
    @StateObject var authVM = AuthViewModel()
    @StateObject var favoritesVM = FavoritesViewModel()
    @StateObject var recommendationVM = RecommendationViewModel()

    init() {
        FirebaseApp.configure()
        let firestoreManager = FirestoreService()
    }
    var body: some Scene {
        WindowGroup {
            AppView()
                .environmentObject(authVM)
                .environmentObject(favoritesVM)
                .environmentObject(recommendationVM)
        }
    }
}

