//
//  LoginViewController.swift
//  BrilliantCake
//
//  Created by 박다현 on 8/14/24.
//

import UIKit
import Alamofire
import Toast

final class LoginViewController: BaseViewController {
    private let loginView = LoginView()
    
    override func loadView() {
        view = loginView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupActions()
    }
    
    private func setupActions() {
        loginView.loginButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
        loginView.signButton.addTarget(self, action: #selector(signButtonTapped), for: .touchUpInside)
    }
    
    @objc private func loginButtonTapped() {
        NetworkManager.shared.createLogin(email: loginView.emailTextField.text!,
                                          password: loginView.passwordTextField.text!) { [weak self] nick in
            let browseVC = TabBarController()
            self?.changeRootVC(browseVC)
        }
    }
    
    @objc private func signButtonTapped() {
        let signUpVC = SignUpViewController()
        present(signUpVC, animated: true)
    }
}
