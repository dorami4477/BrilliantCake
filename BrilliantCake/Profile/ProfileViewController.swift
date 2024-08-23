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

    let mainView = ProfileView()
    private let disposeBag = DisposeBag()
    private var dataSource: RxTableViewSectionedReloadDataSource<SectionOfData>! = nil
    private lazy var sections = BehaviorRelay(value: sectionData)
    private let sectionData = [
        SectionOfData(header: "1", items: ["프로필 수정", "내가 작성한 글", "좋아요 한 케이크샵"])
    ]
    
    override func loadView() {
        view = mainView
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        configureDataSource()
        bind()
    }
    
    private func bind() {
        sections
            .asObservable()
            .bind(to: mainView.tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
    }
    
    private func configureDataSource() {
        dataSource = RxTableViewSectionedReloadDataSource<SectionOfData>(
          configureCell: { dataSource, tableView, indexPath, item in
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
              cell.textLabel?.text = item
              cell.accessoryType = .disclosureIndicator
            return cell
        })
        
    }

    override func configureLayout() {
        view.backgroundColor = .systemGroupedBackground
        mainView.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }

}

struct SectionOfData {
    var header: String
    var items: [Item]
}

extension SectionOfData: SectionModelType {
    typealias Item = String
    
    init(original: SectionOfData, items: [Item]) {
        self = original
        self.items = items
    }
}
