import UIKit

final class MovieQuizViewController: UIViewController {
    @IBOutlet private weak var indexLabel: UILabel!
    @IBOutlet private weak var previewImage: UIImageView!
    @IBOutlet private weak var questionLabel: UILabel!
    @IBOutlet private weak var noButton: UIButton!
    @IBOutlet private weak var yesButton: UIButton!
    @IBOutlet private weak var loadingIndicator: UIActivityIndicatorView!

    private var alertPresenter: AlertPresenter!
    private var quizPresenter: MovieQuizPresenter!

    override func viewDidLoad() {
        super.viewDidLoad()

        alertPresenter = AlertPresenter(on: self)
        quizPresenter = MovieQuizAssembly.makePresenter(on: self)

        setupImageBorder()

        quizPresenter.loadData()
    }

    @IBAction private func noButtonDidTap(_ sender: UIButton) {
        quizPresenter.handleAnswer(false)
    }

    @IBAction private func yesButtonDidTap(_ sender: UIButton) {
        quizPresenter.handleAnswer(true)
    }

    private func setupImageBorder() {
        previewImage.layer.masksToBounds = true
        previewImage.layer.borderWidth = 8
        previewImage.layer.cornerRadius = 20
    }

    private func showImageBorder(color: UIColor) {
        previewImage.layer.borderColor = color.cgColor
    }

    private func hideImageBorder() {
        previewImage.layer.borderColor = UIColor.clear.cgColor
    }

    private func showLoadingIndicator() {
        loadingIndicator.startAnimating()
    }

    private func hideLoadingIndicator() {
        loadingIndicator.stopAnimating()
    }

    private func enableButtons() {
        noButton.isUserInteractionEnabled = true
        yesButton.isUserInteractionEnabled = true
    }

    private func disableButtons() {
        noButton.isUserInteractionEnabled = false
        yesButton.isUserInteractionEnabled = false
    }
}

extension MovieQuizViewController: MovieQuizView {
    func show(step: QuizStepViewData) {
        DispatchQueue.main.async { [weak self] in
            guard let self else {
                return
            }

            indexLabel.text = step.questionNumber
            previewImage.image = UIImage(data: step.imageData) ?? UIImage()
            previewImage.accessibilityIdentifier = step.movieTitle
            questionLabel.text = step.question
        }
    }

    func show(results: QuizResultsViewData, completion: @escaping () -> Void) {
        let alertConfiguration = AlertConfiguration(
            title: results.title,
            message: results.text,
            buttonText: results.buttonText,
            completion: completion
        )

        DispatchQueue.main.async { [weak self] in
            self?.alertPresenter.show(with: alertConfiguration)
        }
    }

    func showLoading() {
        DispatchQueue.main.async { [weak self] in
            self?.showLoadingIndicator()
        }
    }

    func hideLoading() {
        DispatchQueue.main.async { [weak self] in
            self?.hideLoadingIndicator()
        }
    }

    func showNetworkError(message: String, completion: @escaping () -> Void) {
        let alertConfiguration = AlertConfiguration(
            title: "Что-то пошло не так(",
            message: "Невозможно загрузить данные",
            buttonText: "Попробовать еще раз",
            completion: completion
        )

        DispatchQueue.main.async { [weak self] in
            self?.alertPresenter.show(with: alertConfiguration)
        }
    }

    func showAnswerResult(isCorrect: Bool, completion: @escaping () -> Void) {
        let color = isCorrect ? UIColor.ypGreen : UIColor.ypRed

        DispatchQueue.main.async { [weak self] in
            guard let self else {
                return
            }

            disableButtons()
            showImageBorder(color: color)

            DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
                guard let self else {
                    return
                }

                hideImageBorder()
                enableButtons()

                completion()
            }
        }
    }
}
