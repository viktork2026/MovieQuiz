//
//  QuestionFactoryDelegate.swift
//  MovieQuiz
//
//  Created by Viktor Kim on 10.06.2026.
//

protocol QuestionFactoryDelegate: AnyObject {
    func didReceiveNextQuestion(question: QuizQuestion?)
    func didLoadData()
    func didFailToLoadData(with error: Error)
}
