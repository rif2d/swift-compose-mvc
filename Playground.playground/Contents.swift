import UIKit
import PlaygroundSupport

class ViewController: UIViewController {
    // MARK: - Views
    private var textField: UITextField!
    private var button: UIButton!
    private var label: UILabel!


    // MARK: State
    enum State {
        case `default`
        case success(String)
        case error(Error)
    }
    
    var state = State.default {
        didSet {
            if !self.isViewLoaded { return }
            updateState()
        }
    }

    private func updateState() {
        switch state {
        case .default:
            label.text = "Ready"
            label.textColor = .gray
        case let .error(error):
            label.text = "Error: \(error)"
            label.textColor = .red
        case let .success(message):
            label.text = message
            label.textColor = .green
        }
    }


    // MARK: - Setup View
    override func loadView() {
        let view = UIStackView()
        view.axis = .vertical
        view.distribution = .fillEqually
        view.alignment = .center

        textField = UITextField()
        textField.placeholder = "Insert message here..."

        button = UIButton()
        button.setTitle("Send", for: .normal)
        button.setTitleColor(view.tintColor, for: .normal)
        button.setTitleColor(.gray, for: .highlighted)
        button.addTarget(self, action: #selector(buttonDidTap), for: .touchUpInside)

        label = UILabel()

        view.addArrangedSubview(textField)
        view.addArrangedSubview(button)
        view.addArrangedSubview(label)

        self.view = view
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        updateState()
    }


    // MARK: - Model Layer
    enum ValidationError: Error {
        case emptyMessage
    }
    
    @objc private func buttonDidTap(_ sender: UIButton) {
        if textField.text?.count == 0 {
            self.state = .error(ValidationError.emptyMessage)
            return
        }

        sendMessage(message: textField.text!) { result in
            switch result {
            case let .success(response):
                self.state = .success(response)
            case let .failure(error):
                self.state = .error(error)
            }
        }
    }

    enum MessageNetworkingError: Error {
        case unableToSend
    }

    // Gacha network call wannabe
    private func sendMessage(message: String, callback: @escaping (Result<String, MessageNetworkingError>) -> Void) {
        if Bool.random() {
            callback(.success("Message sent"))
        } else {
            callback(.failure(.unableToSend))
        }
    }
}

let vc = ViewController()
vc.preferredContentSize = CGSize(width: 300, height: 300)

PlaygroundPage.current.setLiveView(vc)
