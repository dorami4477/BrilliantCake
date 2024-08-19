//
//  StoreListTableViewCell.swift
//  BrilliantCake
//
//  Created by 박다현 on 8/19/24.
//

import UIKit
import RxSwift

final class StoreListTableViewCell: UITableViewCell {
    
    let disposeBag = DisposeBag()
    
    let nameLabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 18)
        return label
    }()
    
    let detailsLabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .gray
        label.numberOfLines = 0
        return label
    }()
    
    private let imageBoxStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 5
        stackView.distribution = .fillEqually
        stackView.layer.cornerRadius = 15
        stackView.clipsToBounds = true
        return stackView
    }()
    
    let storeImageView1 = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    let storeImageView2 = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    let storeImageView3 = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureHierarchy()
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureHierarchy() {
        contentView.addSubview(nameLabel)
        contentView.addSubview(detailsLabel)
        contentView.addSubview(imageBoxStackView)
        imageBoxStackView.addArrangedSubview(storeImageView1)
        imageBoxStackView.addArrangedSubview(storeImageView2)
        imageBoxStackView.addArrangedSubview(storeImageView3)
    }
    
    private func configureLayout() {
        nameLabel.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview().inset(20)
        }
        
        detailsLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(4)
            make.horizontalEdges.equalToSuperview().inset(20)
        }
        
        imageBoxStackView.snp.makeConstraints { make in
            make.top.equalTo(detailsLabel.snp.bottom).offset(10)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.height.equalTo(120)
            make.bottom.lessThanOrEqualToSuperview().inset(20)
        }
    }
    
}
