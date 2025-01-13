//
//  Movie.swift
//  Moviepedia
//
//  Created by Max on 2.12.2024.
//

import Foundation

//returns an array of movies.
struct MovieResponse: Codable {
    let results: [Movie]
}

//returns a single movie
struct Movie: Codable {
    
    let id: Int
    let title: String
    let backdropPath: String?
    let posterPath: String?
    let overview: String
    let voteAverage: Double
    let voteCount: Int
    let runtime: Int?
    
    var backdropURL: URL? {
        guard let backdropPath = backdropPath else { return nil }
        return URL(string: "https://image.tmdb.org/t/p/w500\(backdropPath)")
    }
    
    var posterURL: URL? {
        guard let posterPath = posterPath else { return nil }
        return URL(string: "https://image.tmdb.org/t/p/w500\(posterPath)")
    }

    
}
