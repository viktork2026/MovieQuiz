//
//  NetworkImageLoader.swift
//  MovieQuiz
//
//  Created by Viktor Kim on 01.07.2026.
//

import Foundation

protocol ImageLoader {
    func loadImage(url: URL, handler: @escaping (Result<Data, Error>) -> Void)
}

struct NetworkImageLoader: ImageLoader {
    private let networkClient: URLSessionNetworkClient = .init()

    func loadImage(url: URL, handler: @escaping (Result<Data, Error>) -> Void) {
        networkClient.fetch(url: url, handler: handler)
    }
}
