//
//  MovieQuizAssembly.swift
//  MovieQuiz
//
//  Created by Viktor Kim on 09.07.2026.
//

import UIKit

final class MovieQuizAssembly {
    static func makePresenter(on viewController: MovieQuizViewController)
        -> MovieQuizPresenter
    {
        let networkClient = URLSessionNetworkClient()

        let movieLoader = NetworkMovieLoader(networkClient: networkClient)
        let imageLoader = NetworkImageLoader(networkClient: networkClient)

        let questionFactory = NetworkQuestionFactory(
            movieLoader: movieLoader,
            imageLoader: imageLoader
        )

        let statisticService = UserDefaultsStatisticService()

        let presenter = MovieQuizPresenter(
            on: viewController,
            statisticService: statisticService,
            questionFactory: questionFactory
        )

        questionFactory.configure(with: presenter)

        return presenter
    }
}
