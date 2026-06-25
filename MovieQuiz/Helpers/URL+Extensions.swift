//
//  URL+Extensions.swift
//  MovieQuiz
//
//  Created by Viktor Kim on 26.06.2026.
//

import Foundation

extension URL {
    init(staticString string: StaticString) {
        guard let url = URL(string: "\(string)") else {
            preconditionFailure("Invalid URL: \(string)")
        }

        self = url
    }
}
