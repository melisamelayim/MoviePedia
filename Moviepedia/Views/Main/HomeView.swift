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
                VStack(alignment: .leading, spacing: 10) {
                    if isLoading {
                        ProgressView("Yükleniyor...")
                            .frame(maxWidth: .infinity)
                            .padding()
                    } else {
                        if !recommendationVM.recommendedMovies.isEmpty {
                            VStack(alignment: .leading) {
                                Text("Senin İçin Önerilenler")
                                    .font(.title)
                                    .bold()
                                    .padding(.horizontal, 20)
                                    .padding(.top, 10)
                                
                                BackdropCarouselView(movies: recommendationVM.recommendedMovies)
                                    .environmentObject(recommendationVM)
                                
                                    .padding(.top, -10)
                            }
                        }
                        
                        Text("Vizyonda")
                            .font(.title)
                            .bold()
                            .padding(.horizontal, 20)
                            .padding(.top, 10)
                        
                        PosterCarouselView(movies: moviesNowPlaying)
                        
                        Text("Popüler")
                            .font(.title)
                            .bold()
                            .padding(.horizontal, 20)
                            .padding(.top, -85)
                            
                        
                        PosterCarouselView(movies: moviesPopular)
                            .padding(.top, -50)
                        
                        
                        
                        Text("Yakında")
                            .font(.title)
                            .bold()
                            .padding(.top, -85)
                            .padding(.horizontal, 20)
                        
                        PosterCarouselView(movies: moviesUpcoming)
                            .padding(.top, -50)
                        
                    }
                    
                }
            }
            .background(Color.pink.opacity(0.2).edgesIgnoringSafeArea(.all))
            .navigationTitle("Moviepedia")
            .onAppear {
                let appearance = UINavigationBarAppearance()
                appearance.configureWithTransparentBackground()
                appearance.backgroundColor = UIColor.white
                appearance.titleTextAttributes = [.foregroundColor: UIColor.black]
                UINavigationBar.appearance().standardAppearance = appearance
                UINavigationBar.appearance().scrollEdgeAppearance = appearance
                
                if useMockData {
                    loadMockData()
                } else {
                    Task {
                        await loadMovies()
                    }
                }
                
                guard !hasAppeared else { return }
                        hasAppeared = true
                Task {
                    recommendationVM.listenToRecommendations()
                }
                favoritesVM.fetchAll() // bi bak
                
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
    }
    
    private func loadMockData() {
        moviesNowPlaying = Movie.stubbedMovies
        moviesPopular = Movie.stubbedMovies
    }
    
    private func loadMovies() async {
        isLoading = true
        defer { isLoading = false }
        
        // if cache is usable
        if !MovieCache.shared.nowPlayingMovies.isEmpty,
           !MovieCache.shared.popularMovies.isEmpty,
           !MovieCache.shared.upcomingMovies.isEmpty {
            
            moviesNowPlaying = MovieCache.shared.nowPlayingMovies
            moviesPopular = MovieCache.shared.popularMovies
            moviesUpcoming = MovieCache.shared.upcomingMovies
            return
        }
        
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


//#Preview {
//    HomeView()
//}

