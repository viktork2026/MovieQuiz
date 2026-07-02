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

    init(delegate: QuestionFactoryDelegate?) {
        self.delegate = delegate
    }

    private let predefinedData = [
        (
            imageName: "The Godfather",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: true
        ),
        (
            imageName: "The Dark Knight",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: true
        ),
        (
            imageName: "Kill Bill",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: true
        ),
        (
            imageName: "The Avengers",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: true
        ),
        (
            imageName: "Deadpool",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: true
        ),
        (
            imageName: "The Green Knight",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: true
        ),
        (
            imageName: "Old",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: false
        ),
        (
            imageName: "The Ice Age Adventures of Buck Wild",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: false
        ),
        (
            imageName: "Tesla",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: false
        ),
        (
            imageName: "Vivarium",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: false
        ),
    ]

    private var questions: [QuizQuestion] = []

    func requestNextQuestion() {
        let question = questions.randomElement()
        delegate?.didReceiveNextQuestion(question: question)
    }

    // Fast enough to be synchronous.
    func loadData() {
        questions = predefinedData.map { imageName, text, correctAnswer in
            let imageData = NSDataAsset(name: imageName)?.data ?? Data()
            return QuizQuestion(
                imageData: imageData,
                text: text,
                correctAnswer: correctAnswer
            )
        }

        delegate?.didLoadData()
    }
}
