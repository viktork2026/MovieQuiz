//
//  MovieQuizUITests.swift
//  MovieQuizUITests
//
//  Created by Viktor Kim on 06.07.2026.
//

import XCTest

final class MovieQuizUITests: XCTestCase {
    private var app: XCUIApplication!
    private var screen: QuizScreen!

    override func setUpWithError() throws {
        try super.setUpWithError()

        continueAfterFailure = false

        app = XCUIApplication()
        app.launch()

        screen = QuizScreen(app: app)
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()

        screen = nil
        app = nil
    }

    func testQuiz_whenYesButtonTapped_proceedsToNextQuestion() {
        let identifier = screen.getPreviewImageIdentifier()

        screen.tapYes()

        screen.verifyQuestionIndexIs(index: "2/10")
        screen.verifyPreviewImageChanged(from: identifier)
    }

    func testQuiz_whenNoButtonTapped_proceedsToNextQuestion() {
        let identifier = screen.getPreviewImageIdentifier()

        screen.tapNo()

        screen.verifyQuestionIndexIs(index: "2/10")
        screen.verifyPreviewImageChanged(from: identifier)
    }

    func testQuiz_whenRoundEnds_alertAppearsAndDismisses() {
        screen.answerAllQuestions()

        screen.verifyRoundEndAlertIsShown()
        screen.tapPlayAgain()
        screen.verifyQuestionIndexIs(index: "1/10")
    }
}
