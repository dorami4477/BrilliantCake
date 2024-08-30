//
//  StoreMapInfoViewController.swift
//  BrilliantCake
//
//  Created by 박다현 on 8/29/24.
//

import UIKit
import RxSwift
import RxCocoa

class StoreMapInfoViewController: BaseViewController {
    private let disposeBag = DisposeBag()
    
    private let storeNameLabel: UILabel = {
        let label = UILabel()
        label.font = AppFont.size24Bold
        return label
    }()
    
    private let addressLabel: UILabel = {
        let label = UILabel()
        label.font = AppFont.size15
        return label
    }()
    
    private let exploreStoreButton: UIButton = {
        let button = UIButton()
        button.setTitle("스토어 구경가기", for: .normal)
        button.backgroundColor = .main
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = AppFont.size16Bold
        button.layer.cornerRadius = 8
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    func configureData(id: String, title: String, address: String) {
        storeNameLabel.text = title
        addressLabel.text = address
        
        exploreStoreButton.rx.tap
            .bind(with: self) { owner, _ in
                let storeVC = StoreViewController(viewModel: StoreViewModel())
                storeVC.storeId = id
                owner.present(storeVC, animated: true)
            }
            .disposed(by: disposeBag)
    }

    
    override func configureHierarchy() {
        view.addSubview(storeNameLabel)
        view.addSubview(addressLabel)
        view.addSubview(exploreStoreButton)
    }
    
    override func configureLayout() {
        storeNameLabel.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview().offset(20)
        }
        
        addressLabel.snp.makeConstraints { make in
            make.top.equalTo(storeNameLabel.snp.bottom).offset(8)
            make.horizontalEdges.equalTo(storeNameLabel)
        }
        
        exploreStoreButton.snp.makeConstraints { make in
            make.top.equalTo(addressLabel.snp.bottom).offset(16)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.height.equalTo(48)
        }
    }
}

