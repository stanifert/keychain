//
//  CreateAccountVC.swift
//  Keychain
//
//  Created by Travis W. Stanifer on 8/29/20.
//

import UIKit

class CreateAccountVC: UIViewController {
    
    weak var delegate: ProfileVCDelegate?
    
    let stackView = UIStackView()
    let nameField = CustomTextfield()
    let emailField = CustomTextfield()
    let passwordField = CustomTextfield()
    let passwordConfirmField = CustomTextfield()
    let actionButton = UIButton(type: .system)
    let tapticLight = UIImpactFeedbackGenerator(style: .light)
    private let scrollView = UIScrollView()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Create account"
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
        let close = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(handleCloseButton))
        navigationItem.rightBarButtonItem = close
        
        NotificationCenter.default.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidHide), name: UIResponder.keyboardDidHideNotification, object: nil)
        
        configureScrollView()
        configureTextfields()
        configureStackView()
        configureCreateAccountButton()
    }
    
    
    @objc func handleCloseButton() {
        dismiss(animated: true)
    }
    
    @objc func handleActionButton() {
        tapticLight.impactOccurred()
        let name = nameField.text
        guard let email = emailField.text, !email.isEmpty else {
            presentAlert(title: "Oops", message: "You must enter an email address.")
            return
        }
        guard passwordField.text == passwordConfirmField.text else {
            presentAlert(title: "Oops", message: "Passwords do not match. Please make sure they match and try again.")
            return
        }
        guard let password = passwordField.text, !password.isEmpty else {
            presentAlert(title: "Oops", message: "Please choose a password.")
            return
        }
        let user = User(id: UUID().uuidString, name: name, email: email, password: password)
        let userStore = KeychainStore<User>(uniqueID: user.id)
        try? userStore.save(user)
        UserDefaults.standard.setValue(user.id, forKey: "currentUserID")
        delegate?.set(user: user)
        self.dismiss(animated: true) {
            print("Successfully created user.")
        }
    }
    
    
    func presentAlert(title: String, message: String) {
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        present(ac, animated: true)
    }

}


extension CreateAccountVC {
    
    private func configureStackView() {
        stackView.axis = .vertical
        stackView.spacing = 40
        stackView.distribution = .equalSpacing
        stackView.addArrangedSubview(nameField)
        stackView.addArrangedSubview(emailField)
        stackView.addArrangedSubview(passwordField)
        stackView.addArrangedSubview(passwordConfirmField)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 40),
            stackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20)
        ])
    }
    
    
    private func configureTextfields() {
        nameField.set(symbol: UIImage.init(systemName: "person.fill")!, placeholder: "Full name", accessoryText: "Full name", indicatorText: "optional")
        nameField.keyboardType = .default
        nameField.autocapitalizationType = .words
        nameField.autocorrectionType = .no
        nameField.textContentType = .name
        nameField.tag = 0
        nameField.delegate = self
        
        emailField.set(symbol: UIImage.init(systemName: "envelope.fill")!, placeholder: "Email address", accessoryText: "Email", indicatorText: nil)
        emailField.keyboardType = .emailAddress
        emailField.autocapitalizationType = .none
        emailField.autocorrectionType = .no
        emailField.textContentType = .emailAddress
        emailField.tag = 1
        emailField.delegate = self
        
        passwordField.set(symbol: UIImage.init(systemName: "lock")!, placeholder: "Password", accessoryText: "Password", indicatorText: nil)
        passwordField.keyboardType = .default
        passwordField.autocapitalizationType = .none
        passwordField.autocorrectionType = .no
        passwordField.textContentType = .newPassword
        passwordField.isSecureTextEntry = true
        passwordField.tag = 2
        passwordField.delegate = self
        
        passwordConfirmField.set(symbol: UIImage.init(systemName: "lock.fill")!, placeholder: "Confirm password", accessoryText: "Confirm password", indicatorText: nil)
        passwordConfirmField.keyboardType = .default
        passwordConfirmField.autocapitalizationType = .none
        passwordConfirmField.autocorrectionType = .no
        passwordConfirmField.textContentType = .newPassword
        passwordConfirmField.isSecureTextEntry = true
        passwordConfirmField.tag = 3
        passwordConfirmField.delegate = self
    }
    
    
    private func configureCreateAccountButton() {
        actionButton.setTitle("Create Account", for: .normal)
        actionButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        actionButton.backgroundColor = .systemBlue
        actionButton.setTitleColor(.white, for: .normal)
        actionButton.layer.cornerRadius = 10
        actionButton.layer.cornerCurve = .continuous
        actionButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(actionButton)
        NSLayoutConstraint.activate([
            actionButton.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 80),
            actionButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 40),
            actionButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -40),
            actionButton.heightAnchor.constraint(equalToConstant: 51)
        ])
        actionButton.addTarget(self, action: #selector(handleActionButton), for: .touchUpInside)
    }
    
    
    private func configureScrollView() {
        scrollView.contentSize = self.view.frame.size
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
}


extension CreateAccountVC: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let nextField = textField.superview?.viewWithTag(textField.tag + 1) as? UITextField {
            nextField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        return false
    }
    
}


extension CreateAccountVC {
    
    @objc func adjustForKeyboard(notification: NSNotification) {
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
            return
        }
        let contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height + 40, right: 0)
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
    }
    
    
    @objc func keyboardDidHide(notification: NSNotification) {
        scrollView.contentInset = UIEdgeInsets.zero
        scrollView.scrollIndicatorInsets = UIEdgeInsets.zero
        scrollView.scrollToTop()
    }
    
}
