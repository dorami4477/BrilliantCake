//
//  StoreListViewController.swift
//  BrilliantCake
//
//  Created by 박다현 on 8/19/24.
//

import UIKit
import RxSwift
import RxCocoa

final class StoreListViewController: BaseViewController {
    
    private let tableView = UITableView()
    let viewModel: StoreListViewModel
    private let disposeBag = DisposeBag()

    init(viewModel: StoreListViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
    }
    
    private func bind() {
        let input = StoreListViewModel.Input(modelSelected: tableView.rx.modelSelected(PostData.self))
        let output = viewModel.transform(input: input)
        
        output.postList
            .bind(to: tableView.rx.items(cellIdentifier: StoreListTableViewCell.identifier, cellType: StoreListTableViewCell.self)){ row, element, cell in
                
                cell.configureData(data: element)
                cell.selectionStyle = .none
            }
            .disposed(by: disposeBag)
        
        output.modelSelected
            .bind(with: self) { owner, value in
                let storeVC = StoreViewController(viewModel: StoreViewModel())
                storeVC.storeId = value.id
                owner.navigationController?.pushViewController(storeVC, animated: true)
            }
            .disposed(by: disposeBag)
        
        output.isTokenVaild
            .bind(with: self) { owner, value in
                owner.isExpiredToken(value)
            }
            .disposed(by: disposeBag)
    }
    
    override func configureHierarchy() {
        view.addSubview(tableView)
    }
    
    override func configureLayout() {
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        tableView.register(StoreListTableViewCell.self, forCellReuseIdentifier: StoreListTableViewCell.identifier)
    }
       
}
