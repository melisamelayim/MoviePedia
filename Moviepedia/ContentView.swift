//
//  ContentView.swift
//  Moviepedia
//
//  Created by Max on 28.11.2024.
//

// favorites & auth, search optimization later.

import SwiftUI

struct ContentView: View {
    @StateObject private var userMovieState = UserMovieState()
    @StateObject private var recommendationVM = RecommendationViewModel()
    
    private let userId = "user123"
    
    @State private var moviesNowPlaying: [Movie] = []
    @State private var moviesPopular: [Movie] = []
    @State private var moviesUpcoming: [Movie] = []
    
    @State private var useMockData = false // mock data toggle
    @State private var isLoading = true
    
    init() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.backgroundColor = UIColor.white
        appearance.titleTextAttributes = [.foregroundColor: UIColor.black]
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    if isLoading {
                        ProgressView("Loading...")
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
                                
                                PosterCarouselView(
                                    items: recommendationVM.recommendedMovies.map { .recommended($0) }, userMovieState: userMovieState
                                )
                                .padding(.top, -10)
                            }
                        }
                        
                        HStack{
                            Text("Vizyonda")
                                .font(.title)
                                .bold()
                                .padding(.horizontal, 20)
                                .padding(.top, 25)
                            
                            Button(action: {
                                Task {
                                    MovieCache.shared.nowPlayingMovies = []
                                    MovieCache.shared.popularMovies = []
                                    MovieCache.shared.upcomingMovies = []
                                    await loadMovies()
                                }
                            }) {
                                Text("Yenile")
                                    .foregroundColor(.blue)
                                    .padding(10)
                                    .background(
                                        RoundedRectangle(cornerRadius: 10)
                                            .stroke(Color.blue, lineWidth: 2)
                                    )
                                    .padding(.horizontal, 10)
                                    .padding(.top, 25)
                            }
                        }
                        
                        PosterCarouselView(
                            items: moviesNowPlaying.map { .movie($0) },
                            userMovieState: userMovieState
                        )
                            .padding(.top, -25)
                        
                        Text("Popüler")
                            .font(.title)
                            .bold()
                            .padding(.top, -15)
                            .padding(.horizontal, 20)
                            
                        BackdropCarouselView(movies: moviesPopular)
                            .padding(.top, -25)
                        
                        Text("Yakında")
                            .font(.title)
                            .bold()
                            .padding(.top, -80)
                            .padding(.horizontal, 20)

                        BackdropCarouselView(movies: moviesUpcoming)
                            .padding(.top, -70)
                    }
                    
                }
            }
            .background(Color.pink.opacity(0.2).edgesIgnoringSafeArea(.all))
            .navigationTitle("Moviepedia")
            .onAppear {
                if useMockData {
                    loadMockData()
                } else {
                    Task {
                        await loadMovies()
                    }
                }
                recommendationVM.fetchRecommendations(for: userId)
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

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}



