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
        NetworkManager.shared.createAccount(nickname: signUpView.nickNameTextField.text!,
                                            email: signUpView.emailTextField.text!,
                                            password: signUpView.passwordTextField.text!) { [weak self] in
            self?.showAlert(title: "환영합니다.", message: "회원가입이 완료 되었습니다. 로그인해주세요!:)", buttonTilte: "확인", completionHandler: { _ in
                self?.dismiss(animated: true)
            })
        }
    }
}



