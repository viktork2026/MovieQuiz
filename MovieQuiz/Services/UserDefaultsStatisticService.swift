//
//  UserDefaultsStatisticService.swift
//  MovieQuiz
//
//  Created by Viktor Kim on 13.06.2026.
//

import Foundation

final class UserDefaultsStatisticService: StatisticService {
    private enum Keys: String {
        case quizzesPlayed
        case bestQuizResultQuestionsCount
        case bestQuizResultCorrectAnswersCount
        case bestQuizResultDate
        case totalQuestionsCount
        case totalCorrectAnswersCount
    }

    var quizzesPlayed: Int {
        get {
            storage.integer(forKey: Keys.quizzesPlayed.rawValue)
        }
        set {
            storage.set(newValue, forKey: Keys.quizzesPlayed.rawValue)
        }
    }

    var bestQuizResult: QuizResult {
        get {
            let questionsCount = storage.integer(
                forKey: Keys.bestQuizResultQuestionsCount.rawValue
            )

            let correctAnswersCount = storage.integer(
                forKey: Keys.bestQuizResultCorrectAnswersCount.rawValue
            )

            let dateKey = Keys.bestQuizResultDate.rawValue
            let date = storage.object(forKey: dateKey) as? Date ?? Date()

            return QuizResult(
                questionsCount: questionsCount,
                correctAnswersCount: correctAnswersCount,
                date: date
            )
        }

        set {
            storage.set(
                newValue.questionsCount,
                forKey: Keys.bestQuizResultQuestionsCount.rawValue
            )
            storage.set(
                newValue.correctAnswersCount,
                forKey: Keys.bestQuizResultCorrectAnswersCount.rawValue,
            )
            storage.set(
                newValue.date,
                forKey: Keys.bestQuizResultDate.rawValue
            )
        }

    }

    var averageAccuracy: Double {
        guard totalQuestionsCount > 0 else {
            return 0
        }

        return Double(totalCorrectAnswersCount) / Double(totalQuestionsCount)
    }

    private let storage: UserDefaults = .standard

    private var totalQuestionsCount: Int {
        get {
            storage.integer(forKey: Keys.totalQuestionsCount.rawValue)
        }
        set {
            storage.set(newValue, forKey: Keys.totalQuestionsCount.rawValue)
        }
    }

    private var totalCorrectAnswersCount: Int {
        get {
            storage.integer(forKey: Keys.totalCorrectAnswersCount.rawValue)
        }
        set {
            storage.set(
                newValue,
                forKey: Keys.totalCorrectAnswersCount.rawValue
            )
        }
    }

    func store(result: QuizResult) {
        quizzesPlayed += 1

        totalQuestionsCount += result.questionsCount
        totalCorrectAnswersCount += result.correctAnswersCount

        if result.isBetter(than: bestQuizResult) {
            bestQuizResult = result
        }
    }
}
