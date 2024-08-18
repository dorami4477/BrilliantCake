//
//  DetailPostingView.swift
//  BrilliantCake
//
//  Created by 박다현 on 8/17/24.
//

import UIKit

final class DetailPostingView: BaseView {
    let scrollView: UIScrollView = {
        let view = UIScrollView()
        view.backgroundColor = .lightGray
        view.contentInsetAdjustmentBehavior = .never
        return view
    }()
    
    let contentView1: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 20
        return view
    }()
    
    let contentView2: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 20
        return view
    }()
    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
    
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "person")
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 20
        imageView.clipsToBounds = true
        return imageView
    }()
    
    let nickNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 17)
        return label
    }()
    
    let dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = .gray
        return label
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.numberOfLines = 0
        return label
    }()
    
    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.numberOfLines = 0
        return label
    }()
    
    let storeButton: UIButton = {
        let button = UIButton()
        button.setTitle("브뢸레 케이크 압구정점", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 20)
        button.backgroundColor = .main
        button.layer.cornerRadius = 8
        return button
    }()
    
    let commentsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: screenSize().width, height: screenSize().width)
        return layout
    }
    
    override func configureHierarchy() {
        addSubview(scrollView)
        scrollView.addSubview(contentView1)
        scrollView.addSubview(contentView2)
        contentView1.addSubview(collectionView)
        contentView1.addSubview(profileImageView)
        contentView1.addSubview(nickNameLabel)
        contentView1.addSubview(dateLabel)
        contentView1.addSubview(titleLabel)
        contentView1.addSubview(descriptionLabel)
        contentView1.addSubview(storeButton)
        contentView2.addSubview(commentsStackView)
        
        addComment(text: "너무 예쁜데요!! 저도 여기에서 주문 해볼라구영 주문 해야징")
        addComment(text: "세상에나 세상에나 세상에나 세상에나 세상에나 세상에나")
        addComment(text: "우왕와아아양")
        addComment(text: "배고파지네요 케이크 먹고 싶은 충동이 멈추질 않습니다")
        
    }
    
    override func configureLayout() {
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        contentView1.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview()
            make.width.equalTo(scrollView)
        }
        
        contentView2.snp.makeConstraints { make in
            make.top.equalTo(contentView1.snp.bottom).offset(10)
            make.horizontalEdges.bottom.equalToSuperview()
            make.width.equalTo(scrollView)
        }

        collectionView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.horizontalEdges.equalTo(contentView1)
            make.height.equalTo(collectionView.snp.width).multipliedBy(0.75)
        }

        profileImageView.snp.makeConstraints { make in
            make.top.equalTo(collectionView.snp.bottom).offset(20)
            make.leading.equalTo(contentView1).offset(20)
            make.size.equalTo(40)
        }

        nickNameLabel.snp.makeConstraints { make in
            make.centerY.equalTo(profileImageView).offset(-10)
            make.leading.equalTo(profileImageView.snp.trailing).offset(20)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(nickNameLabel.snp.bottom)
            make.leading.equalTo(profileImageView.snp.trailing).offset(20)
        }

        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(profileImageView.snp.bottom).offset(10)
            make.horizontalEdges.equalTo(contentView1).inset(20)
        }

        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.horizontalEdges.equalTo(titleLabel)
        }

        storeButton.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(20)
            make.horizontalEdges.bottom.equalTo(contentView1).inset(20)
            make.height.equalTo(50)
        }

        commentsStackView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(contentView2).inset(20)
            make.bottom.equalToSuperview().offset(-20)
        }
    }
    


    func addComment(text: String) {
        let commentLabel: UILabel = {
            let label = UILabel()
            label.text = text
            label.font = UIFont.systemFont(ofSize: 17)
            label.numberOfLines = 0
            return label
        }()
        commentsStackView.addArrangedSubview(commentLabel)
    }
}

