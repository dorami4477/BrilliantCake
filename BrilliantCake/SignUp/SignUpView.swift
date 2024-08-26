//
//  SignUpView.swift
//  BrilliantCake
//
//  Created by 박다현 on 8/14/24.
//

import UIKit
import SnapKit

final class SignUpView: BaseView {
    private let titleLabel = {
        let label = UILabel()
        label.text = Literal.GuideMessage.signUp
        label.font = .systemFont(ofSize: 24, weight: .bold)
        return label
    }()
    
    let nickNameTextField = {
        let textField = UITextField()
        textField.placeholder = Literal.GuideMessage.nickName
        textField.borderStyle = .roundedRect
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        return textField
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
    
    let signUpButton = {
        let button = UIButton(type: .system)
        button.setTitle(Literal.ButtonName.signUp, for: .normal)
        button.backgroundColor = .main
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 5
        return button
    }()
    
    override func configureHierarchy() {
        addSubview(titleLabel)
        addSubview(nickNameTextField)
        addSubview(emailTextField)
        addSubview(passwordTextField)
        addSubview(signUpButton)
    }

    override func configureLayout() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).offset(20)
            make.centerX.equalToSuperview()
        }
        
        nickNameTextField.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(40)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.height.equalTo(44)
        }
        
        emailTextField.snp.makeConstraints { make in
            make.top.equalTo(nickNameTextField.snp.bottom).offset(20)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.height.equalTo(44)
        }
        
        passwordTextField.snp.makeConstraints { make in
            make.top.equalTo(emailTextField.snp.bottom).offset(20)
            make.horizontalEdges.equalTo(emailTextField)
            make.height.equalTo(44)
        }
        
        signUpButton.snp.makeConstraints { make in
            make.top.equalTo(passwordTextField.snp.bottom).offset(40)
            make.horizontalEdges.equalTo(emailTextField)
            make.height.equalTo(44)
        }
    }
}

