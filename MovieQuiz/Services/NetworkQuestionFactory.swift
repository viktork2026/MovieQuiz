//
//  NetworkQuestionFactory.swift
//  MovieQuiz
//
//  Created by Viktor Kim on 29.06.2026.
//

import Foundation

final class NetworkQuestionFactory: QuestionFactory {
    private struct APIError: Error {}

    private let movieLoader: MovieLoader
    private weak var delegate: QuestionFactoryDelegate?

    private var movies: [MostPopularMovie] = []

    init(movieLoader: MovieLoader, delegate: QuestionFactoryDelegate?) {
        self.movieLoader = movieLoader
        self.delegate = delegate
    }

    func requestNextQuestion() {
        guard let movie = movies.randomElement() else {
            return
        }

        let rating = Float(movie.rating) ?? 0
        let (text, correctAnswer) = generateRandomQuestion(with: rating)

        URLSession.shared.dataTask(with: movie.resizedImageURL) { data, _, _ in
            let imageData = data ?? Data()
            let question = QuizQuestion(
                imageData: imageData,
                text: text,
                correctAnswer: correctAnswer
            )

            DispatchQueue.main.async { [weak self] in
                self?.delegate?.didReceiveNextQuestion(question: question)
            }
        }.resume()
    }

    func loadData() {
        movieLoader.loadMovies { result in
            DispatchQueue.main.async { [weak self] in
                guard let self else {
                    return
                }

                switch result {
                case .success(let movies):
                    guard movies.errorMessage.isEmpty else {
                        self.delegate?.didFailToLoadData(
                            with: APIError()
                        )
                        return
                    }
                    self.movies = movies.items
                    self.delegate?.didLoadData()
                case .failure(let error):
                    self.delegate?.didFailToLoadData(with: error)
                }
            }
        }
    }

    private func generateRandomQuestion(with rating: Float) -> (
        text: String, correctAnswer: Bool
    ) {
        enum QuestionType: CaseIterable {
            case greater
            case less
        }

        switch QuestionType.allCases.randomElement()! {
        case .greater:
            let randomRating = Int.random(in: 1...9)
            return (
                "Рейтинг этого фильма больше чем \(randomRating)?",
                rating > Float(randomRating)
            )
        case .less:
            let randomRating = Int.random(in: 2...10)
            return (
                "Рейтинг этого фильма меньше чем \(randomRating)?",
                rating < Float(randomRating)
            )
        }
    }
}
