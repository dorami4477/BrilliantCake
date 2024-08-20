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
    private let viewModel = StoreListViewModel()
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
    }
    
    private func bind() {
        let input = StoreListViewModel.Input(modelSelected: tableView.rx.modelSelected(PostData.self))
        let output = viewModel.transform(input: input)
        
        output.postList
            .bind(to: tableView.rx.items(cellIdentifier: StoreListTableViewCell.identifier, cellType: StoreListTableViewCell.self)){ row, element, cell in
                
                guard element.files.count == 3 else {
                    print("Expected exactly 3 image URLs, but got \(element.files.count)")
                    return
                }
                
                let imageViews = [cell.storeImageView1, cell.storeImageView2, cell.storeImageView3]
                
                for (index, url) in element.files.enumerated() {
                    imageViews[index].setImage(url: url)
                }
                
                cell.nameLabel.text = element.title
                cell.detailsLabel.text = element.content
            }
            .disposed(by: disposeBag)
        
        output.modelSelected
            .bind(with: self) { owner, value in
                let storeVC = StoreViewController()
                storeVC.storeId = value.id
                owner.navigationController?.pushViewController(storeVC, animated: true)
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
