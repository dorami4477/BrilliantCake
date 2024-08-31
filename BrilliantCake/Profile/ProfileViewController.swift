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

final class ProfileViewController: BaseViewController {
    private let mainView = ProfileView()
    private let disposeBag = DisposeBag()
    private var dataSource: RxTableViewSectionedReloadDataSource<SectionOfBasicData<String>>! = nil
    private lazy var sections = BehaviorRelay(value: sectionData)
    private let sectionData = [
        SectionOfBasicData(header: "1", items: ["구매 리스트", "내가 작성한 글", "좋아요 한 케이크샵", "로그아웃"])
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
        let input = ProfileViewModel.Input(itemSelected: mainView.tableView.rx.itemSelected)
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
        
        output.itemSelected
            .bind(with: self) { owner, indexPath in
                switch indexPath.row {
                case 0:
                    let paymentVC = PaymentListViewController(viewModel: PaymemtListViewModel())
                    owner.navigationController?.pushViewController(paymentVC, animated: true)
                    
                case 1:
                    let browseVC = BrowseViewController(viewModel: BrowseViewModel())
                    browseVC.viewModel.isMyPage.onNext(true)
                    owner.navigationController?.pushViewController(browseVC, animated: true)
                    
                case 2:
                    let storeListVC = StoreListViewController(viewModel: StoreListViewModel())
                    storeListVC.viewModel.isLikePage.onNext(true)
                    owner.navigationController?.pushViewController(storeListVC, animated: true)
                    
                case 3:
                    owner.showAlertWithCancel(title: Literal.ButtonName.logOut, message: Literal.GuideMessage.logOut, buttonTilte: Literal.ButtonName.comform) { _ in
                        UserDefaultsManager.deleteAllData()
                        let loginVC = LoginViewController()
                        owner.changeRootVC(loginVC)
                    }
                default: break
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
