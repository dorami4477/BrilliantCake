//
//  DetailPostingViewController.swift
//  BrilliantCake
//
//  Created by 박다현 on 8/16/24.
//

import UIKit
import RxSwift
import RxCocoa

final class DetailPostingViewController: BaseViewController {

    let mainView = DetailPostingView()
    let viewModel: DetailPostingViewModel
    private let disposeBag = DisposeBag()
    
    init(viewModel: DetailPostingViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        bind()
    }
    
    private func bind() {
        let input = DetailPostingViewModel.Input(storeButtonTap: mainView.storeButton.rx.tap,
                                                 textField: mainView.commentTextField.rx.text.orEmpty,
                                                 addCommentButtonTap: mainView.addCommentButton.rx.tap)
        let output = viewModel.transform(input: input)
        
        output.postData
            .bind(with: self) { owner, value in
                guard let value else { return }
                print("포스팅id", value.id)
                owner.mainView.nickNameLabel.text = value.creator.nick
                owner.mainView.dateLabel.text = value.createdAt.convertToDateTime
                owner.mainView.titleLabel.text = value.title
                owner.mainView.descriptionLabel.text = value.content
                owner.mainView.storeButton.setTitle(value.content2, for: .normal)
                _ = value.comments?.compactMap{ comments in
                    owner.mainView.addComment(user: comments.creator.nick,
                                              drawUpDate: comments.createdAt.convertToDateTime,
                                              comment: comments.content)
                }                
            }
            .disposed(by: disposeBag)
        
        output.postData
            .compactMap { value in
                return value?.files
            }
            .bind(to: mainView.collectionView.rx.items(cellIdentifier: DetailPostingCVCell.identifier, cellType: DetailPostingCVCell.self)){ index, model, cell in
                cell.mainImageView.setImage(url: model)
            }
            .disposed(by: disposeBag)
        
        
        output.storeButtonTap
            .withLatestFrom(output.postData, resultSelector: { _, postData in
                return postData
            })
            .bind(with: self) { owner, value in
                let storeVC = StoreViewController(viewModel: StoreViewModel())
                guard let value else { return }
                storeVC.storeId = value.content1
                owner.navigationController?.pushViewController(storeVC, animated: true)
            }
            .disposed(by: disposeBag)
        
        output.newCommnet
            .bind(with: self) { owner, commnets in
                owner.mainView.addComment(user: commnets.creator.nick,
                                          drawUpDate: commnets.createdAt.convertToDateTime,
                                          comment: commnets.content)
                owner.mainView.commentTextField.text = ""
            }
            .disposed(by: disposeBag)
        
        output.isTokenVaild
            .bind(with: self) { owner, value in
                owner.isExpiredToken(value)
            }
            .disposed(by: disposeBag)
    }
    
    private func configureView() {
        mainView.collectionView.register(DetailPostingCVCell.self, forCellWithReuseIdentifier: DetailPostingCVCell.identifier)
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.view.backgroundColor = UIColor.clear

    }
    
}
