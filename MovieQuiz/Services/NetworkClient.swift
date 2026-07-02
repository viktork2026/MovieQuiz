//
//  NetworkClient.swift
//  MovieQuiz
//
//  Created by Viktor Kim on 03.07.2026.
//

import Foundation

protocol NetworkClient {
    func fetch(url: URL, handler: @escaping (Result<Data, Error>) -> Void)
}
