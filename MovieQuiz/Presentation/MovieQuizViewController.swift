import UIKit

final class MovieQuizViewController: UIViewController {
    // MARK: - IBOutlet
    @IBOutlet private weak var indexLabel: UILabel!
    @IBOutlet private weak var previewImage: UIImageView!
    @IBOutlet private weak var questionLabel: UILabel!
    @IBOutlet private weak var noButton: UIButton!
    @IBOutlet private weak var yesButton: UIButton!

    // MARK: - Private properties
    private let questions: [QuizQuestion] = [
        .init(
            imageName: "The Godfather",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: true
        ),
        .init(
            imageName: "The Dark Knight",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: true
        ),
        .init(
            imageName: "Kill Bill",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: true
        ),
        .init(
            imageName: "The Avengers",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: true
        ),
        .init(
            imageName: "Deadpool",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: true
        ),
        .init(
            imageName: "The Green Knight",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: true
        ),
        .init(
            imageName: "Old",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: false
        ),
        .init(
            imageName: "The Ice Age Adventures of Buck Wild",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: false
        ),
        .init(
            imageName: "Tesla",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: false
        ),
        .init(
            imageName: "Vivarium",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: false
        ),
    ]
    private var currentQuestionIndex: Int = 0
    private var correctAnswersCount: Int = 0

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setupAnswerResultView()
        startNewQuiz()
    }

    // MARK: - IBAction
    @IBAction private func noButtonClicked(_ sender: UIButton) {
        handleAnswer(false)
    }

    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        handleAnswer(true)
    }

    // MARK: - UI Logic
    private func setupAnswerResultView() {
        previewImage.layer.masksToBounds = true
        previewImage.layer.borderWidth = 8
        previewImage.layer.cornerRadius = 20
    }

    private func show(step: QuizStepViewModel) {
        indexLabel.text = step.questionNumber
        previewImage.image = step.image
        questionLabel.text = step.question
    }

    private func show(result: QuizResultsViewModel) {
        let alert = UIAlertController(
            title: result.title,
            message: result.text,
            preferredStyle: .alert
        )

        let playAgain = UIAlertAction(title: result.buttonText, style: .default)
        { _ in
            result.buttonHandler()
        }
        alert.addAction(playAgain)

        present(alert, animated: true, completion: nil)
    }

    private func showAnswerResult(isCorrect: Bool) {
        let color = isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
        previewImage.layer.borderColor = color
    }

    private func hideAnswerResult() {
        previewImage.layer.borderColor = UIColor.clear.cgColor
    }

    private func disableButtons() {
        noButton.isUserInteractionEnabled = false
        yesButton.isUserInteractionEnabled = false
    }

    private func enableButtons() {
        noButton.isUserInteractionEnabled = true
        yesButton.isUserInteractionEnabled = true
    }

    // MARK: - Business Logic
    private func startNewQuiz() {
        currentQuestionIndex = 0
        correctAnswersCount = 0

        showQuizStep()
    }

    private func showQuizStep() {
        let currentQuestion = questions[currentQuestionIndex]
        let quizStep = convert(model: currentQuestion)
        show(step: quizStep)
    }

    private func showNextQuestionOrResults() {
        if currentQuestionIndex == questions.count - 1 {
            let result = QuizResultsViewModel(
                title: "Этот раунд окончен!",
                text:
                    "Ваш результат: \(correctAnswersCount)/\(questions.count)",
                buttonText: "Сыграть еще раз",
                buttonHandler: { [weak self] in
                    self?.startNewQuiz()
                },
            )
            show(result: result)
        } else {
            currentQuestionIndex += 1
            showQuizStep()
        }
    }

    private func handleAnswer(_ userAnswer: Bool) {
        disableButtons()

        let currentQuestion = questions[currentQuestionIndex]
        let isCorrect = userAnswer == currentQuestion.correctAnswer

        if isCorrect {
            correctAnswersCount += 1
        }

        showAnswerResult(isCorrect: isCorrect)

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self else { return }

            self.hideAnswerResult()
            self.showNextQuestionOrResults()
            self.enableButtons()
        }
    }

    // MARK: - Helpers
    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        .init(
            image: UIImage(named: model.imageName) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questions.count)"
        )
    }
}

private struct QuizQuestion {
    let imageName: String
    let text: String
    let correctAnswer: Bool
}

private struct QuizStepViewModel {
    let image: UIImage
    let question: String
    let questionNumber: String
}

private struct QuizResultsViewModel {
    let title: String
    let text: String
    let buttonText: String
    let buttonHandler: () -> Void
}
