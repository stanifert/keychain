//
//  ProfileVC.swift
//  Keychain
//
//  Created by Travis W. Stanifer on 8/29/20.
//

import UIKit

protocol ProfileVCDelegate: class {
    func set(user: User?)
}

class ProfileVC: UIViewController, ProfileVCDelegate {

    var user: User?
    private let scrollView = UIScrollView()
    private let profileCard = ProfileCard()
    private let actionButton = UIButton(type: .system)
    private let tapticLight = UIImpactFeedbackGenerator(style: .light)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = true
        view.backgroundColor = .systemBackground
        title = "Profile"
        
        configureScrollView()
        configureProfileCard()
        configureActionButton()
        getUser()
    }
    
    
    func getUser() {
        var currentUser: User? = nil
        if let currentUserID = UserDefaults.standard.value(forKey: "currentUserID") as? String {
            let userStore = KeychainStore<User>(uniqueID: currentUserID)
            currentUser = userStore.object()
        }
        set(user: currentUser)
    }
    
    
    func set(user: User?) {
        self.user = user
        updateProfileCard(user: user)
        updateActionButton(user: user)
    }
    
    
    func updateProfileCard(user: User?) {
        profileCard.set(user: user)
    }
    
    
    func updateActionButton(user: User?) {
        actionButton.removeTarget(self, action: #selector(handleCreateAccount), for: .touchUpInside)
        actionButton.removeTarget(self, action: #selector(handleDeleteAccount), for: .touchUpInside)
        
        if user != nil {
            actionButton.setTitle("Delete account", for: .normal)
            actionButton.backgroundColor = .systemRed
            actionButton.addTarget(self, action: #selector(handleDeleteAccount), for: .touchUpInside)
        } else {
            actionButton.setTitle("Create account", for: .normal)
            actionButton.backgroundColor = .systemBlue
            actionButton.addTarget(self, action: #selector(handleCreateAccount), for: .touchUpInside)
        }
    }
    
}


extension ProfileVC {
    
    
    @objc func handleCreateAccount() {
        tapticLight.impactOccurred()
        let vc = CreateAccountVC()
        vc.delegate = self
        present(UINavigationController(rootViewController: vc), animated: true)
    }
    
    
    @objc func handleDeleteAccount() {
        tapticLight.impactOccurred()
        let ac = UIAlertController(title: "Are you sure?", message: "You are deleting your account. This action cannot be undone.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        ac.addAction(UIAlertAction(title: "Yes, delete", style: .destructive, handler: { (action) in
            if let id = UserDefaults.standard.value(forKey: "currentUserID") as? String {
                let userStore = KeychainStore<User>(uniqueID: id)
                userStore.delete()
                UserDefaults.standard.setValue(nil, forKey: "currentUserID")
                self.set(user: nil)
                print("Successfully deleted account.")
            } else {
                print("Error deleting account, unable to find currentUserID.")
            }
        }))
        present(ac, animated: true)
    }
    
    
    @objc func handleEditAccountButton() {
        tapticLight.impactOccurred()
        let vc = EditAccountVC(user: self.user)
        vc.delegate = self
        present(UINavigationController(rootViewController: vc), animated: true)
    }
    
    
}



extension ProfileVC {
    
    private func configureScrollView() {
        scrollView.alwaysBounceVertical = true
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
    
    
    private func configureProfileCard() {
        profileCard.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(profileCard)
        NSLayoutConstraint.activate([
            profileCard.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 40),
            profileCard.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            profileCard.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
        profileCard.editButton.addTarget(self, action: #selector(handleEditAccountButton), for: .touchUpInside)
    }
    
    
    private func configureActionButton() {
        actionButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        actionButton.backgroundColor = .systemBlue
        actionButton.setTitleColor(.white, for: .normal)
        actionButton.layer.cornerRadius = 10
        actionButton.layer.cornerCurve = .continuous
        actionButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(actionButton)
        NSLayoutConstraint.activate([
            actionButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 40),
            actionButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -40),
            actionButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -40),
            actionButton.heightAnchor.constraint(equalToConstant: 51)
        ])
    }
    
}
