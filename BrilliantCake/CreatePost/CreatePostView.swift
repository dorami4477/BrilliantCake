//
//  CreatePostView.swift
//  BrilliantCake
//
//  Created by 박다현 on 8/23/24.
//

import UIKit
import SnapKit

final class CreatePostView: BaseView {

    let titleView = {
        let view = UIView()
        view.layer.cornerRadius = 10
        view.clipsToBounds = true
        view.backgroundColor = .white
        return view
    }()
    
    let contentBackView = {
        let view = UIView()
        view.layer.cornerRadius = 10
        view.clipsToBounds = true
        view.backgroundColor = .white
        return view
    }()
    
    let storeView = {
        let view = UIView()
        view.layer.cornerRadius = 10
        view.clipsToBounds = true
        view.backgroundColor = .white
        return view
    }()
    
    let photoView = {
        let view = UIView()
        view.layer.cornerRadius = 10
        view.clipsToBounds = true
        view.backgroundColor = .white
        return view
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = Literal.GuideMessage.title
        label.font = AppFont.size14
        return label
    }()
    
    let titleTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = Literal.GuideMessage.titlePlaceholder
        textField.font = AppFont.size14
        return textField
    }()
    
    let titleCountLabel: UILabel = {
        let label = UILabel()
        label.font = AppFont.size12
        label.textAlignment = .right
        label.textColor = .lightGray
        return label
    }()
    
    // 내용 입력 필드
    let contentLabel: UILabel = {
        let label = UILabel()
        label.text = Literal.GuideMessage.content
        label.font = AppFont.size14
        return label
    }()
    
    let contentTextView: UITextView = {
        let textView = UITextView()
        textView.font = AppFont.size14
        textView.text = Literal.GuideMessage.contentPlaceholder
        textView.textColor = .lightGray
        return textView
    }()
    
    let contentCountLabel: UILabel = {
        let label = UILabel()
        label.font = AppFont.size12
        label.textAlignment = .right
        label.textColor = .lightGray
        return label
    }()
    
    // 스토어 선택 필드
    let storeLabel: UILabel = {
        let label = UILabel()
        label.text = Literal.GuideMessage.store
        label.font = AppFont.size14
        return label
    }()
    
    let storeSelectButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(Literal.GuideMessage.storePlaceholder, for: .normal)
        button.titleLabel?.font = AppFont.size14
        button.contentHorizontalAlignment = .left
        button.backgroundColor = .white
        button.setTitleColor(.lightGray, for: .normal)
        
        // 오른쪽에 화살표 아이콘 추가
        let arrowIcon = UIImageView(image: UIImage(systemName: ImageName.arrowRight))
        button.addSubview(arrowIcon)
        arrowIcon.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().inset(10)
        }
        
        return button
    }()
    
    // 사진 등록 필드
    let photoLabel: UILabel = {
        let label = UILabel()
        label.text = Literal.GuideMessage.photo
        label.font = AppFont.size14
        return label
    }()
    
    let addPhotoButton: UIButton = {
        let button = UIButton(type: .system)
        let image = UIImage(systemName: ImageName.plus)
        button.setImage(image, for: .normal)
        button.tintColor = .darkGray
        button.backgroundColor = .lightGray
        return button
    }()
    
    let photoStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 10
        return stackView
    }()
    
    let photoCountLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textAlignment = .right
        label.textColor = .lightGray
        return label
    }()
    
    // 등록하기 버튼
    let submitButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(Literal.ButtonName.upload, for: .normal)
        button.backgroundColor = .main
        button.setTitleColor(.black, for: .normal)
        button.layer.cornerRadius = 8
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        return button
    }()
    
    
    override func configureHierarchy() {
        addSubview(titleView)
        titleView.addSubview(titleLabel)
        titleView.addSubview(titleTextField)
        titleView.addSubview(titleCountLabel)
        addSubview(contentBackView)
        contentBackView.addSubview(contentLabel)
        contentBackView.addSubview(contentTextView)
        contentBackView.addSubview(contentCountLabel)
        addSubview(storeView)
        storeView.addSubview(storeLabel)
        storeView.addSubview(storeSelectButton)
        addSubview(photoView)
        photoView.addSubview(photoLabel)
        photoView.addSubview(addPhotoButton)
        photoView.addSubview(photoStackView)
        photoView.addSubview(photoCountLabel)
        addSubview(submitButton)
    }
    
    override func configureLayout() {
        backgroundColor = .lightGray
        
        titleView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).offset(20)
            make.horizontalEdges.equalToSuperview().inset(20)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().inset(10)
        }
        
        titleTextField.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom)
            make.horizontalEdges.equalToSuperview().inset(10)
            make.height.equalTo(40)
        }
        
        titleCountLabel.snp.makeConstraints { make in
            make.top.equalTo(titleTextField.snp.bottom).offset(4)
            make.trailing.equalToSuperview().inset(10)
            make.bottom.equalToSuperview().inset(5)
        }
                
        // 내용 관련 레이아웃
        contentBackView.snp.makeConstraints { make in
            make.top.equalTo(titleView.snp.bottom).offset(20)
            make.horizontalEdges.equalToSuperview().inset(20)
        }
        
        contentLabel.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().inset(10)
        }
        
        contentTextView.snp.makeConstraints { make in
            make.top.equalTo(contentLabel.snp.bottom).offset(8)
            make.horizontalEdges.equalToSuperview().inset(10)
            make.height.equalTo(120)
        }
        
        contentCountLabel.snp.makeConstraints { make in
            make.top.equalTo(contentTextView.snp.bottom).offset(4)
            make.trailing.equalToSuperview().inset(10)
            make.bottom.equalToSuperview().inset(5)
        }
        
        // 스토어 선택 레이아웃
        storeView.snp.makeConstraints { make in
            make.top.equalTo(contentBackView.snp.bottom).offset(20)
            make.horizontalEdges.equalToSuperview().inset(20)
        }
        
        storeLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.leading.equalToSuperview().offset(10)
        }
        
        storeSelectButton.snp.makeConstraints { make in
            make.top.equalTo(storeLabel.snp.bottom)
            make.leading.equalToSuperview().offset(10)
            make.trailing.equalToSuperview().offset(-10)
            make.height.equalTo(40)
            make.bottom.equalToSuperview()
        }
        
        photoView.snp.makeConstraints { make in
            make.top.equalTo(storeView.snp.bottom).offset(20)
            make.horizontalEdges.equalToSuperview().inset(20)
        }
        
        // 사진 등록 레이아웃
        photoLabel.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().inset(10)
        }
        
        addPhotoButton.snp.makeConstraints { make in
            make.top.equalTo(photoLabel.snp.bottom).offset(10)
            make.leading.equalToSuperview().offset(10)
            make.size.equalTo(60)
        }
        
        photoStackView.snp.makeConstraints { make in
            make.top.equalTo(photoLabel.snp.bottom).offset(15)
            make.leading.equalTo(addPhotoButton.snp.trailing).offset(10)
            make.height.equalTo(50)
        }
        
        photoCountLabel.snp.makeConstraints { make in
            make.top.equalTo(addPhotoButton.snp.bottom).offset(4)
            make.trailing.equalToSuperview().inset(10)
            make.bottom.equalToSuperview().inset(5)
        }

        submitButton.snp.makeConstraints { make in
            make.bottom.equalTo(safeAreaLayoutGuide).inset(30)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.height.equalTo(50)
        }
    }
    
    func addNewImages(images: [UIImage?]) {
        photoStackView.arrangedSubviews.forEach { subview in
            subview.removeFromSuperview()
        }
        
        for image in images {
            let photoImageView = {
                let imageView = UIImageView()
                imageView.contentMode = .scaleAspectFill
                imageView.image = image
                imageView.clipsToBounds = true
                return imageView
            }()
            
            photoStackView.addArrangedSubview(photoImageView)
            photoImageView.snp.makeConstraints { make in
                make.size.equalTo(50)
            }
        }
    }
    
    func storeSelectButtonUI(title: String) {
        storeSelectButton.setTitle(title, for: .normal)
        storeSelectButton.titleLabel?.font = AppFont.size17Bold
        storeSelectButton.setTitleColor(.black, for: .normal)
    }
    
    func setSubmitButton(_ status: Bool) {
        submitButton.isEnabled = status
        submitButton.backgroundColor = status ? .main : .lightGray

    }
}
