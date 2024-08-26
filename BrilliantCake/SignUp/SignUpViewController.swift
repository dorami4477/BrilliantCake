//
//  SignUpViewController.swift
//  BrilliantCake
//
//  Created by 박다현 on 8/14/24.
//

import UIKit

final class SignUpViewController: BaseViewController {
    private let signUpView = SignUpView()
    
    override func loadView() {
        view = signUpView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupActions()
    }
    
    private func setupActions() {
        signUpView.signUpButton.addTarget(self, action: #selector(signUpButtonTapped), for: .touchUpInside)
    }
    
    @objc private func signUpButtonTapped() {
        UserNetworkManager.shared.createAccount(nickname: signUpView.nickNameTextField.text!,
                                                email: signUpView.emailTextField.text!,
                                                password: signUpView.passwordTextField.text!) { [weak self] in
            self?.showAlert(title: Literal.GuideMessage.welcome, message: Literal.GuideMessage.welcomeMSG, buttonTilte: Literal.ButtonName.comform, completionHandler: { _ in
                self?.dismiss(animated: true)
            })
        }
    }
}



