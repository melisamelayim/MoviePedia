//
//  WatchlistButtonView.swift
//  Moviepedia
//
//  Created by Missy on 7.05.2025.
//

import SwiftUI

struct WatchlistButtonView: View {
    let movie: Movie
    @ObservedObject var userMovieState: UserMovieState

    var body: some View {
        Button(action: {
            userMovieState.toggleWatchlist(for: movie)
        }) {
            ZStack {
                Circle()
                    .fill(Color.white.opacity(0.6))
                    .frame(width: 40, height: 40)
                    .shadow(radius: 3)
                
                Image(systemName: userMovieState.isInWatchlist(movie) ? "bookmark.fill" : "bookmark")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 25, height: 25)
                    .foregroundColor(userMovieState.isInWatchlist(movie) ? .blue.opacity(0.8) : .black.opacity(0.5))
            }
        }
        .buttonStyle(PlainButtonStyle()) // soft animation
    }
}

