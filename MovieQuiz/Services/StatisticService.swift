//
//  StatisticService.swift
//  MovieQuiz
//
//  Created by Viktor Kim on 13.06.2026.
//

protocol StatisticService {
    var quizzesPlayed: Int { get }
    var bestQuizResult: QuizResult { get }
    var averageAccuracy: Double { get }

    func store(result: QuizResult)
}
