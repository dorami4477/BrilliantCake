//
//  LoginView.swift
//  BrilliantCake
//
//  Created by 박다현 on 8/14/24.
//

import UIKit
import SnapKit

final class LoginView: BaseView {
    private let logoImage = {
        let image = UIImageView()
        image.image = UIImage(named: ImageName.logo)
        image.contentMode = .scaleAspectFit
        return image
    }()
    
    let emailTextField = {
        let textField = UITextField()
        textField.placeholder = Literal.GuideMessage.email
        textField.borderStyle = .roundedRect
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        return textField
    }()
    
    let passwordTextField = {
        let textField = UITextField()
        textField.placeholder = Literal.GuideMessage.password
        textField.borderStyle = .roundedRect
        textField.isSecureTextEntry = true
        return textField
    }()
    
    let loginButton = {
        let button = UIButton(type: .system)
        button.setTitle(Literal.ButtonName.login, for: .normal)
        button.backgroundColor = .main
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 5
        return button
    }()
    
    let signButton = {
        let button = UIButton(type: .system)
        button.setTitle(Literal.ButtonName.goSignUp, for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.layer.cornerRadius = 5
        return button
    }()
    
    override func configureHierarchy() {
        addSubview(logoImage)
        addSubview(emailTextField)
        addSubview(passwordTextField)
        addSubview(loginButton)
        addSubview(signButton)
    }
    
    override func configureLayout() {
        logoImage.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).offset(20)
            make.horizontalEdges.equalToSuperview().inset(40)
        }
        
        emailTextField.snp.makeConstraints { make in
            make.top.equalTo(logoImage.snp.bottom).offset(40)
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo(44)
        }
        
        passwordTextField.snp.makeConstraints { make in
            make.top.equalTo(emailTextField.snp.bottom).offset(20)
            make.left.right.equalTo(emailTextField)
            make.height.equalTo(44)
        }
        
        loginButton.snp.makeConstraints { make in
            make.top.equalTo(passwordTextField.snp.bottom).offset(40)
            make.left.right.equalTo(emailTextField)
            make.height.equalTo(44)
        }
        
        signButton.snp.makeConstraints { make in
            make.top.equalTo(loginButton.snp.bottom).offset(40)
            make.left.right.equalTo(emailTextField)
            make.height.equalTo(44)
        }
    }
}

