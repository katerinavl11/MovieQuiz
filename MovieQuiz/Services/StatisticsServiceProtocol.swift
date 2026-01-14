//
//  StatisticsServiceProtocol.swift
//  MovieQuiz
//
//  Created by Екатерина Владимирова on 12.01.2026.
//

import Foundation

protocol StatisticServiceProtocol {
    var gamesCount: Int { get }
    var bestGame: GameResult { get }
    var totalAccuracy: Double { get }
    
    func store (result: GameResult)
}

struct GameResult {
    let correct: Int
    let total: Int
    let date: Date
    
    func isBetterThan (_ another: GameResult) -> Bool {
        correct > another.correct
    }
}
