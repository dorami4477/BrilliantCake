//
//  StoreViewController.swift
//  BrilliantCake
//
//  Created by 박다현 on 8/18/24.
//

import UIKit
import RxSwift
import RxCocoa

final class StoreViewController: BaseViewController {

    private let mainView = StoreView()
    private let viewModel: StoreViewModel
    private let disposeBag = DisposeBag()
    var storeId: String = ""
    
    init(viewModel: StoreViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    override func loadView() {
        view = mainView
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
    }
    
    private func bind() {
        let input = StoreViewModel.Input(storeId: Observable.just(storeId),
                                         modelSelected: mainView.collectionView.rx.modelSelected(PostData.self), 
                                         mapButtonTap: mainView.locationButton.rx.tap, 
                                         likeButtonTap: navigationItem.rightBarButtonItem?.rx.tap)
        let output = viewModel.transform(input: input)

        output.postList
            .bind(to: mainView.collectionView.rx.items(cellIdentifier: DetailPostingCVCell.identifier, cellType: DetailPostingCVCell.self)){ index, item, cell in
                cell.mainImageView.setImage(url: item.files[0])
            }
            .disposed(by: disposeBag)
        
        output.storeData
            .bind(with: self) { owner, value in
                owner.mainView.titleLabel.text = value.title
                owner.mainView.descriptionLabel.text = value.content
                owner.mainView.contactLabel.text = value.content1
                owner.mainView.callButton.setTitle(value.content2, for: .normal)
            }
            .disposed(by: disposeBag)
        
        output.postList
            .withUnretained(self)
            .map{ owner, value in
                var colum = value.count / 3
                let last = value.count % 3
                if last > 0 {
                    colum += 1
                }
                return Int(owner.screenSize().width) / 3 * colum
            }
            .bind(with: self) { owner, value in
                owner.mainView.collectionView.snp.updateConstraints { make in
                    make.height.equalTo(value)
                }
            }
            .disposed(by: disposeBag)
        
        output.modelSelected
            .bind(with: self) { owner, value in
                let detailVC = DetailPostingViewController(viewModel: DetailPostingViewModel())
                detailVC.viewModel.data = value
                detailVC.mainView.storeButton.isHidden = true
                owner.present(detailVC, animated: true)
            }
            .disposed(by: disposeBag)
        
        output.storeData
            .map{ value in
                value.files
            }
            .bind(with: self) { owner, value in
                owner.mainView.cakeImageView1.setImage(url: value[0])
                owner.mainView.cakeImageView2.setImage(url: value[1])
                owner.mainView.cakeImageView3.setImage(url: value[2])
            }
            .disposed(by: disposeBag)
        
        Observable
            .zip(output.mapCoord, output.storeData)
            .bind(with: self) { owner, value in
                let mapVC = StoreMapMarkerViewController()
                mapVC.coord = value.0
                mapVC.storeInfo = (value.1.title, value.1.content)
                owner.navigationController?.pushViewController(mapVC, animated: true)
            }
            .disposed(by: disposeBag)
        
        output.like
            .bind(with: self) { owner, value in
                owner.navigationItem.rightBarButtonItem?.image = value ? UIImage(systemName: "heart.fill") : UIImage(systemName: "heart")
                owner.navigationItem.rightBarButtonItem?.tintColor = value ? .main : .black
            }
            .disposed(by: disposeBag)
        
        output.isTokenVaild
            .bind(with: self) { owner, value in
                owner.isExpiredToken(value)
            }
            .disposed(by: disposeBag)
    }

    override func configureNavigation() {
        let likeButton = UIBarButtonItem(image: UIImage(systemName: "heart"))
        navigationItem.rightBarButtonItem = likeButton
    }
    

    
    override func configureLayout() {
        mainView.collectionView.register(DetailPostingCVCell.self, forCellWithReuseIdentifier: DetailPostingCVCell.identifier)
    }
}
