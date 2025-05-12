//
//  RecommendedMovie.swift
//  Moviepedia
//
//  Created by Missy on 12.05.2025.
//

import Foundation

struct RecommendedMovie: Identifiable {
    let id: Int
    let title: String
    let posterPath: String
    let score: Double
    
    var posterURL: URL? {
        URL(string: "https://image.tmdb.org/t/p/w500\(posterPath)")
    }
}
