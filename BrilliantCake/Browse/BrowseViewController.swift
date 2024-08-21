//
//  BrowseViewController.swift
//  BrilliantCake
//
//  Created by 박다현 on 8/14/24.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

final class BrowseViewController: BaseViewController {
    
    private let viewModel = BrowseViewModel()
    private let disposeBag = DisposeBag()
    private var dataSource: RxCollectionViewSectionedReloadDataSource<SectionOfBasicData>! = nil
    private var section: PublishSubject<[SectionOfBasicData]> = PublishSubject()
    private var collectionView: UICollectionView! = nil
    private let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureDataSource()
        bind()
    }
    
    private func configureDataSource() {
        dataSource = RxCollectionViewSectionedReloadDataSource<SectionOfBasicData>(
            configureCell: { _, collectionView, indexPath, item in
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BrowseCollectionViewCell.identifier, for: indexPath) as! BrowseCollectionViewCell
                cell.mainImageView.setImage(url: item.files[0])
                
                return cell
            },
            configureSupplementaryView: { _, collectionView, kind, indexPath in
                return UICollectionReusableView()
            }
        )
        
    }
    
    private func bind() {
        let input = BrowseViewModel.Input(selectedModel: collectionView.rx.modelSelected(PostData.self), 
                                          textField: searchController.searchBar.rx.text.orEmpty,
                                          searchButtonTap: searchController.searchBar.rx.searchButtonClicked,
                                          cancelButtonTap: searchController.searchBar.rx.cancelButtonClicked)
        let output = viewModel.transform(input: input)
        
        output.postList
            .bind(with: self) { owner, value in
                owner.section.onNext([
                    SectionOfBasicData(header: "", items: value)
                ])
            }
            .disposed(by: disposeBag)
        
        self.section
            .bind(to: collectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        output.selectedModel
            .bind(with: self) { owner, value in
                let detailVC = DetailPostingViewController()
                detailVC.viewModel.data = value
                owner.navigationController?.pushViewController(detailVC, animated: true)
            }
            .disposed(by: disposeBag)
        
        output.isTokenVaild
            .bind(with: self) { owner, value in
                owner.isExpiredToken(value)
            }
            .disposed(by: disposeBag)
    }
    
    override func configureHierarchy() {
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        collectionView.register(BrowseCollectionViewCell.self, forCellWithReuseIdentifier: BrowseCollectionViewCell.identifier)
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.verticalEdges.equalTo(view.safeAreaLayoutGuide)
            make.horizontalEdges.equalToSuperview().inset(1)
        }
    }
    
    override func configureNavigation() {
        let resizedImage = view.resizeImage(image: UIImage(named: ImageName.logo)!, targetSize: CGSize(width: 30, height: 30))
        navigationItem.titleView = UIImageView(image: resizedImage)
        
        searchController.searchBar.placeholder = Literal.GuideMessage.search
        searchController.searchBar.delegate = self
        searchController.searchBar.autocapitalizationType = .none
        searchController.searchBar.autocorrectionType = .no
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    private func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout {
            (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in

            let leadingItem = NSCollectionLayoutItem(
                layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.7),
                                                  heightDimension: .fractionalHeight(1.0)))
            leadingItem.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)

            let trailingItem = NSCollectionLayoutItem(
                layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                  heightDimension: .fractionalHeight(0.3)))
            trailingItem.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
            
            let trailingGroup = NSCollectionLayoutGroup.vertical(
                layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.3),
                                                  heightDimension: .fractionalHeight(1.0)),
                subitem: trailingItem, count: 2)

            let nestedGroup = NSCollectionLayoutGroup.horizontal(
                layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                  heightDimension: .fractionalHeight(0.5)),
                subitems: [leadingItem, trailingGroup])
            
            let nestedGroup2 = NSCollectionLayoutGroup.horizontal(
                layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                  heightDimension: .fractionalHeight(0.5)),
                subitems: [trailingGroup, leadingItem])
            
            let allGroup = NSCollectionLayoutGroup.vertical(
                layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                   heightDimension: .fractionalHeight(0.8)),
                subitems: [nestedGroup, nestedGroup2])
            
            let section = NSCollectionLayoutSection(group: allGroup)
            return section

        }
        return layout
    }
    
}


// MARK: - UISearchBarDelegate
extension BrowseViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text else { return }
        print(text)

    }
}

// MARK: - Section for CollectionView
struct SectionOfBasicData {
    var header: String
    var items: [Item]
}

extension SectionOfBasicData: SectionModelType {
    typealias Item = PostData
    
    init(original: SectionOfBasicData, items: [Item]) {
        self = original
        self.items = items
    }
}
