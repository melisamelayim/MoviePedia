//
//  FavoritesViewModel.swift
//  Moviepedia
//
//  Created by Max on 22.02.2025.
//

import FirebaseFirestore
import FirebaseAuth
import SwiftUI
import Combine

class FavoritesViewModel: ObservableObject { // used observableobject so views are automatically triggered when changes happen
    @Published private(set) var favoriteMovies: Set<Int> = []
    @Published private(set) var watchlistMovies: Set<Int> = []
    
    @Published var needsRefresh = false
    
    private let db = Firestore.firestore() // created an instance to access the firestore db, which is only accessable from here in this class, not anywhere else. also, this is only the referance, like, the connection variable. therefore, even tho we keep updating the db with data, out connection path is never going to change, that's why we use "let". so "db" is just a short-cut for that path.
   
    func toggleFavorite(movieId: Int) {
        if favoriteMovies.contains(movieId) {
            favoriteMovies.remove(movieId)
        } else {
            favoriteMovies.insert(movieId)
        }
        updateFirestoreArray(for: "favorites", movieId: movieId, isAdding: favoriteMovies.contains(movieId))
        needsRefresh = true
    }
    
    func toggleWatchlist(movieId: Int) {
        if watchlistMovies.contains(movieId) {
            watchlistMovies.remove(movieId)
        } else {
            watchlistMovies.insert(movieId)
        }
        updateFirestoreArray(for: "watchlist", movieId: movieId, isAdding: watchlistMovies.contains(movieId))
        needsRefresh = true
    }
    
    private func updateFirestoreArray(for field: String, movieId: Int, isAdding: Bool) {
        guard let userId = Auth.auth().currentUser?.uid else {
            print("user not logged in")
            return
        }
        let ref = db.collection("users").document(userId)
        
        let operation: [String: Any] = isAdding
        ? [field: FieldValue.arrayUnion([movieId])]
        : [field: FieldValue.arrayRemove([movieId])]
        
        ref.setData(operation, merge: true) { error in
            if let error = error {
                print("firestore update error: \(error.localizedDescription)")
            } else {
                print("firestore '\(field)' updated for movie \(movieId)")
            }
        }
    }
    
    func isFavorite(movieId: Int) -> Bool {
        favoriteMovies.contains(movieId)
    }

    func isInWatchlist(movieId: Int) -> Bool {
        watchlistMovies.contains(movieId)
    }
    
    
    func fetchFavorites() {
        guard let userId = Auth.auth().currentUser?.uid else {
            print("kullanıcı yok")
            return
        }

        print("📡 fetchFavorites çağrıldı")

        let ref = db.collection("users").document(userId)
        ref.getDocument { snapshot, error in
            if let error = error {
                print("firestore favorites read error: \(error.localizedDescription)")
                return
            }

            if let data = snapshot?.data(),
               let ids = data["favorites"] as? [Int] {
                DispatchQueue.main.async {
                    self.favoriteMovies = Set(ids)
                    print("favoriler geldi: \(ids.count) film")
                }
            } else {
                print("favoriler boş")
            }
        }
    }


    func fetchWatchlist() {
        guard let userId = Auth.auth().currentUser?.uid else {
            print("kullanıcı yok")
            return
        }

        print("fetchWatchlist çağrıldı")

        let ref = db.collection("users").document(userId)
        ref.getDocument { snapshot, error in
            if let error = error {
                print("firestore watchlist read error: \(error.localizedDescription)")
                return
            }

            if let data = snapshot?.data(),
               let ids = data["watchlist"] as? [Int] {
                DispatchQueue.main.async {
                    self.watchlistMovies = Set(ids)
                    print("watchlist geldi: \(ids.count) film")
                }
            } else {
                print("watchlist boş")
            }
        }
    }

    
    
    func fetchAll() {
        fetchFavorites()
        fetchWatchlist()
    }
    
}
