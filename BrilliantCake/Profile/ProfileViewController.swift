//
//  ProfileViewController.swift
//  BrilliantCake
//
//  Created by 박다현 on 8/22/24.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

class ProfileViewController: BaseViewController {
    private let mainView = ProfileView()
    private let disposeBag = DisposeBag()
    private var dataSource: RxTableViewSectionedReloadDataSource<SectionOfBasicData<String>>! = nil
    private lazy var sections = BehaviorRelay(value: sectionData)
    private let sectionData = [
        SectionOfBasicData(header: "1", items: ["프로필 수정", "구매 리스트", "내가 작성한 글", "좋아요 한 케이크샵"])
    ]
    private let viewModel: ProfileViewModel
    
    init(viewModel: ProfileViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    override func loadView() {
        view = mainView
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        configureDataSource()
        bind()
    }
    
    private func bind() {
        let input = ProfileViewModel.Input()
        let output = viewModel.transform(input: input)
        
        sections
            .asObservable()
            .bind(to: mainView.tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        output.profileData
            .bind(with: self) { owner, value in
                owner.mainView.nameLabel.text = value.nick
                owner.mainView.emailLabel.text = value.email
            }
            .disposed(by: disposeBag)
        
        mainView.tableView.rx.itemSelected
            .bind(with: self) { owner, indexPath in
                if indexPath.row == 1 {
                    let paymentVC = PaymentListViewController(viewModel: PaymemtListViewModel())
                    owner.navigationController?.pushViewController(paymentVC, animated: true)
                } else if indexPath.row == 2 {
                    let browseVC = BrowseViewController(viewModel: BrowseViewModel())
                    browseVC.viewModel.isMyPage.onNext(true)
                    owner.navigationController?.pushViewController(browseVC, animated: true)
                } else if indexPath.row == 3 {
                    let storeListVC = StoreListViewController(viewModel: StoreListViewModel())
                    storeListVC.viewModel.isLikePage.onNext(true)
                    owner.navigationController?.pushViewController(storeListVC, animated: true)
                }
            }
            .disposed(by: disposeBag)
        
    }
    
    private func configureDataSource() {
        dataSource = RxTableViewSectionedReloadDataSource<SectionOfBasicData>(
            configureCell: { dataSource, tableView, indexPath, item in
                let cell = tableView.dequeueReusableCell(withIdentifier: UITableViewCell.identifier, for: indexPath)
                cell.textLabel?.text = item
                cell.accessoryType = .disclosureIndicator
                cell.selectionStyle = .none
                return cell
            })
        
    }
    
    override func configureLayout() {
        view.backgroundColor = .systemGroupedBackground
        mainView.tableView.register(UITableViewCell.self, forCellReuseIdentifier: UITableViewCell.identifier)
    }
    
}
