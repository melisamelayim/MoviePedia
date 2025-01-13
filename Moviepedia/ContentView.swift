//
//  ContentView.swift
//  Moviepedia
//
//  Created by Max on 28.11.2024.
//

// fix content view, add details page(!). search optimization later.

import SwiftUI

struct ContentView: View {
    @State private var moviesNowPlaying: [Movie] = []
    @State private var moviesPopular: [Movie] = []
    @State private var useMockData = false // Mock data toggle
    @State private var isLoading = true // API çağrısı durumu
    
    init() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.backgroundColor = UIColor.white // Arka plan rengini beyaz yap
        appearance.titleTextAttributes = [.foregroundColor: UIColor.black] // Başlık rengini siyah yap
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
                        Text("Now Playing")
                            .font(.title)
                            .bold()
                            .padding(.horizontal, 20)
                            .padding(.top, 25)
                        PosterCarouselView(movies: moviesNowPlaying)
                            .padding(.top, -25)
                        
                        Text("Popular")
                            .font(.title)
                            .bold()
                            .padding(.top, -15)
                            .padding(.horizontal, 20)
                            
                        BackdropCarouselView(movies: moviesPopular)
                            .padding(.top, -25)
                    }
                }
            }
            .background(Color.blue.opacity(0.6).edgesIgnoringSafeArea(.all)) // Genel arka plan mavi
            .navigationTitle("Moviepedia")
            .onAppear {
                if useMockData {
                    loadMockData()
                } else {
                    Task {
                        await loadMovies()
                    }
                }
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
        
        do {
            let movieService = MovieAPIClient.sharedInstance
            let moviesNowPlayingFetch = try await movieService.fetchMovies(from: MovieListEndpoint.nowPlaying)
            let moviesPopularFetch = try await movieService.fetchMovies(from: MovieListEndpoint.popular)
            moviesNowPlaying = moviesNowPlayingFetch
            moviesPopular = moviesPopularFetch
        } catch {
            print("Error fetching movies: \(error.localizedDescription)")
        }
    }
}

// Preview Section
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}



