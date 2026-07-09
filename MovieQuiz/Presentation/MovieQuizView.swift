//
//  MovieQuizView.swift
//  MovieQuiz
//
//  Created by Viktor Kim on 09.07.2026.
//

protocol MovieQuizView: AnyObject {
    func show(step: QuizStepViewData)
    func show(results: QuizResultsViewData, completion: @escaping () -> Void)

    func showLoading()
    func hideLoading()

    func showNetworkError(message: String, completion: @escaping () -> Void)

    func showAnswerResult(isCorrect: Bool, completion: @escaping () -> Void)
}
