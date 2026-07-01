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
    private enum CodingKeys: String, CodingKey {
        case title = "fullTitle"
        case rating = "imDbRating"
        case imageURL = "image"
    }

    let title: String
    let rating: String
    let imageURL: URL

    var resizedImageURL: URL {
        let imageURLString = imageURL
            .absoluteString
            .components(separatedBy: "._")
            .first

        guard
            let imageURLString,
            let resizedImageURL = URL(
                string: imageURLString + "._V0_UX600_.jpg"
            )
        else {
            return imageURL
        }

        return resizedImageURL
    }
}
