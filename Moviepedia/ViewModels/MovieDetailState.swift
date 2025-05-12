//
//  MovieDetailState.swift
//  Moviepedia
//
//  Created by Max on 17.01.2025.
//

import SwiftUI

@MainActor // guarantees all functions and variables used in this class works on the "main thread". important for UI updates.
// this class is a "state management layer" for MovieDetailView, which means it checks whether the detail data is successfully fetched or it failed.
class MovieDetailState: ObservableObject {
    
    private let movieService: MovieService
    @Published private(set) var phase: DataFetchPhase<Movie> = .empty // private(set) because variable can be read from outside but only changeable in the class.
    
    // if the phase value is successful then it means there's no problem, movie is movie. that's it. check DataFetchPhase for more details.
    var movie: Movie? {
        phase.value ?? nil
    }
    
    init(movieService: MovieService = MovieAPIClient.sharedInstance) { // we initialized MovieService bc "dependency injection"
        self.movieService = movieService
    }
    
    func loadMovie(id: Int) async {
        if Task.isCancelled { return } // if task gets cancelled (user leaves the current detail view page) we stop loading
        phase = .empty // turn phase into empty bc we don't want user to see old data. this is a fresh starter.
        
        do {
            let movie = try await self.movieService.fetchMovie(id: id) // where magic happens
            phase = .success(movie) // magic happened. turn it into success
        } catch {
            phase = .failure(error) // throw error
        }
        
    }
    
}
