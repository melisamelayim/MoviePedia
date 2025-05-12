//
//  MovieService.swift
//  Moviepedia
//
//  Created by Max on 11.12.2024.
//

import Foundation

// movie service protocol
protocol MovieService {
    func fetchMovies(from endpoint: MovieListEndpoint) async throws -> [Movie]
    func fetchMovie(id: Int) async throws -> Movie
    func searchMovie(query: String) async throws -> [Movie]
}

// enum for movie lists endpoints.
enum MovieListEndpoint: String, CaseIterable {
    case nowPlaying = "now_playing" //for snake case concerns...
    case upcoming
    case topRated = "top_rated"
    case popular
    //cases above are reachable by typing .rawValue,
    //and they are mainly used for api calls
    
    // .description returns strings, important for UI design
    var description: String {
        switch self {
            case .nowPlaying: return "Now Playing"
            case .upcoming: return "Upcoming"
            case .topRated: return "Top Rated"
            case .popular: return "Popular"
        }
    }
}

// usual error handling
enum MovieError: Error, CustomNSError {
    case apiError
    case invalidEndpoint
    case invalidResponse
    case noData
    case serializationError
    
    var localizedDescription: String {
        switch self {
        case .apiError: return "Failed to fetch data"
        case .invalidEndpoint: return "Invalid endpoint"
        case .invalidResponse: return "Invalid response"
        case .noData: return "No data"
        case .serializationError: return "Failed to decode data"
        }
    }
    
    var errorUserInfo: [String : Any] {
        [NSLocalizedDescriptionKey: localizedDescription]
    }
    
}
