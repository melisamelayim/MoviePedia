//
//  UserMovieState.swift
//  Moviepedia
//
//  Created by Missy on 4.05.2025.
//

import Foundation
import Combine

class UserMovieState: ObservableObject {
    @Published private(set) var favoriteMovieIDs: Set<Int> = []
    @Published private(set) var watchlistMovieIDs: Set<Int> = []

    func toggleFavorite(for movie: Movie) {
        if favoriteMovieIDs.contains(movie.id) {
            favoriteMovieIDs.remove(movie.id)
        } else {
            favoriteMovieIDs.insert(movie.id)
        }
    }

    func toggleWatchlist(for movie: Movie) {
        if watchlistMovieIDs.contains(movie.id) {
            watchlistMovieIDs.remove(movie.id)
        } else {
            watchlistMovieIDs.insert(movie.id)
        }
    }

    func isFavorite(_ movie: Movie) -> Bool {
        favoriteMovieIDs.contains(movie.id)
    }

    func isInWatchlist(_ movie: Movie) -> Bool {
        watchlistMovieIDs.contains(movie.id)
    }
}
