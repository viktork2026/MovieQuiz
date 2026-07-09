//
//  StubStatisticService.swift
//  MovieQuiz
//
//  Created by Viktor Kim on 09.07.2026.
//

import Foundation

@testable import MovieQuiz

final class StubStatisticService: StatisticService {
    let quizzesPlayed: Int = 0

    let bestQuizResult: QuizResult = .init(
        questionsCount: 0,
        correctAnswersCount: 0,
        date: Date()
    )

    let averageAccuracy: Double = 0

    func store(result: QuizResult) {}
}
