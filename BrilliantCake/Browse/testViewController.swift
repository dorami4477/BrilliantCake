//
//  testViewController.swift
//  BrilliantCake
//
//  Created by 박다현 on 8/16/24.
//

import UIKit
import RxSwift
import RxCocoa
import Kingfisher

//final class BrowseViewController: BaseViewController {
//
//    enum Section {
//        case main
//    }
//    
//    let viewModel = BrowseViewModel()
//    let disposeBag = DisposeBag()
//    var dataSource: UICollectionViewDiffableDataSource<Section, PostData>! = nil
//    var snapshot = NSDiffableDataSourceSnapshot<Section, PostData>()
//    var collectionView: UICollectionView! = nil
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        bind()
//        configureDataSource()
//    }
//    
//    func bind() {
//        let input = BrowseViewModel.Input(selectedModel: collectionView.rx.modelSelected(PostData.self))
//        let output = viewModel.transform(input: input)
//       
//        snapshot.appendSections([Section.main])
//        
//        output.postList
//            .bind(with: self) { owner, value in
//                owner.snapshot.appendItems(value)
//                print("데이터", owner.snapshot.numberOfItems)
//                owner.dataSource.apply(owner.snapshot, animatingDifferences: false)
//            }
//            .disposed(by: disposeBag)
//        
//        output.selectedModel
//            .bind(with: self) { owner, _ in
//                let detailVC = DetailPostingViewController()
//                owner.navigationController?.pushViewController(detailVC, animated: true)
//            }
//            .disposed(by: disposeBag)
//    }
//    
//    
//    override func configureHierarchy() {
//        collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
//        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
//        view.addSubview(collectionView)
//        collectionView.snp.makeConstraints { make in
//            make.edges.equalTo(view.safeAreaLayoutGuide)
//        }
//    }
//    override func configureNavigation() {
//        let searchController = UISearchController(searchResultsController: nil)
//        searchController.searchBar.placeholder = Literal.GuideMessage.search
//        searchController.hidesNavigationBarDuringPresentation = false
//        searchController.searchBar.delegate = self
//        searchController.searchBar.autocapitalizationType = .none
//        searchController.searchBar.autocorrectionType = .no
//        navigationItem.searchController = searchController
//        navigationItem.hidesSearchBarWhenScrolling = false
//    }
//    
//    func createLayout() -> UICollectionViewLayout {
//        let layout = UICollectionViewCompositionalLayout {
//            (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
//
//            let leadingItem = NSCollectionLayoutItem(
//                layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.7),
//                                                  heightDimension: .fractionalHeight(1.0)))
//            leadingItem.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
//
//            let trailingItem = NSCollectionLayoutItem(
//                layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
//                                                  heightDimension: .fractionalHeight(0.3)))
//            trailingItem.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
//            
//            let trailingGroup = NSCollectionLayoutGroup.vertical(
//                layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.3),
//                                                  heightDimension: .fractionalHeight(1.0)),
//                subitem: trailingItem, count: 2)
//
//            let nestedGroup = NSCollectionLayoutGroup.horizontal(
//                layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
//                                                  heightDimension: .fractionalHeight(0.5)),
//                subitems: [leadingItem, trailingGroup])
//            
//            let nestedGroup2 = NSCollectionLayoutGroup.horizontal(
//                layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
//                                                  heightDimension: .fractionalHeight(0.5)),
//                subitems: [trailingGroup, leadingItem])
//            
//            let allGroup = NSCollectionLayoutGroup.vertical(
//                layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
//                                                   heightDimension: .fractionalHeight(0.8)),
//                subitems: [nestedGroup, nestedGroup2])
//            
//            let section = NSCollectionLayoutSection(group: allGroup)
//            return section
//
//        }
//        return layout
//    }
//
//    func configureDataSource() {
//        
//        let cellRegistration = UICollectionView.CellRegistration<BrowseCollectionViewCell, PostData> { (cell, indexPath, identifier) in
//            guard let fileUrl = identifier.files[0] else { return }
//            print(fileUrl)
//            ** 뷰모델로 옮기기
//            let image = NetworkManager.shared.fetchPostImage(url: fileUrl)
//            image
//                .subscribe(with: self) { owner, result in
//                    switch result {
//                    case .success(let imageData):
//                        let image = UIImage(data: imageData)
//                        cell.mainImageView.image = image
//
//                    case .failure(let error):
//                        print(error)
//
//                    }
//                } onFailure: { owner, error in
//                    print(error)
//                }
//                .disposed(by: self.disposeBag)
//        }
//        
//        dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
//            let cell = collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: itemIdentifier)
//            return cell
//        })
//
//    }
//    
//}
//
//
// MARK: - UISearchBarDelegate
//extension BrowseViewController: UISearchBarDelegate {
//    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//        guard let text = searchBar.text else { return }
//        print(text)
//
//    }
//}
//
