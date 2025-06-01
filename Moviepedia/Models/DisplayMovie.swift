//
//  RecommendedMovie.swift
//  Moviepedia
//
//  Created by Missy on 12.05.2025.
//

import Foundation

struct DisplayMovie: Identifiable {
    let id: Int
    let title: String
    let posterPath: String?

    var posterURL: URL? {
        guard let path = posterPath else { return nil }
        return URL(string: "https://image.tmdb.org/t/p/w500\(path)")
    }
}
