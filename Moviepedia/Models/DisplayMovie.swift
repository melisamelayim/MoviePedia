//
//  DisplayMovie.swift
//  Moviepedia
//
//  Created by Missy on 12.05.2025.
//

import Foundation

struct DisplayMovie: Identifiable {
    let id: Int
    let title: String
    let backdropPath: String?

    var backdropURL: URL? {
        guard let backdropPath = backdropPath else { return nil }
        return URL(string: "https://image.tmdb.org/t/p/w500\(backdropPath)")
    }
}
