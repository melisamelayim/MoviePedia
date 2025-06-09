//
//  CollectionView.swift
//  Moviepedia
//
//  Created by Missy on 22.05.2025.
// melisamelayim@gmail.com

import SwiftUI

enum CollectionTab: String, CaseIterable, Identifiable {
    case favorites = "Favoriler"
    case watchlist = "Watchlist"

    var id: String { self.rawValue }
}

struct CollectionView: View {
    @EnvironmentObject var favoritesVM: FavoritesViewModel
    
    @State private var selectedTab: CollectionTab = .favorites
    @State private var allMovies: [Movie] = []
    @State private var hasAppeared = false

    private let columns = [
        GridItem(),
        GridItem(),
        GridItem()
    ]
    
    var body: some View {
        NavigationStack {
            VStack {
                Picker("Seç", selection: $selectedTab) {
                    ForEach(CollectionTab.allCases) { tab in
                        Text(tab.rawValue).tag(tab)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                
                ScrollView {
                    LazyVGrid(columns: columns) {
                        ForEach(moviesToShow, id: \.id) { movie in
                            NavigationLink(
                                destination: MovieDetailView(movieId: movie.id, movieTitle: movie.title)
                                    .environmentObject(favoritesVM)
                            ) {
                                PosterCardView(movie: movie)
                                    .environmentObject(favoritesVM)
                                    
                            }
                            
                        }
                    }
                    .padding()
                }
                
            }
            .navigationTitle("Koleksiyonum")
            
            .onAppear {
                Task {
                    await loadMoviesFromIDs()
                }
            }
            
            .onChange(of: favoritesVM.needsRefresh) {
                if favoritesVM.needsRefresh {
                    favoritesVM.fetchAll()
                    Task {
                        await loadMoviesFromIDs()
                    }
                    favoritesVM.needsRefresh = false
                }
            }

        }
    }
    
    private var moviesToShow: [Movie] {
        switch selectedTab {
        case .favorites:
            return allMovies.filter { favoritesVM.favoriteMovies.contains($0.id) }
        case .watchlist:
            return allMovies.filter { favoritesVM.watchlistMovies.contains($0.id) }
        }
    }
    
    private func loadMoviesFromIDs() async {
        allMovies = []

        let combinedIDs = favoritesVM.favoriteMovies.union(favoritesVM.watchlistMovies)

        for id in combinedIDs {
            do {
                let movie = try await MovieAPIClient.sharedInstance.fetchMovie(id: id)
                allMovies.append(movie)
            } catch {
                print("movie fetch error for ID \(id): \(error)")
            }
        }
    }
}
