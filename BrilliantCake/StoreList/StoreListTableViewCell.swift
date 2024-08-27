//
//  StoreListTableViewCell.swift
//  BrilliantCake
//
//  Created by 박다현 on 8/19/24.
//

import UIKit
import RxSwift

final class StoreListTableViewCell: BaseTableViewCell {
    var disposeBag = DisposeBag()
    
    let nameLabel = {
        let label = UILabel()
        label.font = AppFont.size18Bold
        return label
    }()
    
    let heartButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: ImageName.heart), for: .normal)
        button.tintColor = .black
        return button
    }()
    
    let detailsLabel = {
        let label = UILabel()
        label.font = AppFont.size14
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
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }

    override func configureHierarchy() {
        contentView.addSubview(nameLabel)
        contentView.addSubview(heartButton)
        contentView.addSubview(detailsLabel)
        contentView.addSubview(imageBoxStackView)
        imageBoxStackView.addArrangedSubview(storeImageView1)
        imageBoxStackView.addArrangedSubview(storeImageView2)
        imageBoxStackView.addArrangedSubview(storeImageView3)
    }
    
    override func configureLayout() {
        nameLabel.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().inset(20)
        }
        
        heartButton.snp.makeConstraints { make in
            make.top.trailing.equalToSuperview().inset(20)
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
    
    func configureData(data: PostData) {
        guard data.files.count == 3 else {
            print("Expected exactly 3 image URLs, but got \(data.files.count)")
            return
        }
            
        let imageViews = [storeImageView1, storeImageView2, storeImageView3]
        
        for (index, url) in data.files.enumerated() {
            imageViews[index].setImage(url: url)
        }
        
        nameLabel.text = data.title
        detailsLabel.text = data.content
        
        guard let isLike = data.likes?.contains(UserDefaultsManager.userID) else { return }
        heartButton.tintColor = isLike ? .main : .black
        let image = isLike ? UIImage(systemName: ImageName.heartFill) : UIImage(systemName: ImageName.heart)
        heartButton.setImage(image, for: .normal)
    }
}
