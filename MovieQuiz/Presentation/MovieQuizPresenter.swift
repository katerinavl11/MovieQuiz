//
//  MovieQuizPresenter.swift
//  MovieQuiz
//
//  Created by Екатерина Владимирова on 01.02.2026.
//

import Foundation

final class MovieQuizPresenter {
    
    private var currentQuestionIndex: Int = 0
    let questionsAmount = 10
    var currentQuestion: QuizQuestion?
    weak var viewController: MovieQuizViewController?
    
    func isLastQuestion() -> Bool {
           currentQuestionIndex == questionsAmount - 1
       }
       
       func resetQuestionIndex() {
           currentQuestionIndex = 0
       }
       
       func switchToNextQuestion() {
           currentQuestionIndex += 1
       }
    
    func convert (model: QuizQuestion) -> QuizStepViewModel {
        QuizStepViewModel(
//                    image: UIImage(data: model.image) ?? UIImage(),
                    image: model.image, // <- здесь убрали преобразование в UIImage и храним «сырые» данные
                    question: model.text,
                    questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)" // ОШИБКА: `currentQuestionIndex` и `questionsAmount` неопределены
                )
    }
    
    func yesButtonClicked() {
        let yesAnswer = true
        guard let currentQuestion = currentQuestion else {
            return
        }
        viewController?.showAnswerResult(isCorrect: yesAnswer == currentQuestion.correctAnswer)
    }
    
   func noButtonClicked() {
        let noAnswer = false
        guard let currentQuestion = currentQuestion else {
            return
        }
       viewController?.showAnswerResult(isCorrect: noAnswer == currentQuestion.correctAnswer)
    }
}
