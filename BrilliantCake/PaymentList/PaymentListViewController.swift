//
//  PaymentListViewController.swift
//  BrilliantCake
//
//  Created by 박다현 on 8/28/24.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

final class PaymentListViewController: BaseViewController {
    
    private let tableView = UITableView()
    private let disposeBag = DisposeBag()
    private var dataSource: RxTableViewSectionedReloadDataSource<SectionOfBasicData<ValidationModel>>! = nil
    private lazy var section: PublishRelay<[SectionOfBasicData<ValidationModel>]> = PublishRelay()
    
    private let viewModel: PaymemtListViewModel
    
    init(viewModel: PaymemtListViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureDataSource()
        bind()
    }
    
    private func bind() {
        let input = PaymemtListViewModel.Input()
        let output = viewModel.transform(input: input)
        
        output.list
            .bind(with: self) { owner, value in
                owner.section.accept([
                    SectionOfBasicData(header: "", items: value)
                ])
            }
            .disposed(by: disposeBag)
        
        section
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
    }
    
    private func configureDataSource() {
        dataSource = RxTableViewSectionedReloadDataSource<SectionOfBasicData>(
            configureCell: { dataSource, tableView, indexPath, item in
                guard let cell = tableView.dequeueReusableCell(withIdentifier: PaymentListTableViewCell.identifier, for: indexPath) as? PaymentListTableViewCell else { return UITableViewCell() }
                cell.configure(date: item.paidAt, amount: item.price.formatted(), store: item.productName, buttonText: item.productName)
                return cell
            })
        
    }
    
    override func configureLayout() {
        title = Literal.ViewTitle.paymentList
        view.addSubview(tableView)
        tableView.backgroundColor = .systemGroupedBackground
        tableView.separatorStyle = .none
        tableView.register(PaymentListTableViewCell.self, forCellReuseIdentifier: PaymentListTableViewCell.identifier)
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    
}
