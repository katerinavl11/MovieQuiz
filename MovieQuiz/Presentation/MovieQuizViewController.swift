import UIKit

final class MovieQuizViewController: UIViewController, MovieQuizViewControllerProtocol {
    // MARK: - Lifecycle
    
    //actions
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        presenter.yesButtonClicked()
    }
    
    @IBAction private func noButtonClicked(_ sender: UIButton) {
        presenter.noButtonClicked()
    }
    
    //outlets
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var textLabel: UILabel!
    @IBOutlet private weak var counterLabel: UILabel!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    //properties
    private var alertPresenter = AlertPresenter()
    private var presenter: MovieQuizPresenter!
    
    //lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.layer.cornerRadius = 20
        presenter = MovieQuizPresenter(viewController: self)
    }
    
    
    //private methods
    func showLoadingIndicator() {
            activityIndicator.isHidden = false // говорим, что индикатор загрузки не скрыт
            activityIndicator.startAnimating() // включаем анимацию
        }
   
    func hideLoadingIndicator() {
            activityIndicator.isHidden = true
        }
    
    func showNetworkError (message: String) {
        hideLoadingIndicator()
        let errorAlert = AlertModel(title: "Ошибка", message: message, buttonText: "Попробовать еще раз") {[weak self] in
            guard let self = self else {return}
            //здесь тело замыкания - что происходит после нажатия на кнопку
            self.presenter.restartGame()
        }
        alertPresenter.show(VC: self, model: errorAlert)
    }
    
  
    
    func show(quiz step: QuizStepViewModel) {
        imageView.layer.borderWidth = 0
        imageView.layer.cornerRadius = 20
        imageView.image = UIImage(data: step.image) ?? UIImage()
        textLabel.text = step.question
        counterLabel.text = step.questionNumber
    }
    
    func show(quiz result: QuizResultsViewModel) {
        let model = AlertModel(title: result.title, message: result.text, buttonText: result.buttonText) { [weak self] in
            guard let self = self else { return }
            self.presenter.restartGame()
        }
        
        alertPresenter.show(VC: self, model: model)
    }
    
    func highlightImageBorder(isCorrectAnswer: Bool) {
            imageView.layer.masksToBounds = true
            imageView.layer.borderWidth = 8
            imageView.layer.borderColor = isCorrectAnswer ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
        }
}
