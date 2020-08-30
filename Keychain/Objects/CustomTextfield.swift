//
//  CustomTextfield.swift
//  Keychain
//
//  Created by Travis W. Stanifer on 8/29/20.
//

import UIKit

class CustomTextfield: UITextField {
    
    var icon: UIImage!
    let accessoryLabel = UILabel()
    let indicatorLabel = UILabel()
    private var textPadding = UIEdgeInsets(top: 15, left: 51, bottom: 15, right: 18)
    let iconView = UIImageView()
    private var accessoryLabelShouldAnimatePresentation: Bool = true

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return super.textRect(forBounds: bounds).inset(by: textPadding)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return super.textRect(forBounds: bounds).inset(by: textPadding)
    }
    
    
    func set(symbol: UIImage, placeholder: String, accessoryText: String?, indicatorText: String?) {
        let config = UIImage.SymbolConfiguration(weight: .semibold)
        self.icon = symbol.withConfiguration(config)
        self.placeholder = placeholder
        if let accesoryText = accessoryText {
            accessoryLabel.alpha = 1
            accessoryLabel.text = accesoryText
        } else {
            accessoryLabel.alpha = 0
            accessoryLabel.text = ""
        }
        
        if let indicatorText = indicatorText {
            indicatorLabel.alpha = 1
            indicatorLabel.text = indicatorText.uppercased()
        } else {
            indicatorLabel.alpha = 0
            indicatorLabel.text = ""
        }
        
        configure()
    }
    
    
    private func configure() {
        backgroundColor = .secondarySystemGroupedBackground
        layer.cornerRadius = 15
        layer.cornerCurve = .continuous
        layer.shadowRadius = 10
        layer.shadowOffset = CGSize(width: 0, height: 5)
        layer.shadowOpacity = 0.09
  
        font = UIFont.systemFont(ofSize: 17, weight: .medium)
        textColor = .label
        
        iconView.contentMode = .scaleAspectFill
        iconView.backgroundColor = .clear
        iconView.tintColor = .label
        iconView.image = icon
        
        iconView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(iconView)
        NSLayoutConstraint.activate([
            iconView.centerYAnchor.constraint(equalTo: centerYAnchor),
            iconView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 18),
            iconView.heightAnchor.constraint(equalToConstant: 20),
            iconView.widthAnchor.constraint(equalToConstant: 20)
        ])
        
        accessoryLabel.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        accessoryLabel.textColor = .tertiaryLabel
        accessoryLabel.textAlignment = .right
        accessoryLabel.numberOfLines = 1
        accessoryLabel.adjustsFontSizeToFitWidth = false
        accessoryLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(accessoryLabel)
        NSLayoutConstraint.activate([
            accessoryLabel.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -10),
            accessoryLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20)
        ])
        accessoryLabel.alpha = 0
        
        indicatorLabel.font = UIFont.systemFont(ofSize: 10, weight: .bold)
        indicatorLabel.textColor = .secondaryLabel
        indicatorLabel.textAlignment = .center
        indicatorLabel.numberOfLines = 1
        indicatorLabel.adjustsFontSizeToFitWidth = false
        indicatorLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(indicatorLabel)
        NSLayoutConstraint.activate([
            indicatorLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            indicatorLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20)
        ])
        
        
        addTarget(self, action: #selector(monitorTextChanges), for: .editingChanged)
    }
    
}



extension CustomTextfield {
    
    @objc func monitorTextChanges() {
        if let text = self.text {
            if !text.isEmpty {
                if text.count == 1 {
                    if accessoryLabelShouldAnimatePresentation {
                        showAccessoryText()
                        hideIndicatorLabel()
                    }
                }
            } else {
                hideAccessoryText()
                showIndicatorLabel()
            }
        }
    }
    
    func showAccessoryText() {
        UIView.animate(withDuration: 0.2) {
            self.accessoryLabel.transform3D = CATransform3DMakeRotation(-1, 1, 0, 0)
            self.accessoryLabel.transform = CGAffineTransform(translationX: 0, y: 10)
            self.accessoryLabel.alpha = 1
        }
        accessoryLabelShouldAnimatePresentation = false
    }
    
    
    func hideAccessoryText() {
        UIView.animate(withDuration: 0.2) {
            self.accessoryLabel.alpha = 0
        }
        accessoryLabelShouldAnimatePresentation = true
    }
    
    
    func showIndicatorLabel() {
        UIView.animate(withDuration: 0.2) {
            self.indicatorLabel.alpha = 1
        }
    }
    
    
    func hideIndicatorLabel() {
        UIView.animate(withDuration: 0.2) {
            self.indicatorLabel.alpha = 0
        }
    }
}
