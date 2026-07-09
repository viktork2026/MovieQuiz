//
//  StubQuestionFactory.swift
//  MovieQuiz
//
//  Created by Viktor Kim on 08.06.2026.
//

import Foundation
import UIKit

final class StubQuestionFactory: QuestionFactory {
    private weak var delegate: QuestionFactoryDelegate?

    init(delegate: QuestionFactoryDelegate? = nil) {
        self.delegate = delegate
    }

    private let predefinedData = [
        (
            movieTitle: "The Godfather",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: true
        ),
        (
            movieTitle: "The Dark Knight",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: true
        ),
        (
            movieTitle: "Kill Bill",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: true
        ),
        (
            movieTitle: "The Avengers",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: true
        ),
        (
            movieTitle: "Deadpool",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: true
        ),
        (
            movieTitle: "The Green Knight",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: true
        ),
        (
            movieTitle: "Old",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: false
        ),
        (
            movieTitle: "The Ice Age Adventures of Buck Wild",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: false
        ),
        (
            movieTitle: "Tesla",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: false
        ),
        (
            movieTitle: "Vivarium",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: false
        ),
    ]

    private var questions: [QuizQuestion] = []

    func configure(with delegate: QuestionFactoryDelegate?) {
        self.delegate = delegate
    }

    func requestNextQuestion() {
        let question = questions.randomElement()
        delegate?.didReceiveNextQuestion(question: question)
    }

    // Fast enough to be synchronous.
    func loadData() {
        questions = predefinedData.map { movieTitle, text, correctAnswer in
            let imageData = NSDataAsset(name: movieTitle)?.data ?? Data()
            return QuizQuestion(
                movieTitle: movieTitle,
                imageData: imageData,
                text: text,
                correctAnswer: correctAnswer
            )
        }

        delegate?.didLoadData()
    }
}
