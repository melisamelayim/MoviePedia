//
//  PosterCarouselView.swift
//  Moviepedia
//
//  Created by Max on 27.12.2024.
//

import SwiftUI

enum CarouselItem: Identifiable {
    case movie(Movie)
    case recommended(RecommendedMovie)

    var id: Int {
        switch self {
        case .movie(let movie): return movie.id
        case .recommended(let rec): return rec.id
        }
    }

    var title: String {
        switch self {
        case .movie(let movie): return movie.title
        case .recommended(let rec): return rec.title
        }
    }

    var posterURL: URL? {
        switch self {
        case .movie(let movie): return movie.posterURL
        case .recommended(let rec): return rec.posterURL
        }
    }
}


struct PosterCarouselView: View {
    let items: [CarouselItem]
    
    @ObservedObject var userMovieState: UserMovieState
    @State private var currentIndex: Int = 0
    
    var body: some View {
        GeometryReader { geometry in
            ScrollViewReader { scrollProxy in
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 15) {
                        ForEach(items.indices, id: \.self) { index in
                            let item = items[index]
                            let card = GeometryReader { innerGeometry in
                                    PosterCardView(title: item.title, posterURL: item.posterURL, userMovieState: userMovieState)
                                        .frame(width: 200, height: 300)
                                        .scaleEffect(getScale(proxy: innerGeometry, geometry: geometry))
                                        .opacity(getScale(proxy: innerGeometry, geometry: geometry))
                                        .animation(.spring(), value: getScale(proxy: innerGeometry, geometry: geometry))
                                }
                                .frame(width: 170, height: 300)
                            
                            NavigationLink(
                                destination: MovieDetailView(movieId: item.id, movieTitle: item.title)
                            ) {
                                card
                            }
                            .frame(width: 170, height: 300)
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

