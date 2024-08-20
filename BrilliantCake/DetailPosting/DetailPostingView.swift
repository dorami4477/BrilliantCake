//
//  DetailPostingView.swift
//  BrilliantCake
//
//  Created by 박다현 on 8/17/24.
//

import UIKit

final class DetailPostingView: BaseView {
    
    private let scrollView = {
        let view = UIScrollView()
        view.backgroundColor = .lightGray
        view.contentInsetAdjustmentBehavior = .never
        return view
    }()
    
    private let contentView1 = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 20
        return view
    }()
    
    private let contentStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = 20
        view.distribution = .equalSpacing
        return view
    }()
    
    private let contentView2 = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 20
        return view
    }()
    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
    
    let profileImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "BC_11")
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 20
        imageView.clipsToBounds = true
        return imageView
    }()
    
    let nickNameLabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 17)
        return label
    }()
    
    let dateLabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = .gray
        return label
    }()
    
    let titleLabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.numberOfLines = 0
        return label
    }()
    
    let descriptionLabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.numberOfLines = 0
        return label
    }()
    
    let storeButton = UIButton()
  
    let commentsStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    private let commentTextView = {
        let view = UIView()
        view.backgroundColor = .backgroundGray
        view.layer.cornerRadius = 10
        view.layer.borderColor = UIColor.lightGray.cgColor
        view.layer.borderWidth = 1
        return view
    }()
    
    let commentTextField = {
        let textField = UITextField()
        textField.placeholder = "댓글을 입력해보세요!"
        return textField
    }()
    
    lazy var addCommentButton = { [weak self] in
        let button = UIButton()
        let image = self?.resizeImage(image: UIImage(named: "BC_12")!, targetSize: CGSize(width: 30, height: 30))
        button.setImage(image, for: .normal)
        return button
    }()
    
    private func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
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
        contentView1.addSubview(contentStackView)
        contentStackView.addArrangedSubview(descriptionLabel)
        contentStackView.addArrangedSubview(storeButton)
        contentView2.addSubview(commentsStackView)
        contentView2.addSubview(commentTextView)
        commentTextView.addSubview(commentTextField)
        commentTextView.addSubview(addCommentButton)
    }
    
    override func configureLayout() {
        scrollView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview()
            make.bottom.equalTo(safeAreaLayoutGuide)
        }
        
        contentView1.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview()
            make.width.equalTo(scrollView)
        }
        
        contentView2.snp.makeConstraints { make in
            make.top.equalTo(contentView1.snp.bottom).offset(10)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalToSuperview()  
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.horizontalEdges.equalTo(contentView1)
            make.height.equalTo(collectionView.snp.width).multipliedBy(0.9)
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
        
        contentStackView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.horizontalEdges.equalTo(contentView1).inset(20)
            make.bottom.equalToSuperview().inset(30)
        }
        
        storeButton.snp.makeConstraints { make in
            make.height.equalTo(50)
        }
        
        commentsStackView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(contentView2).inset(20)
        }
        
        commentTextView.snp.makeConstraints { make in
            make.top.equalTo(commentsStackView.snp.bottom).offset(10)
            make.horizontalEdges.equalTo(contentView2).inset(20)
            make.bottom.equalTo(contentView2).inset(30)
        }
        
        commentTextField.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview()
            make.leading.equalToSuperview().offset(10)
            make.height.equalTo(44)
        }
        
        addCommentButton.snp.makeConstraints { make in
            make.leading.equalTo(commentTextField.snp.trailing)
            make.trailing.equalToSuperview().inset(10)
            make.size.equalTo(30)
            make.centerY.equalToSuperview()
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
        collectionView.isPagingEnabled = true
    }
}

