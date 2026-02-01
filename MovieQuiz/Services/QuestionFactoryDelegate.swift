//
//  QuestionFactoryDelegate.swift
//  MovieQuiz
//
//  Created by Екатерина Владимирова on 06.01.2026.
//

import Foundation

protocol QuestionFactoryDelegate: AnyObject {
    func didReceiveNextQuestion (question: QuizQuestion?)
    func didLoadDataFromServer() // сообщение об успешной загрузке
    func didFailToLoadData(with error: Error) // сообщение об ошибке загрузки
}
