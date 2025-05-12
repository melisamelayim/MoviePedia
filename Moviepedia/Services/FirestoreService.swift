//
//  FirestoreService.swift
//  Moviepedia
//
//  Created by Max on 22.02.2025.
//

import Foundation
import FirebaseFirestore

class FirestoreService {
    private let db = Firestore.firestore()
    
    func addFavorite(movie: Movie, userId: String, completion: ((Error?) -> Void)? = nil) {
        let docData: [String: Any] = [
            "timestamp": Timestamp(),
            "title": movie.title,
            "overview": movie.overview,
            "genre": movie.genres?.first?.name ?? "",
            "year": movie.yearText
        ]

        let favoriteRef = db.collection("users")
            .document(userId)
            .collection("favorites")
            .document("\(movie.id)")

        let watchlistRef = db.collection("users")
            .document(userId)
            .collection("watchlist")
            .document("\(movie.id)")

        // add to favorites
        favoriteRef.setData(docData) { error in
            if let error = error {
                print("could not add to favorites\(error.localizedDescription)")
                completion?(error)
                return
            }

            print("added to favorites: \(movie.title)")

            // clear from watchlist (if exists)
            watchlistRef.getDocument { document, error in
                if let error = error {
                    print("could not check watchlist: \(error.localizedDescription)")
                    completion?(nil)
                    return
                }
                if document?.exists == true {
                    watchlistRef.delete { error in
                        if let error = error {
                            print("could not delete from watchlist: \(error.localizedDescription)")
                        } else {
                            print("deleted from watchlist \(movie.title)")
                        }
                    }
                }
            }

            completion?(nil)
        }
    }
    
    
    func removeFavorite(movieId: Int, userId: String, completion: ((Error?) -> Void)? = nil) {
        db.collection("users")
            .document(userId)
            .collection("favorites")
            .document("\(movieId)")
            .delete { error in
                if let error = error {
                    print("could not delete from favorites \(error.localizedDescription)")
                } else {
                    print("deleted from favorites: \(movieId)")
                }
                completion?(error)
            }
    }
}

