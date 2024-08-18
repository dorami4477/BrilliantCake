//
//  StoreViewController.swift
//  BrilliantCake
//
//  Created by 박다현 on 8/18/24.
//

import UIKit
import RxSwift
import RxCocoa

class StoreViewController: BaseViewController {

    let mainView = StoreView()
    let viewModel = StoreViewModel()
    var storeId: String = ""
    let disposeBag = DisposeBag()
    
    override func loadView() {
        view = mainView
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
    }
    
    func bind() {
        let input = StoreViewModel.Input(storeId: Observable.just(storeId), modelSelected: mainView.collectionView.rx.modelSelected(PostData.self))
        let output = viewModel.transform(input: input)
        
        output.postList
            .bind(to: mainView.collectionView.rx.items(cellIdentifier: DetailPostingCVCell.identifier, cellType: DetailPostingCVCell.self)){ index, item, cell in
                let image = NetworkManager.shared.fetchPostImage(url: item.files[0])
                image
                    .subscribe(with: self) { owner, result in
                        switch result {
                        case .success(let imageData):
                            let image = UIImage(data: imageData)
                            cell.mainImageView.image = image
                            
                        case .failure(let error):
                            print(error)
                        }
                    } onFailure: { owner, error in
                        print(error)
                    }
                    .disposed(by: self.disposeBag)
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
                let detailVC = DetailPostingViewController()
                detailVC.viewModel.data = value
                detailVC.mainView.storeButton.isHidden = true
                owner.present(detailVC, animated: true)
                //self.changeRootVC(UINavigationController(rootViewController: detailVC))
            }
            .disposed(by: disposeBag)

    }

    override func configureLayout() {
        mainView.collectionView.register(DetailPostingCVCell.self, forCellWithReuseIdentifier: DetailPostingCVCell.identifier)
    }
}

