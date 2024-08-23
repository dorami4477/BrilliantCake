//
//  EditPorfileView.swift
//  BrilliantCake
//
//  Created by 박다현 on 8/23/24.
//

//import UIKit
//
//final class EditPorfileView: BaseView {
//    
//    let profileImageView: UIImageView = {
//        let imageView = UIImageView()
//        imageView.contentMode = .scaleAspectFill
//        imageView.layer.cornerRadius = 50
//        imageView.layer.masksToBounds = true
//        return imageView
//    }()
//    
//    let cameraIcon: UIImageView = {
//        let icon = UIImageView()
//        icon.image = UIImage(systemName: "camera.circle.fill") // SF Symbol 사용 가능
//        icon.tintColor = .gray
//        icon.contentMode = .scaleAspectFit
//        return icon
//    }()
//    
//    let nameTextField: UITextField = {
//        let textField = UITextField()
//        textField.text = "JOHAN DUE"
//        textField.font = UIFont.boldSystemFont(ofSize: 18)
//        textField.textAlignment = .center
//        textField.isUserInteractionEnabled = false
//        return textField
//    }()
//    
//    let jobTextField: UITextField = {
//        let textField = UITextField()
//        textField.text = "Writer"
//        textField.font = UIFont.systemFont(ofSize: 14)
//        textField.textColor = .gray
//        textField.textAlignment = .center
//        textField.isUserInteractionEnabled = false
//        return textField
//    }()
//    
//    func setupViews() {
//        view.backgroundColor = .white
//        
//        // 1. 프로필 이미지 추가
//        view.addSubview(profileImageView)
//        profileImageView.snp.makeConstraints { make in
//            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
//            make.centerX.equalToSuperview()
//            make.width.height.equalTo(100) // 원형 이미지를 위해 높이와 너비를 동일하게 설정
//        }
//        
//        // 2. 카메라 아이콘 추가 (오른쪽 하단에 오버레이)
//        view.addSubview(cameraIcon)
//        cameraIcon.snp.makeConstraints { make in
//            make.width.height.equalTo(30)
//            make.right.bottom.equalTo(profileImageView).offset(5)
//        }
//        
//        // 3. 이름 텍스트 필드 추가
//        view.addSubview(nameTextField)
//        nameTextField.snp.makeConstraints { make in
//            make.top.equalTo(profileImageView.snp.bottom).offset(15)
//            make.centerX.equalToSuperview()
//        }
//        
//        // 4. 직업 텍스트 필드 추가
//        view.addSubview(jobTextField)
//        jobTextField.snp.makeConstraints { make in
//            make.top.equalTo(nameTextField.snp.bottom).offset(5)
//            make.centerX.equalToSuperview()
//        }
//    }
//}

