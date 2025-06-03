//
//  FavoriteButtonView.swift
//  Moviepedia
//
//  Created by Max on 24.02.2025.
//

import SwiftUI

struct FavoriteButtonView<T: MovieRepresentable>: View {
    @EnvironmentObject var favoritesVM: FavoritesViewModel
    @EnvironmentObject var recommendationVM: RecommendationViewModel
    
    let movie: T
    

    var body: some View {
        Button(action: {
            favoritesVM.toggleFavorite(movieId: movie.id)
            print("🧠 updateRecommendations triggered?")
            Task {
                await recommendationVM.sendFavoriteIdsToBackend(favoriteIds: Array(favoritesVM.favoriteMovies))
            }
            
        }) {
            ZStack {
                Circle()
                    .fill(Color.white.opacity(0.6))
                    .frame(width: 40, height: 40)
                    .shadow(radius: 3)
                
                Image(systemName: favoritesVM.isFavorite(movieId: movie.id) ? "heart.fill" : "heart")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 25, height: 25)
                    .foregroundColor(favoritesVM.isFavorite(movieId: movie.id) ? .red.opacity(0.7) : .black.opacity(0.5))
            }
        }
        .buttonStyle(PlainButtonStyle()) // soft animation
    }
}


