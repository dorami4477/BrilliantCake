//
//  ProfileView.swift
//  BrilliantCake
//
//  Created by 박다현 on 8/22/24.
//

import UIKit
import SnapKit

final class ProfileView: BaseView {
    let profileImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 50
        imageView.layer.masksToBounds = true
        imageView.image = UIImage(named: ImageName.missingImage)
        return imageView
    }()
    
    let nameLabel = {
        let label = UILabel()
        label.font = AppFont.size20Bold
        label.textAlignment = .center
        return label
    }()
    
    let emailLabel = {
        let label = UILabel()
        label.font = AppFont.size14
        label.textColor = .gray
        label.textAlignment = .center
        return label
    }()
    
    let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.backgroundColor = .clear
        tableView.backgroundView = nil
        return tableView
    }()
    
    override func configureHierarchy() {
        addSubview(profileImageView)
        addSubview(nameLabel)
        addSubview(emailLabel)
        addSubview(tableView)
    }
    
    override func configureLayout() {
        profileImageView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).offset(20)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(100)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(profileImageView.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
        }
        
        emailLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(5)
            make.centerX.equalToSuperview()
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(emailLabel.snp.bottom).offset(20)
            make.horizontalEdges.bottom.equalToSuperview()
        }
    }
    
}
