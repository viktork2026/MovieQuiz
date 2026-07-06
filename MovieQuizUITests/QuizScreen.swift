//
//  QuizScreen.swift
//  MovieQuiz
//
//  Created by Viktor Kim on 06.07.2026.
//

import XCTest

struct QuizScreen {
    private let app: XCUIApplication
    private let timeout: TimeInterval

    private var questionIndex: XCUIElement { app.staticTexts["questionIndex"] }
    private var previewImage: XCUIElement { app.images.firstMatch }
    private var noButton: XCUIElement { app.buttons["noButton"] }
    private var yesButton: XCUIElement { app.buttons["yesButton"] }
    private var roundEndAlert: XCUIElement { app.alerts["roundEndAlert"] }
    private var playAgainButton: XCUIElement {
        roundEndAlert.buttons.firstMatch
    }

    init(app: XCUIApplication, timeout: TimeInterval = 3.0) {
        self.app = app
        self.timeout = timeout
    }

    func verifyQuestionIndexIs(index: String) {
        let expectation = XCTNSPredicateExpectation(
            predicate: NSPredicate(format: "label == '\(index)'"),
            object: questionIndex
        )

        let result = XCTWaiter().wait(for: [expectation], timeout: timeout)
        XCTAssertEqual(result, .completed)
    }

    func getPreviewImageIdentifier() -> String {
        previewImage.identifier
    }

    func verifyPreviewImageChanged(from oldIdentifier: String) {
        let expectation = XCTNSPredicateExpectation(
            predicate: NSPredicate(format: "identifier != %@", oldIdentifier),
            object: previewImage
        )

        let result = XCTWaiter().wait(for: [expectation], timeout: timeout)
        XCTAssertEqual(result, .completed)
    }

    func tapNo() {
        noButton.tap()
    }

    func tapYes() {
        yesButton.tap()
    }

    func tapPlayAgain() {
        playAgainButton.tap()
    }

    func answerAllQuestions() {
        for questionNumber in 1...10 {
            let identifier = getPreviewImageIdentifier()

            tapYes()

            if questionNumber < 10 {
                verifyPreviewImageChanged(from: identifier)
            }
        }
    }

    func verifyRoundEndAlertIsShown() {
        let alert = roundEndAlert
        guard alert.waitForExistence(timeout: timeout) else {
            XCTFail("Round end alert doesn't exist")
            return
        }

        let playAgainButton = alert.buttons.firstMatch

        XCTAssertEqual(alert.label, "Этот раунд окончен!")
        XCTAssertEqual(playAgainButton.label, "Сыграть еще раз")
    }
}
