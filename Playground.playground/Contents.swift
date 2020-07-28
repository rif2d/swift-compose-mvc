import UIKit
import PlaygroundSupport

class ViewController: UIViewController {
    // MARK: - Views
    private var textField: UITextField!
    private var button: UIButton!
    private var label: UILabel!

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
        label.text = "Status"
        label.textColor = .gray

        view.addArrangedSubview(textField)
        view.addArrangedSubview(button)
        view.addArrangedSubview(label)

        self.view = view
    }

    // MARK: - Model Layer
    @objc private func buttonDidTap(_ sender: UIButton) {
        if textField.text?.count == 0 {
            label.text = "Empty message"
            label.textColor = .red

            return
        }

        sendMessage(message: textField.text!) { result in
            switch result {
            case let .success(response):
                self.label.text = response
                self.label.textColor = .green
            case let .failure(error):
                self.label.text = "\(error)"
                self.label.textColor = .red
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
