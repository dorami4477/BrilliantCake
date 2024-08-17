//
//  DetailPostingViewController.swift
//  BrilliantCake
//
//  Created by 박다현 on 8/16/24.
//

import UIKit
import RxSwift
import RxCocoa

class DetailPostingViewController: BaseViewController {

    let mainView = DetailPostingView()
    let viewModel = DetailPostingViewModel()
    let disposeBag = DisposeBag()
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        bind()
    }
    
    func bind() {
        let input = DetailPostingViewModel.Input()
        let output = viewModel.transform(input: input)
        
        output.postData
            .bind(with: self) { owner, value in
                guard let value else { return }
                owner.mainView.titleLabel.text = value.title
            }
            .disposed(by: disposeBag)
        
        output.imageData
            .map { value in
                value.map {
                    UIImage(data: $0)
                }
            }
            .bind(to: mainView.collectionView.rx.items(cellIdentifier: "DetailPostingCVCell", cellType: DetailPostingCVCell.self)){ index, model, cell in
                cell.mainImageView.image = model
            }
            .disposed(by: disposeBag)
        
    }
    
    func configureView() {
        mainView.collectionView.register(DetailPostingCVCell.self, forCellWithReuseIdentifier: "DetailPostingCVCell")
    }
    

}
