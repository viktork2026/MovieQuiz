//
//  NetworkMovieLoaderTests.swift
//  MovieQuiz
//
//  Created by Viktor Kim on 03.07.2026.
//

import XCTest

@testable import MovieQuiz

final class NetworkMovieLoaderTests: XCTestCase {
    func testNetworkMovieLoader_whenFetchSucceeds_returnsMovies() throws {
        let stubNetworkClient = StubNetworkClient(emulateError: false)
        let loader = NetworkMovieLoader(networkClient: stubNetworkClient)

        let expectation = expectation(description: "Loading expectation")

        loader.loadMovies { result in
            switch result {
            case .success(let movies):
                XCTAssertEqual(movies.items.count, 2)
                expectation.fulfill()
            case .failure:
                XCTFail("Unexpected failure")
            }
        }

        waitForExpectations(timeout: 1)
    }

    func testNetworkMovieLoader_whenFetchFails_returnsError() throws {
        let stubNetworkClient = StubNetworkClient(emulateError: true)
        let loader = NetworkMovieLoader(networkClient: stubNetworkClient)

        let expectation = expectation(description: "Loading expectation")

        loader.loadMovies { result in
            switch result {
            case .success:
                XCTFail("Unexpected success")
            case .failure:
                expectation.fulfill()
            }
        }

        waitForExpectations(timeout: 1)
    }
}
