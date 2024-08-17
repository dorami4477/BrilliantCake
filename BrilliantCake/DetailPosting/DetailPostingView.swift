//
//  DetailPostingView.swift
//  BrilliantCake
//
//  Created by 박다현 on 8/17/24.
//

import UIKit

final class DetailPostingView: BaseView {
    let scrollView = UIScrollView()
    let contentView = UIView()
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
        label.text = "dlfma"
        label.font = UIFont.boldSystemFont(ofSize: 17)
        return label
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "영롱한 제 케이크 좀 봐주세요!"
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.numberOfLines = 0
        return label
    }()
    
    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = """
        엄마 환갑 기념으로 특별히 부탁드렸는데, 너무 만족스러워요.
        사실 맛보다는 그냥 예쁘게 되었으면 좋겠다고 생각했는데, 맛도 이렇게 맛있을 수가 없습니다.
        기념일 마다 이 케이크 집으로+.+
        """
        label.font = UIFont.systemFont(ofSize: 16)
        label.numberOfLines = 0
        return label
    }()
    
    let commentButton: UIButton = {
        let button = UIButton()
        button.setTitle("브뢸레 케이크 압구정점", for: .normal)
        button.setTitleColor(.black, for: .normal)
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
        scrollView.addSubview(contentView)
        contentView.addSubview(collectionView)
        contentView.addSubview(profileImageView)
        contentView.addSubview(nickNameLabel)
        contentView.addSubview(titleLabel)
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(commentButton)
        contentView.addSubview(commentsStackView)
        
        addComment(text: "너무 예쁜데요!! 저도 여기에서 주문 해볼라구영 주문 해야징")
        addComment(text: "세상에나 세상에나 세상에나 세상에나 세상에나 세상에나")
        addComment(text: "우왕와아아양")
        addComment(text: "배고파지네요 케이크 먹고 싶은 충동이 멈추질 않습니다")

    }
    
    override func configureLayout() {
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalTo(scrollView)
        }

        collectionView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.horizontalEdges.equalTo(contentView)
            make.height.equalTo(collectionView.snp.width).multipliedBy(0.75)
        }

        profileImageView.snp.makeConstraints { make in
            make.top.equalTo(collectionView.snp.bottom).offset(20)
            make.leading.equalTo(contentView).offset(20)
            make.size.equalTo(40)
        }

        nickNameLabel.snp.makeConstraints { make in
            make.centerY.equalTo(profileImageView)
            make.leading.equalTo(profileImageView.snp.trailing).offset(20)
        }

        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(profileImageView.snp.bottom).offset(10)
            make.horizontalEdges.equalTo(contentView).inset(20)
        }

        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.horizontalEdges.equalTo(titleLabel)
        }

        commentButton.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(20)
            make.horizontalEdges.equalTo(contentView).inset(20)
            make.height.equalTo(50)
        }

        commentsStackView.snp.makeConstraints { make in
            make.top.equalTo(commentButton.snp.bottom).offset(20)
            make.horizontalEdges.equalTo(contentView).inset(20)
            make.bottom.equalToSuperview().offset(-20)
        }
    }
    


    func addComment(text: String) {
        let commentLabel: UILabel = {
            let label = UILabel()
            label.text = text
            label.font = UIFont.systemFont(ofSize: 14)
            label.numberOfLines = 0
            return label
        }()
        commentsStackView.addArrangedSubview(commentLabel)
    }
}

