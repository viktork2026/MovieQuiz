//
//  ArrayTests.swift
//  ArrayTests
//
//  Created by Viktor Kim on 03.07.2026.
//

import XCTest

@testable import MovieQuiz

final class ArrayTests: XCTestCase {
    func testGetValueInRange() throws {
        let array = [0, 1, 2, 3]

        let value = array[safe: 2]

        XCTAssertNotNil(value)
        XCTAssertEqual(value, 2)
    }

    func testGetValueOutOfRange() throws {
        let array = [0, 1, 2, 3]

        let value = array[safe: 20]

        XCTAssertNil(value)
    }
}
