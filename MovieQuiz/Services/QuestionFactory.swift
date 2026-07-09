//
//  QuestionFactory.swift
//  MovieQuiz
//
//  Created by Viktor Kim on 09.06.2026.
//

protocol QuestionFactory {
    func configure(with delegate: QuestionFactoryDelegate?)
    func requestNextQuestion()
    func loadData()
}
