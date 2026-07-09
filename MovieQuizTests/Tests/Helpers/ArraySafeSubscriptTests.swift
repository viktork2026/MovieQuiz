//
//  ArraySafeSubscriptTests.swift
//  MovieQuiz
//
//  Created by Viktor Kim on 03.07.2026.
//

import XCTest

@testable import MovieQuiz

final class ArraySafeSubscriptTests: XCTestCase {
    func testSafeSubscript_whenIndexInRange_returnsElement() throws {
        let array = [0, 1, 2, 3]

        let value = array[safe: 2]

        XCTAssertNotNil(value)
        XCTAssertEqual(value, 2)
    }

    func testSafeSubscript_whenIndexOutOfRange_returnsNil() throws {
        let array = [0, 1, 2, 3]

        let value = array[safe: 20]

        XCTAssertNil(value)
    }
}
