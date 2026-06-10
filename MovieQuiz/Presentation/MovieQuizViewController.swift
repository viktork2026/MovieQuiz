import UIKit

final class MovieQuizViewController: UIViewController, QuestionFactoryDelegate {
    // MARK: - IBOutlet
    @IBOutlet private weak var indexLabel: UILabel!
    @IBOutlet private weak var previewImage: UIImageView!
    @IBOutlet private weak var questionLabel: UILabel!
    @IBOutlet private weak var noButton: UIButton!
    @IBOutlet private weak var yesButton: UIButton!

    // MARK: - Private properties
    private var alertPresenter: AlertPresenter?

    private let questionCount: Int = 10
    private var questionFactory: QuestionFactory?

    private var currentQuestion: QuizQuestion?
    private var currentQuestionIndex: Int = 1
    private var correctAnswerCount: Int = 0

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        alertPresenter = AlertPresenter(on: self)
        questionFactory = MockQuestionFactory(delegate: self)

        setupAnswerResultView()
        startNewQuiz()
    }

    // MARK: - QuestionFactoryDelegate
    func didReceiveNextQuestion(question: QuizQuestion?) {
        guard let question else {
            return
        }

        currentQuestion = question
        let quizStep = convert(model: question)

        DispatchQueue.main.async { [weak self] in
            self?.show(step: quizStep)
        }
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
        let alertConfiguration = AlertConfiguration(
            title: result.title,
            message: result.text,
            buttonText: result.buttonText,
            completion: { [weak self] in
                self?.startNewQuiz()
            }
        )

        alertPresenter?.show(with: alertConfiguration)
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
        currentQuestion = nil
        currentQuestionIndex = 1
        correctAnswerCount = 0

        questionFactory?.requestNextQuestion()
    }

    private func showNextQuestionOrResults() {
        if currentQuestionIndex == questionCount {
            let result = QuizResultsViewModel(
                title: "Этот раунд окончен!",
                text:
                    "Ваш результат: \(correctAnswerCount)/\(questionCount)",
                buttonText: "Сыграть еще раз",
            )
            show(result: result)
        } else {
            currentQuestionIndex += 1
            questionFactory?.requestNextQuestion()
        }
    }

    private func handleAnswer(_ userAnswer: Bool) {
        guard let currentQuestion else {
            return
        }

        disableButtons()

        let isCorrect = userAnswer == currentQuestion.correctAnswer

        if isCorrect {
            correctAnswerCount += 1
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
            questionNumber: "\(currentQuestionIndex)/\(questionCount)"
        )
    }
}
