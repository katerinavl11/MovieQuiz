//
//  AlertModel.swift
//  MovieQuiz
//
//  Created by Екатерина Владимирова on 08.01.2026.
//

import Foundation

struct AlertModel {
    var title: String
    var message: String
    var buttonText: String
    var completion: () -> Void
}
