//
//  HomeView.swift
//  Moviepedia
//
//  Created by Missy on 22.05.2025.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var favoritesVM: FavoritesViewModel
    @EnvironmentObject var recommendationVM: RecommendationViewModel
        
    @State private var moviesNowPlaying: [Movie] = []
    @State private var moviesPopular: [Movie] = []
    @State private var moviesUpcoming: [Movie] = []
    
    @State private var useMockData = false // mock data toggle
    @State private var isLoading = true
    @State private var hasAppeared = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading) {
                    if !recommendationVM.recommendedMovies.isEmpty {
                        VStack(alignment: .leading) {
                            Text("Hoşgeldin, User") // fixle burayı :)
                                .foregroundStyle(.white)
                                .font(.title)
                                .bold()
                                .padding(.horizontal, 20)
                            
                            Text("Bunları beğenebileceğini düşündük")
                                .foregroundStyle(.white)
                                .padding(.horizontal, 20)
                            
                            BackdropCarouselView(movies: recommendationVM.recommendedMovies)
                                .environmentObject(recommendationVM)
                                .padding(.top, -10)
                            
                        }
                        .padding(.top, 50)
                        .background(
                            Color(UIColor.systemGray).brightness(-0.4)
                                .ignoresSafeArea(edges: .top)
                        )
                    }
                    
                    
                    Text("Vizyonda")
                        .font(.title)
                        .bold()
                        .padding(.horizontal, 20)
                    
                    PosterCarouselView(movies: moviesNowPlaying)
                    
                    Text("Popüler")
                        .font(.title)
                        .bold()
                        .padding(.horizontal, 20)
                                        
                    PosterCarouselView(movies: moviesPopular)
                    
                    Text("Yakında")
                        .font(.title)
                        .bold()
                        .padding(.horizontal, 20)
                    
                    PosterCarouselView(movies: moviesUpcoming)
                    
                }
            }
            .ignoresSafeArea(edges: .top)
        }
        
        .onAppear {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithTransparentBackground()
            appearance.backgroundColor = UIColor.white
            appearance.titleTextAttributes = [.foregroundColor: UIColor.black]
            UINavigationBar.appearance().standardAppearance = appearance
            UINavigationBar.appearance().scrollEdgeAppearance = appearance
            
            
            if !MovieCache.shared.isMoviesLoaded {
                Task {
                    print("çekme 2 (load movies yollandı)")
                    await loadMovies()
                    MovieCache.shared.isMoviesLoaded = true
                }
            } else {
                // cache'den oku
                print("cacheden okuduuu")
                if !MovieCache.shared.nowPlayingMovies.isEmpty,
                   !MovieCache.shared.popularMovies.isEmpty,
                   !MovieCache.shared.upcomingMovies.isEmpty {
                    
                    moviesNowPlaying = MovieCache.shared.nowPlayingMovies
                    moviesPopular = MovieCache.shared.popularMovies
                    moviesUpcoming = MovieCache.shared.upcomingMovies
                }
                isLoading = false
            }
            
            Task {
                recommendationVM.listenToRecommendations()
            }
        }
        
        .onChange(of: favoritesVM.needsRefresh) {
            if favoritesVM.needsRefresh {
                print("refreshed homeview")
                Task {
                    recommendationVM.listenToRecommendations()
                }
                favoritesVM.needsRefresh = false
            }
        }
        
        .onDisappear {
            recommendationVM.detachListener()
        }
    }
    
    private func loadMovies() async {
        isLoading = true
        defer { isLoading = false }
        // if cache didn't work or first try
        do {
            let movieService = MovieAPIClient.sharedInstance
            let moviesNowPlayingFetch = try await movieService.fetchMovies(from: MovieListEndpoint.nowPlaying)
            let moviesPopularFetch = try await movieService.fetchMovies(from: MovieListEndpoint.popular)
            let moviesUpcomingFetch = try await movieService.fetchMovies(from: MovieListEndpoint.upcoming)
            
            MovieCache.shared.nowPlayingMovies = moviesNowPlayingFetch
            MovieCache.shared.popularMovies = moviesPopularFetch
            MovieCache.shared.upcomingMovies = moviesUpcomingFetch
            
            moviesNowPlaying = moviesNowPlayingFetch
            moviesPopular = moviesPopularFetch
            moviesUpcoming = moviesUpcomingFetch
        } catch {
            print("Error fetching movies: \(error.localizedDescription)")
        }
    }
}
