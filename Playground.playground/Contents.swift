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
        button.setTitleColor(.blue, for: .normal)
        button.addTarget(self, action: #selector(buttonDidTap), for: .touchUpInside)

        label = UILabel()
        label.text = "Status"
        label.textColor = .gray

        view.addArrangedSubview(textField)
        view.addArrangedSubview(button)
        view.addArrangedSubview(label)

        self.view = view
    }

    @objc private func buttonDidTap(_ sender: UIButton) {
        if textField.text?.count == 0 {
            label.text = "Empty message"
            label.textColor = .red

            return
        }

        sendMessage(message: textField.text!)
    }

    // TODO: Add result callback
    private func sendMessage(message: String) {
        print("Message sent")
    }
}

let vc = ViewController()
vc.preferredContentSize = CGSize(width: 300, height: 300)

PlaygroundPage.current.setLiveView(vc)
