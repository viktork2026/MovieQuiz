//
//  MostPopularMovies.swift
//  MovieQuiz
//
//  Created by Viktor Kim on 26.06.2026.
//

import Foundation

struct MostPopularMovies: Codable {
    let errorMessage: String
    let items: [MostPopularMovie]
}

struct MostPopularMovie: Codable {
    private enum CadingKeys: String, CodingKey {
        case title = "fullTitle"
        case rating = "imDbRating"
        case imageURL = "image"
    }

    let title: String
    let rating: String
    let imageURL: URL
}
