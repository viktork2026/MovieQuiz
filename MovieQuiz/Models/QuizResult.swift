//
//  QuizResult.swift
//  MovieQuiz
//
//  Created by Viktor Kim on 13.06.2026.
//

import Foundation

struct QuizResult {
    let questionsCount: Int
    let correctAnswersCount: Int
    let date: Date

    func isBetter(than other: QuizResult) -> Bool {
        correctAnswersCount > other.correctAnswersCount
    }
}

extension QuizResult: CustomStringConvertible {
    var description: String {
        "\(correctAnswersCount)/\(questionsCount) (\(date.dateTimeString))"
    }
}
