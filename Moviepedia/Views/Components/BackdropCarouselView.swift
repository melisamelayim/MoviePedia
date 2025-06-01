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
    
    var body: some View {
        GeometryReader(content: { geometry in
            let size = geometry.size
            
            ScrollView(.horizontal) {
                HStack(spacing: 5) {
                    ForEach(movies) { movie in
                        NavigationLink(
                                destination: MovieDetailView(movieId: movie.id, movieTitle: movie.title)
                                    .environmentObject(favoritesVM)

                        ) {
                            GeometryReader(content: { proxy in
                                let cardSize = proxy.size
                                
                                BackdropCardView(displayMovie: movie)
                                    .environmentObject(favoritesVM)
                                    .frame(width: cardSize.width, height: cardSize.height)
                                    .shadow(color: .black.opacity(0.25), radius: 10)
                            })
                            .frame(width: size.width - 60, height: size.height - 50)
                        }
                        .scrollTransition(.interactive, axis: .horizontal) {
                            view, phase in
                            view
                                .scaleEffect(phase.isIdentity ? 1 : 0.95)
                        }
                    }
                }
                .padding(.horizontal, 30)
                .scrollTargetLayout()
                .frame(height: size.height, alignment: .top)
            }
            .scrollTargetBehavior(.viewAligned)
        })
        .frame(height: 300)
        .padding(.horizontal, -15)
        .padding(.top, -20)
        
        .padding(5)
    }
    
    private func getParallaxOffset(proxy: GeometryProxy, geometry: GeometryProxy) -> CGFloat {
        let midPoint = geometry.size.width / 2
        let cardMidX = proxy.frame(in: .global).midX
        let distance = abs(midPoint - cardMidX)
        let maxDistance = geometry.size.width / 2
        let offset = -(distance / maxDistance) * 20
        return offset
    }
}

/*struct BackdropCarouselView_Previews: PreviewProvider {
    static var previews: some View {
        BackdropCarouselView(movies: Movie.stubbedMovies) // mock
            .background(Color.black.opacity(0.7)) 
    }
}
*/
