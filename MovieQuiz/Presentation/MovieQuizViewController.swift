import UIKit

final class MovieQuizViewController: UIViewController, QuestionFactoryDelegate {
    // MARK: - Lifecycle
    
    //actions
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        let yesAnswer = true
        guard let currentQuestion = currentQuestion else {
            return
        }
        showAnswerResult(isCorrect: yesAnswer == currentQuestion.correctAnswer)
    }
    
    @IBAction private func noButtonClicked(_ sender: UIButton) {
        let noAnswer = false
        guard let currentQuestion = currentQuestion else {
            return
        }
        showAnswerResult(isCorrect: noAnswer == currentQuestion.correctAnswer)
    }
    
    //outlets
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var textLabel: UILabel!
    @IBOutlet private weak var counterLabel: UILabel!
    
    //properties
    private var currentQuestionIndex: Int = 0
    private var correctAnswers: Int = 0
    private let questionAmount = 10
    private var questionFactory: QuestionFactoryProtocol?
    private var currentQuestion: QuizQuestion?
    private var alertPresenter = AlertPresenter()
    private var statisticService: StatisticServiceProtocol!
    
    //lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        let questionFactory = QuestionFactory()
        questionFactory.delegate = self
        self.questionFactory = questionFactory
        questionFactory.requestNextQuestion()
        statisticService = StatisticService()
    }
        
    //question factory delegate
    func didReceiveNextQuestion(question: QuizQuestion?) {
            guard let question = question else {
                return
            }
            currentQuestion = question
            let viewModel = convert(model: question)
            DispatchQueue.main.async { [weak self] in
                self?.show(quiz: viewModel)
            }
        }
        
        //private methods
        private func convert (model: QuizQuestion) -> QuizStepViewModel {
            let image = UIImage(named: model.image) ?? UIImage()
            let question = model.text
            let questionNumber = "\(currentQuestionIndex + 1)/\(questionAmount)"
            
            return QuizStepViewModel(image: image, question: question, questionNumber: questionNumber)
        }
        
        private func show(quiz step: QuizStepViewModel) {
            imageView.layer.borderWidth = 0
            imageView.layer.cornerRadius = 20
            imageView.image = step.image
            textLabel.text = step.question
            counterLabel.text = step.questionNumber
        }
        
        private func show(quiz result: QuizResultsViewModel) {
            let model = AlertModel(title: result.title, message: result.text, buttonText: result.buttonText) { [weak self] in
                guard let self = self else { return }
                self.currentQuestionIndex = 0
                self.correctAnswers = 0
                self.questionFactory?.requestNextQuestion()
            }
                   
                alertPresenter.show(VC: self, model: model)
        }
        
        
        private func showAnswerResult(isCorrect: Bool) {
            imageView.layer.masksToBounds = true
            imageView.layer.borderWidth = 8
            if isCorrect == true {
                imageView.layer.borderColor = UIColor.ypGreen.cgColor
                correctAnswers += 1
            } else {
                imageView.layer.borderColor = UIColor.ypRed.cgColor
            }
            imageView.layer.cornerRadius = 20
            // запускаем задачу через 1 секунду c помощью диспетчера задач
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self ] in
                guard let self = self else { return }
                // код, который мы хотим вызвать через 1 секунду
                self.showNextQuestionOrResults()
            }
        }
        
        private func showNextQuestionOrResults() {
            if currentQuestionIndex == questionAmount - 1 {
                let currentResult = GameResult(correct: correctAnswers, total: questionAmount, date: Date())
                statisticService.store(result: currentResult)
                let quizResults = QuizResultsViewModel(title: "Этот раунд окончен!",
                                                       text: "Ваш результат: \(correctAnswers)/\(questionAmount)\nКоличество сыгранных квизов: \(statisticService.gamesCount)\nРекорд: \(statisticService.bestGame.correct)/\(statisticService.bestGame.total) \(statisticService.bestGame.date.dateTimeString)\nСредняя точность: \(String(format: "%.1f", statisticService.totalAccuracy))%",
                                                       buttonText: "Сыграть ещё раз")
                
                show(quiz: quizResults)
                
            } else {
                currentQuestionIndex += 1
                self.questionFactory?.requestNextQuestion()
            }
        }
        
    }
