//
//  StoreView.swift
//  BrilliantCake
//
//  Created by 박다현 on 8/18/24.
//

import UIKit
import SnapKit

class StoreView: BaseView {

    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        return scrollView
    }()

    private lazy var contentView: UIView = {
        let view = UIView()
        return view
    }()

    private lazy var cakeImageView1: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.image = UIImage(systemName: "star")
        return imageView
    }()

    private lazy var cakeImageView2: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.image = UIImage(systemName: "star")
        return imageView
    }()

    private lazy var cakeImageView3: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.image = UIImage(systemName: "star")
        return imageView
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "브뤨레 케이크 압구정점"
        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.numberOfLines = 2
        return label
    }()

    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "'맛'과 '재미'가 공존하는 브뤨레 케이크에서 소중한 날을 기념할 수 있는 케이크를 경험해 보세요!"
        label.font = .systemFont(ofSize: 16)
        label.numberOfLines = 0
        return label
    }()

    private lazy var contactLabel: UILabel = {
        let label = UILabel()
        label.text = "[매장 연락처 안내]\n센트럴시티점 : 02-7452-5000\n압구정점 : 02-3563-7734\n[메뉴 안내]\n스몰 사이즈 커스텀 : 70,000\n빅 사이즈 커스텀 : 120,000\n*상세 내용은 전화 상담 바랍니다."
        label.font = .systemFont(ofSize: 14)
        label.numberOfLines = 0
        return label
    }()

    private lazy var callButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("02-7452-5000", for: .normal)
        button.setImage(UIImage(systemName: "phone.fill"), for: .normal)
        button.tintColor = .black
        button.backgroundColor = .main
        button.layer.cornerRadius = 10
        return button
    }()
    
    private lazy var locationButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "map.fill"), for: .normal)
        button.tintColor = .black
        button.backgroundColor = .main
        button.layer.cornerRadius = 10
        return button
    }()

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

        // SnapKit Constraints
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalTo(scrollView)
        }

        cakeImageView1.snp.makeConstraints { make in
            make.top.equalTo(contentView)
            make.leading.trailing.equalTo(contentView)
            make.width.equalTo(contentView.snp.width).multipliedBy(0.70)
            make.height.equalTo(cakeImageView1.snp.width).multipliedBy(0.75)
        }

        cakeImageView2.snp.makeConstraints { make in
            make.top.equalTo(contentView)
            make.leading.equalTo(cakeImageView1.snp.trailing)
            make.trailing.equalTo(contentView.snp.trailing)
            make.width.equalTo(contentView.snp.width).multipliedBy(0.30)
            make.height.equalTo(cakeImageView1.snp.height).multipliedBy(0.5)
        }

        cakeImageView3.snp.makeConstraints { make in
            make.top.equalTo(cakeImageView2.snp.bottom)
            make.leading.equalTo(cakeImageView1.snp.trailing)
            make.trailing.equalTo(contentView.snp.trailing)
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
            make.bottom.equalTo(contentView).offset(-20)
        }
    }
}
