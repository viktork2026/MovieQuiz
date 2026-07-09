//
//  MovieQuizPresenter.swift
//  MovieQuiz
//
//  Created by Viktor Kim on 08.07.2026.
//

import Foundation

final class MovieQuizPresenter {
    private weak var view: MovieQuizView?

    private let statisticService: StatisticService
    private let questionFactory: QuestionFactory

    private let questionsCount: Int = 10

    private var correctAnswersCount: Int = 0
    private var currentQuestionIndex: Int = 1
    private var currentQuestion: QuizQuestion?

    init(
        on view: MovieQuizView,
        statisticService: StatisticService,
        questionFactory: QuestionFactory
    ) {
        self.view = view
        self.statisticService = statisticService
        self.questionFactory = questionFactory
    }

    func loadData() {
        guard let view else {
            return
        }

        view.showLoading()
        questionFactory.loadData()
    }

    func handleAnswer(_ userAnswer: Bool) {
        guard
            let currentQuestion,
            let view
        else {
            return
        }

        let isCorrect = userAnswer == currentQuestion.correctAnswer

        if isCorrect {
            correctAnswersCount += 1
        }

        view.showAnswerResult(isCorrect: isCorrect) {
            [weak self] in

            self?.showNextQuestionOrResults()
        }
    }

    private func startNewQuiz() {
        correctAnswersCount = 0
        currentQuestionIndex = 1
        currentQuestion = nil

        questionFactory.requestNextQuestion()
    }

    private func showNextQuestionOrResults() {
        guard let view else {
            return
        }

        if currentQuestionIndex == questionsCount {
            saveCurrentResult()

            let results = makeResultsViewData()
            view.show(results: results) { [weak self] in
                self?.startNewQuiz()
            }
        } else {
            view.showLoading()
            currentQuestionIndex += 1
            questionFactory.requestNextQuestion()
        }
    }

    private func saveCurrentResult() {
        let result = QuizResult(
            questionsCount: questionsCount,
            correctAnswersCount: correctAnswersCount,
            date: Date()
        )

        statisticService.store(result: result)
    }

    private func makeResultsViewData() -> QuizResultsViewData {
        let averageAccuracy = statisticService.averageAccuracy.formatted(
            .percent.precision(.fractionLength(2))
        )

        let text = """
            Ваш результат: \(correctAnswersCount)/\(questionsCount)
            Количество сыгранных квизов: \(statisticService.quizzesPlayed)
            Рекорд: \(statisticService.bestQuizResult)
            Средняя точность: \(averageAccuracy)
            """

        return QuizResultsViewData(
            title: "Этот раунд окончен!",
            text: text,
            buttonText: "Сыграть еще раз"
        )
    }

    private func convert(question: QuizQuestion) -> QuizStepViewData {
        .init(
            movieTitle: question.movieTitle,
            imageData: question.imageData,
            question: question.text,
            questionNumber: "\(currentQuestionIndex)/\(questionsCount)"
        )
    }
}

extension MovieQuizPresenter: QuestionFactoryDelegate {
    func didReceiveNextQuestion(question: QuizQuestion?) {
        guard
            let question,
            let view
        else {
            return
        }

        currentQuestion = question

        let step = convert(question: question)

        view.hideLoading()
        view.show(step: step)
    }

    func didLoadData() {
        guard let view else {
            return
        }

        view.hideLoading()
        startNewQuiz()
    }

    func didFailToLoadData(with error: Error) {
        guard let view else {
            return
        }

        view.hideLoading()
        view.showNetworkError(message: error.localizedDescription) {
            [weak self] in

            self?.loadData()
        }
    }
}
