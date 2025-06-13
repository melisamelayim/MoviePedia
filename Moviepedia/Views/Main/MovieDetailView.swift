//
//  MovieDetailView.swift
//  Moviepedia
//
//  Created by Max on 17.01.2025.
//

import SwiftUI

struct MovieDetailView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @EnvironmentObject var favoritesVM: FavoritesViewModel
    @EnvironmentObject var recommendationVM: RecommendationViewModel

    @StateObject private var movieDetailState = MovieDetailState()
    
    let movieId: Int
    let movieTitle: String
    
    @State private var selectedTrailerURL: URL?
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                if let movie = movieDetailState.movie {
                    if let backdropURL = movie.backdropURL {
                        ZStack(alignment: .topLeading) {
                            MovieDetailImage(imageURL: backdropURL)
                            
                            Button(action: {
                                presentationMode.wrappedValue.dismiss()
                            }) {
                                Image(systemName: "chevron.left")
                                    .font(.system(size: 20, weight: .bold))
                                    .foregroundColor(.white) // ← butonun rengi beyaz
                            }
                            .shadow(color: .black.opacity(0.4), radius: 4, x: 0, y: 2) // ← gölge efekti
                            .padding(.top, 50)
                            .padding(.leading, 20)

                        }
                            
                    }
                                        
                    HStack(spacing: 16) {
                        VStack {
                            Text(movieTitle)
                                .font(.title)
                                .bold()
                                .lineLimit(nil)
                                .fixedSize(horizontal: true, vertical: false)
                                .padding(.leading)
                        }
                        
                        Spacer()
                            
                        WatchlistButtonView(movie: movie)
                            .offset(y: -70)
                        FavoriteButtonView(movie: movie)
                            .padding(.trailing)
                            .offset(y: -70)
                            .environmentObject(favoritesVM)
                            .environmentObject(recommendationVM)
                    }
                    .padding(.bottom, 0)
                                    
                    MovieDetailListView(movie: movie, selectedTrailerURL: $selectedTrailerURL)
                }
                
            }
            .padding(.horizontal)
            
        }
        .ignoresSafeArea(edges: .top)
        .navigationBarHidden(true)
        .task(id: movieId) {
            await movieDetailState.loadMovie(id: movieId)
        }
        
    }
        

}

struct MovieDetailListView: View {
    let movie: Movie
    @Binding var selectedTrailerURL: URL?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            movieDescriptionSection
            Divider()
            movieCastCrewSection
        }
    }
    
    private var movieDescriptionSection: some View {
        VStack(alignment: .leading) {
            Text(movieGenreYearDurationText)
                .font(.footnote)
                .padding(.horizontal)
                .padding(.top, -10)
                
            
            HStack(alignment: .top, spacing: 16) {
                PosterCardView(movie: movie, showWatchlistButton: false)
                    .frame(width: 150, height: 225)
                    .padding(.leading)
                    .padding(.top)
                    .padding(.bottom)
                    .layoutPriority(1)
               
                VStack {
                    HStack {
                        if !movie.ratingText.isEmpty {
                            Text(movie.ratingText)
                                .foregroundColor(.yellow)
                                .bold()
                        }
                        
                        Text(movie.scoreText)
                            .font(.footnote)
                        
                        Spacer()
                        
                    }
                    .offset(y: 15)
                    
                    Spacer()
                    
                    if let tagline = movie.tagline, !tagline.isEmpty {
                        Text("“\(tagline)”")
                            .font(.title3)
                            .lineLimit(nil)
                            .fixedSize(horizontal: false, vertical: true)
                            .font(.body)
                            .multilineTextAlignment(.center)
                            .padding(.trailing)
                    }
                    
                    Spacer()
                    
                }
                .layoutPriority(2)
            }
            .padding(.top, -10)
            
            Divider()
                .padding(.top, 5)
            
            Text(movie.overview)
                .lineLimit(nil)
                .fixedSize(horizontal: false, vertical: true)
                .font(.body)
                .padding()
        }
    }
    
    private var movieCastCrewSection: some View {
        VStack(alignment: .leading, spacing: 16) {

            if let cast = movie.cast, !cast.isEmpty {
                Text("Oyuncular")
                    .font(.headline)

                LazyVGrid(columns: [
                    GridItem(.flexible()),
                    GridItem(.flexible()),
                    GridItem(.flexible())
                ], spacing: 20) {
                    ForEach(cast.prefix(6)) { actor in
                        ActorCardView(cast: actor)
                    }
                }
            }
            
            Divider()
                .padding()
            
            HStack (alignment: .top, spacing: 30) {
                if let crew = movie.crew, !crew.isEmpty {
                    VStack {
                        
                        if let directors = movie.directors, !directors.isEmpty {
                            Text("Yönetmen(ler)").font(.headline)
                            ForEach(directors.prefix(2)) { Text($0.name) }
                        }
                    }
                    
                    Divider()
                        .frame(width: 1, height: 80)
                            .background(Color.gray)
                    
                    VStack {
                        if let producers = movie.producers, !producers.isEmpty {
                            Text("Yapımcı(lar)").font(.headline)
                                .padding(.top, 4)
                            ForEach(producers.prefix(2)) { Text($0.name) }
                        }
                    }
                }
            }
            .padding(.leading, 35)
            
        }
        .padding(.leading)
    }
    
    private var movieGenreYearDurationText: String {
        "\(movie.genreText) · \(movie.yearText) · \(movie.durationText)"
    }
}

struct MovieDetailImage: View {
    @StateObject private var imageLoader = ImageLoader()
    let imageURL: URL
    
    var body: some View {
        ZStack(alignment: .bottom) {
            if let image = imageLoader.image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: UIScreen.main.bounds.width,
                           height: UIScreen.main.bounds.width * 9 / 16)
                    .clipped()
                    
                        LinearGradient(
                            gradient: Gradient(colors: [.clear, .white]),
                            startPoint: .top,
                            endPoint: .bottom
                        )
                        .frame(height: 40)
                    
            } else {
                ProgressView()
                    .frame(width: UIScreen.main.bounds.width,
                            height: UIScreen.main.bounds.width * 9 / 16)
            }
        }
        .ignoresSafeArea(edges: .top)
        .onAppear {
            imageLoader.loadImage(with: imageURL)
        }
    }
}

extension URL: Identifiable {
    public var id: Self { self }
}

struct ActorCardView: View {
    let cast: MovieCast

    var body: some View {
        VStack(spacing: 8) {
            if let url = cast.profileImageURL {
                AsyncImage(url: url) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                            .frame(width: 80, height: 100)
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFill()
                            .frame(width: 80, height: 100)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                    case .failure:
                        Image(systemName: "person.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 80, height: 100)
                    @unknown default:
                        EmptyView()
                    }
                }
            } else {
                Image(systemName: "person.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 80, height: 100)
            }

            Text(cast.name)
                .font(.caption)
                .bold()
                .lineLimit(2)
                .multilineTextAlignment(.center)

            Text(cast.character)
                .font(.caption2)
                .foregroundColor(.gray)
                .lineLimit(2)
                .multilineTextAlignment(.center)
        }
        .frame(width: 100)
        .shadow(radius: 10, x: 5, y: 0)
    }
}

struct MovieDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            MovieDetailView(movieId: Movie.stubbedMovie.id, movieTitle: "BLOODSHOT")
                .environmentObject(FavoritesViewModel())
                .environmentObject(RecommendationViewModel())
                .navigationBarHidden(true)

        }
    }
}
