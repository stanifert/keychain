//
//  EditAccountVC.swift
//  Keychain
//
//  Created by Travis W. Stanifer on 8/29/20.
//

import UIKit

class EditAccountVC: CreateAccountVC {
    
    var user: User?

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Edit account"
        actionButton.setTitle("Save", for: .normal)
    }
    
    
    init(user: User?) {
        super.init(nibName: nil, bundle: nil)
        self.user = user
        
        if let user = user {
            nameField.text = user.name
            emailField.text = user.email
            passwordField.text = user.password
            passwordConfirmField.text = user.password
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func handleActionButton() {
        tapticLight.impactOccurred()
        guard passwordField.text == passwordConfirmField.text else {
            presentAlert(title: "Oops", message: "Passwords do not match. Please make sure they match and try again.")
            return
        }
        guard emailField.text != nil, emailField.text != "" else {
            presentAlert(title: "Oops", message: "You must enter an email address.")
            return
        }
        saveChangesIfNeeded()
        dismiss(animated: true, completion: nil)
    }

}


extension EditAccountVC {
    
    func saveChangesIfNeeded() {
        if let user = self.user {
            let userStore = KeychainStore<User>(uniqueID: user.id)
            let id = user.id
            var name: String? = user.name
            var email: String = user.email
            var password: String = user.password
            
            if nameField.text != user.name {
                if nameField.text != nil {
                    name = nameField.text
                }
            }
            
            if emailField.text != user.email {
                if let text = emailField.text, !text.isEmpty {
                    email = text
                }
            }
            
            if passwordField.text != user.password {
                if let text = passwordField.text, !text.isEmpty {
                    password = text
                }
            }
            
            let newUser = User(id: id, name: name, email: email, password: password)
            
            do {
                try userStore.update(newUser)
                delegate?.set(user: newUser)
                print("Successfully updated user.")
            } catch {
                print("Failed to update user with error: \(error)")
            }
            
        } else {
            print("No user available for editing.")
        }
        
    }
}
