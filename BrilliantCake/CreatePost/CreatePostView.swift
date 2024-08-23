//
//  CreatePostView.swift
//  BrilliantCake
//
//  Created by 박다현 on 8/23/24.
//

import UIKit

final class CreatePostView: BaseView {
   
    
    private let titleTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "제목을 입력하세요"
        textField.borderStyle = .line
        textField.layer.borderColor = UIColor.lightGray.cgColor
        return textField
    }()
    
    private let contentTextView: UITextView = {
        let textView = UITextView()
        return textView
    }()
    
    private lazy var saveButton: UIButton = {
        let button = UIButton()
        button.setTitle("저장하기", for: .normal)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 8

        return button
    }()
    

    override func configureHierarchy() {

        addSubview(titleTextField)
        addSubview(contentTextView)
        addSubview(saveButton)
        
        
        titleTextField.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(44)
        }
        
        contentTextView.snp.makeConstraints { make in
            make.top.equalTo(titleTextField.snp.bottom)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(200)
        }
        
    }
    

}
