//
//  AlertPresenter.swift
//  MovieQuiz
//
//  Created by Viktor Kim on 10.06.2026.
//
import UIKit

final class AlertPresenter {
    private weak var viewController: UIViewController?

    init(on viewController: UIViewController?) {
        self.viewController = viewController
    }

    func show(with configuration: AlertConfiguration) {
        let alert = UIAlertController(
            title: configuration.title,
            message: configuration.message,
            preferredStyle: .alert
        )

        let action = UIAlertAction(
            title: configuration.buttonText,
            style: .default
        ) { _ in
            configuration.completion()
        }

        alert.addAction(action)

        viewController?.present(alert, animated: true, completion: nil)
    }
}
