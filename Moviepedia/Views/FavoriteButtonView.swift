//
//  FavoriteButtonView.swift
//  Moviepedia
//
//  Created by Max on 24.02.2025.
//

import SwiftUI

struct FavoriteButtonView: View {
    let movie: Movie
    @ObservedObject var userMovieState: UserMovieState
    
    var body: some View {
        Button(action: {
            userMovieState.toggleFavorite(for: movie)
        }) {
            ZStack {
                Circle()
                    .fill(Color.white.opacity(0.6))
                    .frame(width: 40, height: 40)
                    .shadow(radius: 3)
                
                Image(systemName: userMovieState.isFavorite(movie) ? "heart.fill" : "heart")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 25, height: 25)
                    .foregroundColor(userMovieState.isFavorite(movie) ? .red.opacity(0.7) : .black.opacity(0.5))
            }
        }
        .buttonStyle(PlainButtonStyle()) // soft animation
    }
}


