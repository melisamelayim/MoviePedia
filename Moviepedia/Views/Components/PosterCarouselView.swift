//
//  PosterCarouselView.swift
//  Moviepedia
//
//  Created by Max on 27.12.2024.
//

import SwiftUI

struct PosterCarouselView: View {
    @EnvironmentObject var favoritesVM: FavoritesViewModel
    let movies: [Movie]

    @State private var currentIndex: Int = 0
    
    var body: some View {
        GeometryReader { geometry in
            ScrollViewReader { scrollProxy in
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 15) {
                        ForEach(0..<movies.count, id: \.self) { index in
                            NavigationLink(
                                    destination: MovieDetailView(movieId: movies[index].id, movieTitle: movies[index].title)
                                        .environmentObject(favoritesVM)

                            ) {
                                GeometryReader { innerGeometry in
                                    PosterCardView(movie: movies[index])
                                        .environmentObject(favoritesVM)
                                        .frame(width: 140, height: 210)
                                        .scaleEffect(getScale(proxy: innerGeometry, geometry: geometry))
                                        .opacity(getScale(proxy: innerGeometry, geometry: geometry))
                                        .animation(.spring(), value: getScale(proxy: innerGeometry, geometry: geometry))
                                }
                                .frame(width: 130, height: 220)
                            }
                            .frame(width: 120, height: 220)
                        }
                    }
                    .scrollTargetLayout()
                    .padding(.horizontal, 2)
                }
                .scrollTargetBehavior(.viewAligned)
                .onAppear {
                    scrollProxy.scrollTo(currentIndex, anchor: .center)
                }
            }
        }
        .frame(height: 300)
    }
        
    private func getScale(proxy: GeometryProxy, geometry: GeometryProxy) -> CGFloat {
        let midPoint = geometry.size.width / 2
        let cardMidX = proxy.frame(in: .global).midX
        let distance = abs(midPoint - cardMidX)
        let maxDistance = geometry.size.width / 2
        let scale = max(0.85, 0.9 - (distance / maxDistance) * 0.5)
        return scale
    }
}
    
#Preview {
    PosterCarouselView(movies: Movie.stubbedMovies)
        .environmentObject(FavoritesViewModel())
}
