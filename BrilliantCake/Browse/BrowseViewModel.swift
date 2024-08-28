//
//  BrowseViewModel.swift
//  BrilliantCake
//
//  Created by 박다현 on 8/16/24.
//

import Foundation
import RxSwift
import RxCocoa

final class BrowseViewModel: BaseViewModel {
    
    private let disposeBag = DisposeBag()
    var data: [PostData] = []
    var data1: PostModel?
    let isMyPage = BehaviorSubject(value: false)
    let nextCursor = BehaviorSubject(value: "")
    var firstLoad = true

    let isSearchMode = BehaviorRelay(value: false)
    
    struct Input {
        let selectedModel: ControlEvent<PostData>
        let textField: ControlProperty<String>
        let searchButtonTap: ControlEvent<Void>
        let cancelButtonTap: ControlEvent<Void>
        let createButtonTap: ControlEvent<Void>
    }
    
    struct Output {
        let postList:Observable<[PostData]>
        let selectedModel: ControlEvent<PostData>
        let isTokenVaild: Observable<Bool>
        let createButtonTap: ControlEvent<Void>
        let isMyPage: BehaviorSubject<Bool>
    }
    
    func transform(input: Input) -> Output {
        let postList = PublishSubject<[PostData]>()
        let isTokenVaild = BehaviorSubject(value: true)
        
        // 일반 포스트 로딩 스트림
            let normalPostStream = Observable.combineLatest(isMyPage, nextCursor, isSearchMode)
                .filter { !$0.2 } // isSearchMode가 false일 때만
                .flatMapLatest { isMyPage, cursor, _ -> Single<Result<PostModel, PostNetworkError>> in
                    if isMyPage {
                        return PostNetworkManager.shared.fetchUserPost(id: UserDefaultsManager.userID, next: cursor)
                        
                    } else {
                        return PostNetworkManager.shared.fetchPost(next: cursor, limit: "15", productId: ProductId.allBCake.rawValue)
                    }
                }

            // 검색 스트림
            let searchStream = input.searchButtonTap
                .debounce(.seconds(1), scheduler: MainScheduler.instance)
                .withLatestFrom(input.textField)
                .do(onNext: { [weak self] _ in self?.isSearchMode.accept(true) })
                .flatMap { value -> Single<Result<PostModel, PostNetworkError>> in
                    self.firstLoad = true
                    let query = SearchQuery(next: "", limit: "13", product_id: ProductId.allBCake.rawValue, hashTag: value)
                    return PostNetworkManager.shared.searchWithHashTag(query: query)
                }

            // 검색 결과 더 로딩 스트림
            let searchMoreStream = Observable.combineLatest(isSearchMode.asObservable(), nextCursor, input.textField)
                .filter { $0.0 && $0.1 != "" } // isSearchMode가 true이고 cursor가 비어있지 않을 때
                .flatMap { _, cursor, inputText -> Single<Result<PostModel, PostNetworkError>> in
                    let query = SearchQuery(next: cursor, limit: "13", product_id: ProductId.allBCake.rawValue, hashTag: inputText)
                    return PostNetworkManager.shared.searchWithHashTag(query: query)
                }

            // 모든 스트림 병합
            Observable.merge(normalPostStream, searchStream, searchMoreStream)
                .subscribe(with: self, onNext: { owner, result in
                    switch result {
                    case .success(let value):
                        owner.data1 = value
                        if owner.firstLoad {
                            owner.data = value.data
                            owner.firstLoad = false
                            
                        } else {
                            owner.data.append(contentsOf: value.data)
                        }

                        postList.onNext(owner.data)
                    case .failure(let error):
                        print(error)
                        if error == .expiredToken {
                            isTokenVaild.onNext(false)
                        }
                    }
                })
                .disposed(by: disposeBag)

        input.cancelButtonTap
            .subscribe(with: self) { owner, _ in
                owner.isSearchMode.accept(false)
                owner.firstLoad = true
                owner.isMyPage.onNext(false)
                owner.nextCursor.onNext("")
            }
            .disposed(by: disposeBag)


        return Output(postList: postList, selectedModel: input.selectedModel, isTokenVaild: isTokenVaild, createButtonTap: input.createButtonTap, isMyPage: isMyPage)
    }
}
