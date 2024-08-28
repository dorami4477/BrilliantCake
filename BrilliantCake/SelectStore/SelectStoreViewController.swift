//
//  SelectStoreViewController.swift
//  BrilliantCake
//
//  Created by 박다현 on 8/24/24.
//

import UIKit
import RxSwift
import RxCocoa

final class SelectStoreViewController: BaseViewController {
    private let tableView = UITableView(frame: .zero, style: .insetGrouped)
    let viewModel: SelectStoreViewModel
    private let disposeBag = DisposeBag()

    init(viewModel: SelectStoreViewModel) {
        self.viewModel = viewModel
        super.init()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
    }
    
    private func bind() {
        let input = SelectStoreViewModel.Input(modelSelected: tableView.rx.modelSelected(PostData.self))
        let output = viewModel.transform(input: input)
        
        output.postList
            .bind(to: tableView.rx.items(cellIdentifier: SelectStoreTableViewCell.identifier, cellType: SelectStoreTableViewCell.self)){ row, element, cell in
                
                cell.nameLabel.text = element.title
                cell.detailsLabel.text = element.content
                cell.selectionStyle = .none
            }
            .disposed(by: disposeBag)
        
        output.modelSelected
            .bind(with: self) { owner, value in
                owner.viewModel.selectedStore.onNext(value)
                owner.navigationController?.popViewController(animated: true)
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
        tableView.register(SelectStoreTableViewCell.self, forCellReuseIdentifier: SelectStoreTableViewCell.identifier)
        tableView.rowHeight = 100
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
}
