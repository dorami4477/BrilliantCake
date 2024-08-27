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
    
    let viewModel: BrowseViewModel
    private let disposeBag = DisposeBag()
    private var dataSource: RxCollectionViewSectionedReloadDataSource<SectionOfBasicData<PostData>>! = nil
    private var section: PublishSubject<[SectionOfBasicData<PostData>]> = PublishSubject()
    private var collectionView: UICollectionView! = nil
    private let searchController = UISearchController(searchResultsController: nil)
    private let createButton = UIButton()
    
    init(viewModel: BrowseViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureDataSource()
        bind()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        NotificationCenter.default.addObserver(self, selector: #selector(changePost), name: .delete, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: .delete, object: nil)
    }
    
    @objc func changePost() {
        do {
            let currentIsLikePageValue = try viewModel.isMyPage.value()
            Observable.zip(viewModel.isMyPage, viewModel.nextCursor)
                .take(1)
                .observe(on:MainScheduler.asyncInstance)
                .subscribe(with: self, onNext: { owner, _ in
                    owner.viewModel.firstLoad = true
                    owner.viewModel.isMyPage.onNext(currentIsLikePageValue)
                    owner.viewModel.nextCursor.onNext("")
                })
                .disposed(by: disposeBag)
            
        } catch {
            print("Error getting value from isLikePage: \(error)")
        }
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
                                          cancelButtonTap: searchController.searchBar.rx.cancelButtonClicked,
                                          createButtonTap: createButton.rx.tap)
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
                let detailVC = DetailPostingViewController(viewModel: DetailPostingViewModel())
                detailVC.viewModel.data = value
                detailVC.viewModel.isMyPage = output.isMyPage
                owner.navigationController?.pushViewController(detailVC, animated: true)
            }
            .disposed(by: disposeBag)
        
        output.createButtonTap
            .bind(with: self) { owner, value in
                let createVC = CreatePostViewController(viewModel: CreatePostViewModel())
                createVC.viewModel.createdNewPost
                    .bind(with: self, onNext: { owner, value in
                        owner.viewModel.isMyPage.onNext(value)
                        owner.viewModel.firstLoad = !value
                        owner.viewModel.nextCursor.onNext("")
                        owner.collectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .top, animated: true)
                    })
                    .disposed(by: owner.disposeBag)
                
                
                owner.navigationController?.pushViewController(createVC, animated: true)
            }
            .disposed(by: disposeBag)
        
        output.isMyPage
            .bind(with: self) { owner, value in
                if value {
                    owner.navigationItem.searchController = .none
                    owner.navigationItem.titleView = .none
                    owner.navigationItem.title = Literal.viewTitle.myPosting
                }
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
        collectionView.prefetchDataSource = self
        view.addSubview(collectionView)
        view.addSubview(createButton)
    }
    
    override func configureLayout() {
        collectionView.snp.makeConstraints { make in
            make.verticalEdges.equalTo(view.safeAreaLayoutGuide)
            make.horizontalEdges.equalToSuperview().inset(1)
        }
        createButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(15)
            make.width.equalTo(180)
            make.height.equalTo(44)
        }
        createButton.setTitle(Literal.ButtonName.createPost, for: .normal)
        createButton.setTitleColor(.black, for: .normal)
        createButton.backgroundColor = .main
        createButton.layer.cornerRadius = 20
    }
    
    override func configureNavigation() {
        let resizedImage = view.resizeImage(image: UIImage(named: ImageName.cakeLogo)!, targetSize: CGSize(width: 30, height: 30))
        navigationItem.titleView = UIImageView(image: resizedImage)
        
        searchController.searchBar.placeholder = Literal.GuideMessage.search
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

// MARK: - CollectionViewPrefetching
extension BrowseViewController:UICollectionViewDataSourcePrefetching{
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        
        guard let nextCursor = viewModel.data1?.next_cursor else { return }
        for item in indexPaths{
            if viewModel.data.count - 3 == item.item && nextCursor != "0" {
                print("new Cursor", nextCursor)
                viewModel.nextCursor.onNext(nextCursor)
            }
        }
    }
    
}



