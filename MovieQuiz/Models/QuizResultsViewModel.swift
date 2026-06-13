//
//  QuizResultsViewModel.swift
//  MovieQuiz
//
//  Created by Viktor Kim on 09.06.2026.
//

struct QuizResultsViewModel {
    let title: String
    let text: String
    let buttonText: String

    init(title: String, text: String, buttonText: String) {
        self.title = title
        self.text = text
        self.buttonText = buttonText
    }

    init(
        title: String,
        quizResult: QuizResult,
        statisticService: StatisticService,
        buttonText: String
    ) {
        let averageAccuracy = statisticService.averageAccuracy.formatted(
            .percent.precision(.fractionLength(2))
        )

        let text = """
            Ваш результат: \(quizResult.correctAnswersCount)/\(quizResult.questionsCount)
            Количество сыгранных квизов: \(statisticService.quizzesPlayed)
            Рекорд: \(statisticService.bestQuizResult)
            Средняя точность: \(averageAccuracy)
            """

        self.init(title: title, text: text, buttonText: buttonText)
    }
}
