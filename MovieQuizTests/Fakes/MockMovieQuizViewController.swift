//
//  MockMovieQuizViewController.swift
//  MovieQuiz
//
//  Created by Viktor Kim on 09.07.2026.
//

@testable import MovieQuiz

final class MockMovieQuizViewController {
    var quizStepViewData: QuizStepViewData?
}

extension MockMovieQuizViewController: MovieQuizView {
    func show(step: QuizStepViewData) {
        quizStepViewData = step
    }

    func show(
        results: QuizResultsViewData,
        completion: @escaping () -> Void
    ) {

    }

    func showLoading() {

    }

    func hideLoading() {

    }

    func showNetworkError(message: String, completion: @escaping () -> Void) {

    }

    func showAnswerResult(isCorrect: Bool, completion: @escaping () -> Void) {

    }
}
