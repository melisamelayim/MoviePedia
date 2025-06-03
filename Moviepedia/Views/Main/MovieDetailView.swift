//
//  MovieDetailView.swift
//  Moviepedia
//
//  Created by Max on 17.01.2025.
//

import SwiftUI

struct MovieDetailView: View {
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
                        MovieDetailImage(imageURL: backdropURL)
                    }
                    
                    HStack(spacing: 16) {
                        WatchlistButtonView(movie: movie)
                        FavoriteButtonView(movie: movie)
                            .environmentObject(favoritesVM)
                            .environmentObject(recommendationVM)
                    }
                    
                    
                    MovieDetailListView(movie: movie, selectedTrailerURL: $selectedTrailerURL)
                }
            }
            .padding()
        }
        .navigationTitle(movieTitle)
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
        .padding(.vertical)
    }
    
    private var movieDescriptionSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(movieGenreYearDurationText)
                .font(.headline)
            Text(movie.overview)
                .font(.body)
            HStack {
                if !movie.ratingText.isEmpty {
                    Text(movie.ratingText)
                        .foregroundColor(.yellow)
                        .bold()
                }
                Text(movie.scoreText)
            }
        }
    }
    
    private var movieCastCrewSection: some View {
        HStack(alignment: .top, spacing: 24) {
            if let cast = movie.cast, !cast.isEmpty {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Oyuncular")
                        .font(.headline)
                    ForEach(cast.prefix(9)) { Text($0.name) }
                }
                .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
            }
            
            if let crew = movie.crew, !crew.isEmpty {
                VStack(alignment: .leading, spacing: 4) {
                    if let directors = movie.directors, !directors.isEmpty {
                        Text("Yönetmen(ler)").font(.headline)
                        ForEach(directors.prefix(2)) { Text($0.name) }
                    }
                    
                    if let producers = movie.producers, !producers.isEmpty {
                        Text("Yapımcı(lar)").font(.headline)
                            .padding(.top, 4)
                        ForEach(producers.prefix(2)) { Text($0.name) }
                    }
                    
                    if let screenwriters = movie.screenWriters, !screenwriters.isEmpty {
                        Text("Yazar(lar)").font(.headline)
                            .padding(.top, 4)
                        ForEach(screenwriters.prefix(2)) { Text($0.name) }
                    }
                }
                .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
            }
        }
    }
    
    private var movieGenreYearDurationText: String {
        "\(movie.genreText) · \(movie.yearText) · \(movie.durationText)"
    }
}

struct MovieDetailImage: View {
    @StateObject private var imageLoader = ImageLoader()
    let imageURL: URL
    
    var body: some View {
        ZStack {
            if let image = imageLoader.image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
            } else {
                ProgressView()
            }
        }
        .aspectRatio(16/9, contentMode: .fit)
        .onAppear {
            imageLoader.loadImage(with: imageURL)
        }
    }
}

// URL -> Identifiable Extension
extension URL: Identifiable {
    public var id: Self { self }
}

// SwiftUI Preview
struct MovieDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            MovieDetailView(movieId: Movie.stubbedMovie.id, movieTitle: "The Godfather 2")
                .environmentObject(FavoritesViewModel())
                .environmentObject(RecommendationViewModel())
        }
    }
}


/*struct MovieDetailView: View {
    @EnvironmentObject var favoritesVM: FavoritesViewModel
    @StateObject private var movieDetailState = MovieDetailState()
    
    let movieId: Int
    let movieTitle: String
    
    @State private var selectedTrailerURL: URL?
    
    var body: some View {
        List {
            if let movie = movieDetailState.movie {
                if let url = movie.backdropURL {
                    MovieDetailImage(imageURL: url)
                        .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                        .listRowSeparator(.hidden)
                }
                
                WatchlistButtonView(movie: movie)
                    .environmentObject(favoritesVM)
                FavoriteButtonView(movie: movie)
                    .environmentObject(favoritesVM)
                MovieDetailListView(movie: movie, selectedTrailerURL: $selectedTrailerURL)
            }
        }
        .listStyle(.plain)
        .navigationTitle(movieTitle)
        .task {
            await self.movieDetailState.loadMovie(id: self.movieId)
        }
    }
}

struct MovieDetailListView: View {
    
    let movie: Movie
    @Binding var selectedTrailerURL: URL?
    
    var body: some View {
        movieDescriptionSection.listRowSeparator(.visible)
        movieCastSection.listRowSeparator(.hidden)
        
    }
    
    private var movieDescriptionSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(movieGenreYearDurationText)
                .font(.headline)
            Text(movie.overview)
            HStack {
                if !movie.ratingText.isEmpty {
                    Text(movie.ratingText).foregroundColor(.yellow)
                }
                Text(movie.scoreText)
            }
        }
        .padding(.vertical)
    }
    
    private var movieCastSection: some View {
        HStack(alignment: .top, spacing: 4) {
            if let cast = movie.cast, !cast.isEmpty {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Oyuncular").font(.headline)
                    ForEach(cast.prefix(9)) { Text($0.name) }
                }
                .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                Spacer()
                
            }
            
            if let crew = movie.crew, !crew.isEmpty {
                VStack(alignment: .leading, spacing: 4) {
                    if let directors = movie.directors, !directors.isEmpty {
                        Text("Yönetmen(ler)").font(.headline)
                        ForEach(directors.prefix(2)) { Text($0.name) }
                    }
                    
                    if let producers = movie.producers, !producers.isEmpty {
                        Text("Yapımcı(lar)").font(.headline)
                            .padding(.top)
                        ForEach(producers.prefix(2)) { Text($0.name) }
                    }
                    
                    if let screenwriters = movie.screenWriters, !screenwriters.isEmpty {
                        Text("Yazar(lar)").font(.headline)
                            .padding(.top)
                        ForEach(screenwriters.prefix(2)) { Text($0.name) }
                    }
                }
                .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
            }
        }
        .padding(.vertical)
    }

    
    private var movieGenreYearDurationText: String {
        "\(movie.genreText) · \(movie.yearText) · \(movie.durationText)"
    }
}

struct MovieDetailImage: View {
    
    @StateObject private var imageLoader = ImageLoader()
    let imageURL: URL
    
    var body: some View {
        ZStack {
            Color.gray.opacity(0.3)
            if let image = imageLoader.image {
                Image(uiImage: image)
                    .resizable()
            }
        }
        .aspectRatio(16/9, contentMode: .fit)
        .onAppear { imageLoader.loadImage(with: imageURL) }
    }
}

extension URL: Identifiable {
    
    public var id: Self { self }
}
*/
