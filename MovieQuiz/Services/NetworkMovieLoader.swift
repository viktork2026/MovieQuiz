//
//  NetworkMovieLoader.swift
//  MovieQuiz
//
//  Created by Viktor Kim on 26.06.2026.
//

import Foundation

protocol MovieLoader {
    func loadMovies(
        handler: @escaping (Result<MostPopularMovies, Error>) -> Void
    )
}

struct NetworkMovieLoader: MovieLoader {
    private let mostPopularMoviesUrl: URL = .init(
        staticString: "https://tv-api.com/en/API/Top250Movies/k_zcuw1ytf"
    )
    private let networkClient: NetworkClient

    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }

    func loadMovies(
        handler: @escaping (Result<MostPopularMovies, Error>) -> Void
    ) {
        networkClient.fetch(url: mostPopularMoviesUrl) { result in
            let result = result.flatMap { data in
                Result {
                    try JSONDecoder().decode(MostPopularMovies.self, from: data)
                }
            }

            handler(result)
        }
    }
}
