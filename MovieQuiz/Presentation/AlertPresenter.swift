//
//  AlertPresenter.swift
//  MovieQuiz
//
//  Created by Екатерина Владимирова on 08.01.2026.
//

import Foundation
import UIKit

final class AlertPresenter {
    func show(VC: UIViewController, model: AlertModel ) {
        let alert = UIAlertController(title: model.title, message: model.message, preferredStyle: .alert)
        let action = UIAlertAction(title: model.buttonText, style: .default) { _ in
            model.completion()
        }
        
        alert.addAction(action)
        VC.present(alert, animated: true, completion: nil)
    }
}
