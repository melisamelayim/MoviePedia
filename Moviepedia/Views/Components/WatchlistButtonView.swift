//
//  WatchlistButtonView.swift
//  Moviepedia
//
//  Created by Missy on 7.05.2025.
//

import SwiftUI

struct WatchlistButtonView<T: MovieRepresentable>: View {
    @EnvironmentObject var favoritesVM: FavoritesViewModel
    let movie: T

    var body: some View {
        Button(action: {
            favoritesVM.toggleWatchlist(movieId: movie.id)
        }) {
            ZStack {
                Circle()
                    .fill(Color.white.opacity(0.6))
                    .frame(width: 40, height: 40)
                    .shadow(radius: 3)
                
                Image(systemName: favoritesVM.isInWatchlist(movieId: movie.id) ? "bookmark.fill" : "bookmark")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 25, height: 25)
                    .foregroundColor(favoritesVM.isInWatchlist(movieId: movie.id) ? .blue.opacity(0.8) : .black.opacity(0.5))
            }
        }
        .buttonStyle(PlainButtonStyle()) // soft animation
    }
}

