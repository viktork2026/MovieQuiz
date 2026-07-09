//
//  MovieQuizPresenterTests.swift
//  MovieQuiz
//
//  Created by Viktor Kim on 09.07.2026.
//

import XCTest

@testable import MovieQuiz

final class MovieQuizPresenterTests: XCTestCase {
    private var viewController: MockMovieQuizViewController!
    private var presenter: MovieQuizPresenter!

    override func setUp() {
        super.setUp()

        viewController = MockMovieQuizViewController()

        presenter = MovieQuizPresenter(
            on: viewController,
            statisticService: StubStatisticService(),
            questionFactory: StubQuestionFactory()
        )
    }

    func testPresenter_whenDidReceiveNextQuestion_correctlyConvertsData() {
        let question = QuizQuestion(
            movieTitle: "Movie 1",
            imageData: Data(),
            text: "Text 1",
            correctAnswer: true
        )
        let expected = QuizStepViewData(
            movieTitle: question.movieTitle,
            imageData: question.imageData,
            question: question.text,
            questionNumber: "1/10"
        )

        presenter.didReceiveNextQuestion(question: question)

        let actual = viewController.quizStepViewData
        XCTAssertEqual(actual, expected)
    }
}
