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
        imageView.image = UIImage(named: "BC_11")
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
    
    let storeButton = UIButton()
  
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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureStoreButton()
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
            make.bottom.equalToSuperview().offset(-50)
        }
    }
    


    func addComment(user: String, drawUpDate:String, comment:String) {
        let commentView = UIView()
        
        let userLabel: UILabel = {
            let label = UILabel()
            label.text = user
            label.font = UIFont.boldSystemFont(ofSize: 14)
            return label
        }()
        
        let drawUpDateLabel: UILabel = {
            let label = UILabel()
            label.text = drawUpDate
            label.font = UIFont.systemFont(ofSize: 14)
            label.textColor = .gray
            return label
        }()
        
        let commentLabel: UILabel = {
            let label = CommentLabel(padding: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10))
            label.text = comment
            return label
        }()
        
        commentsStackView.addArrangedSubview(commentView)
        commentView.addSubview(userLabel)
        commentView.addSubview(drawUpDateLabel)
        commentView.addSubview(commentLabel)

        commentView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.height.greaterThanOrEqualTo(0)
        }
        
        userLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.leading.equalToSuperview().offset(10)
        }
        
        drawUpDateLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.leading.equalTo(userLabel.snp.trailing).offset(10)
        }
        
        commentLabel.snp.makeConstraints { make in
            make.top.equalTo(userLabel.snp.bottom).offset(10)
            make.leading.equalToSuperview().inset(20)
            make.trailing.equalToSuperview().inset(10)
            make.bottom.equalToSuperview().inset(10)
        }
    }
    
    private func configureStoreButton() {
        let resizedImage = resizeImage(image: UIImage(named: "BC_13")!, targetSize: CGSize(width: 25, height: 25))
        
        var configuration = UIButton.Configuration.filled()
        configuration.image = resizedImage
        configuration.baseBackgroundColor = .main
        configuration.baseForegroundColor = .black
        configuration.background.cornerRadius = 10
        configuration.imagePadding = 8
        
        storeButton.configuration = configuration
        storeButton.titleLabel?.font = .boldSystemFont(ofSize: 18)
    }
}

