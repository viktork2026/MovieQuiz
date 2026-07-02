//
//  URLSessionNetworkClient.swift
//  MovieQuiz
//
//  Created by Viktor Kim on 25.06.2026.
//
import Foundation

struct URLSessionNetworkClient {
    private enum FetchError: Error {
        case badStatusCode
        case noData
    }

    func fetch(url: URL, handler: @escaping (Result<Data, Error>) -> Void) {
        let request = URLRequest(url: url)

        let task = URLSession.shared.dataTask(with: request) {
            data,
            response,
            error in

            if let error {
                handler(.failure(error))
                return
            }

            guard
                let response = response as? HTTPURLResponse,
                200..<300 ~= response.statusCode
            else {
                handler(.failure(FetchError.badStatusCode))
                return
            }

            guard let data else {
                handler(.failure(FetchError.noData))
                return
            }

            handler(.success(data))
        }

        task.resume()
    }
}
