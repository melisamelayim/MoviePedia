//
//  PosterCarouselView.swift
//  Moviepedia
//
//  Created by Max on 27.12.2024.
//

import SwiftUI

struct PosterCarouselView: View {
    let movies: [Movie]
    @EnvironmentObject var favoritesVM: FavoritesViewModel
    @EnvironmentObject var recommendationVM: RecommendationViewModel
    
    var body: some View {
        ScrollViewReader { scrollProxy in
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    ForEach(0..<movies.count, id: \.self) { index in
                        NavigationLink(
                            destination: MovieDetailView(movieId: movies[index].id, movieTitle: movies[index].title)
                                .environmentObject(favoritesVM)
                                .environmentObject(recommendationVM)
                        ) {
                            PosterCardView(movie: movies[index])
                                .environmentObject(favoritesVM)
                                .frame(width: 120, height: 180) // sabit kart boyutu
                        }
                        //.frame(width: 130, height: 200) // tek bir poster cardın çerçevesi
                        
                    }
                }
                .scrollTargetLayout()
                .padding(.horizontal, 7)
            }
            .scrollTargetBehavior(.viewAligned)
            
        }
        .frame(height: 200)
        
    }
}

#Preview {
    PosterCarouselView(movies: Movie.stubbedMovies)
        .environmentObject(FavoritesViewModel())
        .environmentObject(RecommendationViewModel())
}
