//
//  ProfileCard.swift
//  Keychain
//
//  Created by Travis W. Stanifer on 8/29/20.
//

import UIKit

class ProfileCard: UIView {
    
    let editButton = UIButton(type: .system)
    let idHeader = UILabel()
    let idLabel = UILabel()
    private let nameHeader = UILabel()
    private let nameLabel = UILabel()
    private let emailHeader = UILabel()
    private let emailLabel = UILabel()
    private let passwordHeader = UILabel()
    private let passwordLabel = UILabel()
    
    private let emptyStateLabel = UILabel()
    private let padding: CGFloat = 15
    private let textSpacing: CGFloat = 5
    var heightConstraint: NSLayoutConstraint!

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func set(user: User?) {
        if heightConstraint != nil {
            NSLayoutConstraint.deactivate([heightConstraint])
            heightConstraint = nil
        }
        for view in self.subviews {
            view.removeFromSuperview()
        }
        
        if let user = user {
            configureProfile()
            idLabel.text = user.id
            if user.name == nil || user.name == "" {
                nameLabel.text = "Anonymous"
                nameLabel.textColor = .secondaryLabel
            } else {
                nameLabel.text = user.name
                nameLabel.textColor = .label
            }
            emailLabel.text = user.email
            passwordLabel.text = user.password
            
        } else {
            for view in subviews {
                view.alpha = 0
            }
            configureEmptyState()
        }
    }
    
    
    private func configure() {
        backgroundColor = .secondarySystemGroupedBackground
        layer.cornerRadius = 10
        layer.cornerCurve = .continuous
        layer.shadowRadius = 10
        layer.shadowOffset = CGSize(width: 0, height: 5)
        layer.shadowOpacity = 0.09
    }
    
}


extension ProfileCard {
    
    private func configureProfile() {
        let headers = [idHeader, nameHeader, emailHeader, passwordHeader]
        for h in headers {
            h.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
            h.textColor = .tertiaryLabel
            h.translatesAutoresizingMaskIntoConstraints = false
            addSubview(h)
        }
        
        let labels = [idLabel, nameLabel, emailLabel, passwordLabel]
        for l in labels {
            l.font = UIFont.systemFont(ofSize: 18, weight: .medium)
            l.textColor = .label
            l.translatesAutoresizingMaskIntoConstraints = false
            addSubview(l)
        }
        
        idHeader.text = "ID"
        nameHeader.text = "Name"
        emailHeader.text = "Email"
        passwordHeader.text = "Password"
        
        idLabel.adjustsFontSizeToFitWidth = true
        
        editButton.setTitle("EDIT", for: .normal)
        editButton.setTitleColor(.secondaryLabel, for: .normal)
        editButton.titleLabel?.font = UIFont.systemFont(ofSize: 12, weight: .bold)
        editButton.titleLabel?.textAlignment = .center
        editButton.backgroundColor = .clear
        editButton.translatesAutoresizingMaskIntoConstraints = false
        addSubview(editButton)
        
        
        NSLayoutConstraint.activate([
            idHeader.topAnchor.constraint(equalTo: topAnchor, constant: padding),
            idHeader.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
            
            idLabel.topAnchor.constraint(equalTo: idHeader.bottomAnchor, constant: textSpacing),
            idLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
            idLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding),
            
            nameHeader.topAnchor.constraint(equalTo: idLabel.bottomAnchor, constant: textSpacing*3),
            nameHeader.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
            
            nameLabel.topAnchor.constraint(equalTo: nameHeader.bottomAnchor, constant: textSpacing),
            nameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
            
            emailHeader.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: textSpacing*3),
            emailHeader.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
            
            emailLabel.topAnchor.constraint(equalTo: emailHeader.bottomAnchor, constant: textSpacing),
            emailLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
            
            passwordHeader.topAnchor.constraint(equalTo: emailLabel.bottomAnchor, constant: textSpacing*3),
            passwordHeader.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
            
            passwordLabel.topAnchor.constraint(equalTo: passwordHeader.bottomAnchor, constant: textSpacing),
            passwordLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
            passwordLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -padding),
            
            editButton.centerYAnchor.constraint(equalTo: passwordLabel.centerYAnchor),
            editButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding)
        ])
    }
    
    private func configureEmptyState() {
        emptyStateLabel.text = "No user found.\nPlease create an account."
        emptyStateLabel.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        emptyStateLabel.textColor = .tertiaryLabel
        emptyStateLabel.textAlignment = .center
        emptyStateLabel.numberOfLines = 0
        emptyStateLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(emptyStateLabel)
        
        heightConstraint = self.heightAnchor.constraint(equalToConstant: 200)
        
        NSLayoutConstraint.activate([
            heightConstraint,
            emptyStateLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            emptyStateLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
            emptyStateLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding)
        ])
    }
}
