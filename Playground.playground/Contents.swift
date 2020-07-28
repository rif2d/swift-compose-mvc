import UIKit
import PlaygroundSupport

// MARK: - View Controller
// Notice the View Controller only responsible for nothing but managing view

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

    @objc private func buttonDidTap(_ sender: UIButton) {
        // TODO: Use delegation to offload model layer stuff from this "View" Controller
    }
}


// MARK: - Model Controller
// Separate model layer stuff from "View" Controller

class MessageNetworking {
    enum MessageNetworkingError: Error {
        case unableToSend
    }

    func sendMessage(message: String, callback: @escaping (Result<String, MessageNetworkingError>) -> Void) {
        if Bool.random() {
            callback(.success("Message sent"))
        } else {
            callback(.failure(.unableToSend))
        }
    }
}

class MessageValidation {
    enum ValidationError: Error {
        case emptyMessage
    }

    func validate(message: String) -> ValidationError? {
        if message.count == 0 {
            return .emptyMessage
        }

        return nil
    }
}

let vc = ViewController()
vc.preferredContentSize = CGSize(width: 300, height: 300)

PlaygroundPage.current.setLiveView(vc)
