//
//  StoreView.swift
//  BrilliantCake
//
//  Created by 박다현 on 8/18/24.
//

import UIKit
import SnapKit

final class StoreView: BaseView {
    private var scrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        return scrollView
    }()

    private var contentView = {
        let view = UIView()
        return view
    }()

    var cakeImageView1 = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.image = UIImage(named: ImageName.missingImage)
        return imageView
    }()

    var cakeImageView2 = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.image = UIImage(named: ImageName.missingImage)
        return imageView
    }()

    var cakeImageView3 = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.image = UIImage(named: ImageName.missingImage)
        return imageView
    }()

    var titleLabel = {
        let label = UILabel()
        label.font = AppFont.size24Bold
        label.numberOfLines = 2
        return label
    }()

    var descriptionLabel = {
        let label = UILabel()
        label.font = AppFont.size16
        label.numberOfLines = 0
        return label
    }()

    var contactLabel = {
        let label = UILabel()
        label.font = AppFont.size14
        label.numberOfLines = 0
        return label
    }()

    var callButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: ImageName.phone), for: .normal)
        button.tintColor = .black
        button.backgroundColor = .main
        button.layer.cornerRadius = 10
        return button
    }()
    
    var locationButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: ImageName.location), for: .normal)
        button.setTitle(" 위치보기", for: .normal)
        button.tintColor = .black
        button.backgroundColor = .main
        button.layer.cornerRadius = 10
        return button
    }()
    
    var purchaseButton = {
        let button = UIButton(type: .system)
        button.setTitle("주문하기", for: .normal)
        button.titleLabel?.font = AppFont.size17heavy
        button.tintColor = .black
        button.backgroundColor = .main
        button.layer.cornerRadius = 10
        return button
    }()
    
    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())

    private func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        let width = screenSize().width / 3
        layout.itemSize = CGSize(width: width, height: width)
        return layout
    }
    
    override func configureHierarchy() {
        addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(cakeImageView1)
        contentView.addSubview(cakeImageView2)
        contentView.addSubview(cakeImageView3)
        contentView.addSubview(titleLabel)
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(contactLabel)
        contentView.addSubview(callButton)
        contentView.addSubview(locationButton)
        contentView.addSubview(purchaseButton)
        contentView.addSubview(collectionView)
    }
    
    override func configureLayout() {
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        contentView.snp.makeConstraints { make in
            make.edges.equalTo(scrollView)
            make.width.equalTo(scrollView)
        }

        cakeImageView1.snp.makeConstraints { make in
            make.top.equalTo(contentView)
            make.leading.equalTo(contentView)
            make.width.equalTo(contentView.snp.width).multipliedBy(0.70)
            make.height.equalTo(cakeImageView1.snp.width).multipliedBy(0.75)
        }

        cakeImageView2.snp.makeConstraints { make in
            make.top.equalTo(contentView)
            make.leading.equalTo(cakeImageView1.snp.trailing)
            make.trailing.equalToSuperview()
            make.width.equalTo(contentView.snp.width).multipliedBy(0.30)
            make.height.equalTo(cakeImageView1.snp.height).multipliedBy(0.5)
        }

        cakeImageView3.snp.makeConstraints { make in
            make.top.equalTo(cakeImageView2.snp.bottom)
            make.leading.equalTo(cakeImageView1.snp.trailing)
            make.trailing.equalToSuperview()
            make.width.equalTo(contentView.snp.width).multipliedBy(0.30)
            make.height.equalTo(cakeImageView1.snp.height).multipliedBy(0.5)
        }

        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(cakeImageView3.snp.bottom).offset(20)
            make.leading.trailing.equalTo(contentView).inset(20)
        }

        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.leading.trailing.equalTo(titleLabel)
        }

        contactLabel.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(20)
            make.leading.trailing.equalTo(contentView).inset(20)
        }

        callButton.snp.makeConstraints { make in
            make.top.equalTo(contactLabel.snp.bottom).offset(20)
            make.leading.equalTo(contentView).inset(20)
            make.height.equalTo(50)
            make.trailing.equalTo(locationButton.snp.leading).offset(-10)
            make.width.equalTo(locationButton)
        }

        locationButton.snp.makeConstraints { make in
            make.top.equalTo(callButton)
            make.trailing.equalTo(contentView).inset(20)
            make.height.equalTo(50)
            make.width.equalTo(callButton)
        }
        
        purchaseButton.snp.makeConstraints { make in
            make.top.equalTo(locationButton.snp.bottom).offset(10)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.height.equalTo(44)
        }

        collectionView.snp.makeConstraints { make in
            make.top.equalTo(purchaseButton.snp.bottom).offset(20)
            make.leading.trailing.equalTo(contentView)
            make.height.equalTo(collectionView.contentSize.height)
            make.bottom.equalToSuperview().offset(-20)
        }

    }
}
