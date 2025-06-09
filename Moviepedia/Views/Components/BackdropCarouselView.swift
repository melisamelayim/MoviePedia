//
//  BackdropCarouselView.swift
//  Moviepedia
//
//  Created by Max on 29.12.2024.
//

import SwiftUI

struct BackdropCarouselView: View {
    let movies: [DisplayMovie]
    @EnvironmentObject var favoritesVM: FavoritesViewModel
    @EnvironmentObject var recommendationVM: RecommendationViewModel
    
    var body: some View {
        GeometryReader { geometry in
            let screenWidth = geometry.size.width
            let screenHeight = geometry.size.height
            let cardWidth = screenWidth * 0.9
            let cardHeight = screenHeight * 0.9
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 20) {
                    ForEach(movies) { movie in
                        NavigationLink(
                            destination: MovieDetailView(movieId: movie.id, movieTitle: movie.title)
                                .environmentObject(favoritesVM)
                                .environmentObject(recommendationVM)
                        ) {
                            GeometryReader { proxy in
                                let offset = getParallaxOffset(proxy: proxy, geometry: geometry)
                                
                                BackdropCardView(displayMovie: movie)
                                    .environmentObject(favoritesVM)
                                    .frame(width: cardWidth, height: cardHeight)
                                    .offset(x: offset)
                                    .scaleEffect(getScale(proxy: proxy, geometry: geometry))
                                    .animation(.easeInOut(duration: 0.3), value: offset)
                            }
                            .frame(width: cardWidth, height: cardHeight)
                        }
                    }
                }
                .scrollTargetLayout()
                .padding(.horizontal, (screenWidth - cardWidth) / 2) // Kenarlara eşit boşluk
            }
            .scrollTargetBehavior(.viewAligned)
        }
        .frame(height: 250) // Carousel yüksekliği
    }
    
    private func getParallaxOffset(proxy: GeometryProxy, geometry: GeometryProxy) -> CGFloat {
        let screenWidth = geometry.size.width
        let midX = proxy.frame(in: .global).midX
        let center = screenWidth / 2
        let distance = midX - center
        let parallaxStrength: CGFloat = 0.2 // Oranını ayarla
        return -distance * parallaxStrength
    }
    
    private func getScale(proxy: GeometryProxy, geometry: GeometryProxy) -> CGFloat {
        let screenWidth = geometry.size.width
        let midX = proxy.frame(in: .global).midX
        let center = screenWidth / 2
        let distance = abs(center - midX)
        let maxDistance = screenWidth / 2
        let scale = max(0.9, 1 - (distance / maxDistance) * 0.1)
        return scale
    }
}



