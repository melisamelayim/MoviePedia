//
//  MovieRepresentable.swift
//  Moviepedia
//
//  Created by Missy on 21.05.2025.
//

import Foundation

protocol MovieRepresentable {
    var id: Int { get }
    var title: String { get }
    var posterPath: String? { get }
}

extension Movie: MovieRepresentable {
}

extension DisplayMovie: MovieRepresentable {
}
