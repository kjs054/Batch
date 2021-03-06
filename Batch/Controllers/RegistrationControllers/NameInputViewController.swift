//
//  NameInputViewController.swift
//  Batch
//
//  Created by Kevin Shiflett on 6/8/22.
//

import Foundation
import UIKit

class NameInputViewController: RegistrationViewController {
    
    //MARK: UI Elements
    let nameInput: ATCTextField = {
        let textField = ATCTextField()
        textField.setLeftPadding(20)
        textField.placeholder = "First Name"
        textField.font = UIFont(name: "Brown-bold", size: 20)
        textField.textColor = UIColor(named: "mainColor")
        textField.backgroundColor = .white
        textField.layer.cornerRadius = 10
        return textField
    }()
    
    //MARK: UI Lifecycle Methods
    override func viewDidLoad() {
        self.mainStackView.insertArrangedSubview(nameInput, at: 2)
        titleLabel.text = "Enter your name first name."
        subtitleLabel.text = "This is the name displayed to other users on the app."
        continueButton.addTarget(self, action: #selector(continueButtonTapped), for: .touchUpInside)
        setupView()
        self.setupGradient()
        self.animateGradient()
    }
    
    //MARK: Business Logic
    @objc func continueButtonTapped() {
        guard let name = self.nameInput.text else {
            return
        }
        if ValidityChecker().isNameValid(name) {
            self.user?.name = name
            self.showNextViewController(DateOfBirthInputViewController())
        } else {
            self.displayError(message: "Please enter a valid name")
        }
    }
}
