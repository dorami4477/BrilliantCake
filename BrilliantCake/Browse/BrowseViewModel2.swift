//
//  BrowseViewModel.swift
//  BrilliantCake
//
//  Created by 박다현 on 8/16/24.
//

//import Foundation
//import RxSwift
//import RxCocoa
//
//final class BrowseViewModel: BaseViewModel {
//    
//    private let disposeBag = DisposeBag()
//    var data: [PostData] = []
//    var data1: PostModel?
//    let isMyPage = BehaviorSubject(value: false)
//    let nextCursor = BehaviorSubject(value: "")
//    var firstLoad = false
//    
//    let SearchMode = BehaviorSubject(value: false)
//    var isSearchMode = false
//    
//    struct Input {
//        let selectedModel: ControlEvent<PostData>
//        let textField: ControlProperty<String>
//        let searchButtonTap: ControlEvent<Void>
//        let cancelButtonTap: ControlEvent<Void>
//        let createButtonTap: ControlEvent<Void>
//    }
//    
//    struct Output {
//        let postList:Observable<[PostData]>
//        let selectedModel: ControlEvent<PostData>
//        let isTokenVaild: Observable<Bool>
//        let createButtonTap: ControlEvent<Void>
//        let isMyPage: BehaviorSubject<Bool>
//    }
//    
//    func transform(input: Input) -> Output {
//        let postList = PublishSubject<[PostData]>()
//        let isTokenVaild = BehaviorSubject(value: true)
//        
//        Observable.combineLatest(isMyPage, nextCursor)
//            .flatMapLatest { isMyPage -> Single<Result<PostModel, PostNetworkError>> in
//                if isMyPage.0 {
//                    return PostNetworkManager.shared.fetchUserPost(id: UserDefaultsManager.userID, next: isMyPage.1)
//                    
//                } else {
//                    return PostNetworkManager.shared.fetchPost(next: isMyPage.1, productId: "allBCake")
//                }
//            }
//            .subscribe(with: self, onNext: { owner, value in
//                switch value {
//                case .success(let result):
//                    
//                    owner.data1 = result
//                    owner.isSearchMode = false
//                    
//                    if owner.firstLoad {
//                        owner.data = result.data
//                        postList.onNext(owner.data)
//                        owner.firstLoad = false
//                        
//                    } else {
//                        owner.data.append(contentsOf: result.data)
//                        postList.onNext(owner.data)
//                    }
//                    
//                case .failure(let error):
//                    print("postdata", error)
//                    if error == .expiredToken {
//                        isTokenVaild.onNext(false)
//                    }
//                }
//            }, onError: { owner, error in
//                print(error)
//            }, onCompleted: { owner in
//                print("onCompleted")
//            }, onDisposed: { owner in
//                print("disposed")
//            })
//            .disposed(by: disposeBag)
//        
//
//        input.searchButtonTap
//            .debounce(.seconds(1), scheduler: MainScheduler.instance)
//            .withLatestFrom(input.textField)
//            .distinctUntilChanged()
//            .flatMap { value in
//                let query = SearchQuery(next: "", limit: "13", product_id: "allBCake", hashTag: value)
//                let result = PostNetworkManager.shared.searchWithHashTag(query: query)
//                return result
//            }
//            .subscribe(with: self, onNext: { owner, result in
//                switch result {
//                case .success(let value):
//                    owner.data1 = value
//                    owner.data = value.data
//                    postList.onNext(owner.data)
//                    owner.isSearchMode = true
//                    print("eee")
//                    
//                case .failure(let error):
//                    print(error)
//                    if error == .expiredToken {
//                        isTokenVaild.onNext(false)
//                    }
//                }
//            }, onError: { owner, error in
//                print(error)
//            }, onCompleted: { owner in
//                print("onCompleted")
//            }, onDisposed: { owner in
//                print("disposed")
//            })
//            .disposed(by: disposeBag)
//
//            Observable.combineLatest(Observable.just(isSearchMode), nextCursor)
//                .withLatestFrom(input.textField, resultSelector: { firstValue, inputText in
//                    print(firstValue, inputText)
//                    let (searchMode, cursor) = firstValue
//                    return (searchMode, cursor, inputText)
//                })
//                .flatMap { (searchMode, cursor, inputText) in
//                    if searchMode && cursor != "" {
//                        let query = SearchQuery(next: cursor, limit: "15", product_id: "allBCake", hashTag: inputText)
//                        let result = PostNetworkManager.shared.searchWithHashTag(query: query)
//                        return result
//                    } else {
//                        return Single<Result<PostModel, NetworkError>>.never()
//                    }
//                }
//                .subscribe { result in
//                    switch result {
//                    case .success(let value):
//                        print("ddd")
//                        postList.onNext(value.data)
//                        
//                    case .failure(let error):
//                        print(error)
//                        if error == .expiredToken {
//                            isTokenVaild.onNext(false)
//                        }
//                    }
//                } onError: { error in
//                    print(error)
//                } onCompleted: {
//                    print("onCompleted")
//                } onDisposed: {
//                    print("onDisposed")
//                }
//                .disposed(by: disposeBag)
//        
//
//        input.cancelButtonTap
//            .subscribe(with: self) { owner, _ in
//                do {
//                    let currentIsMyPageValue = try owner.isMyPage.value()
//                    owner.isMyPage.onNext(currentIsMyPageValue)
//                } catch {
//                    print("Error getting value from isLikePage: \(error)")
//                }
//            }
//            .disposed(by: disposeBag)
//        
//
//        return Output(postList: postList, selectedModel: input.selectedModel, isTokenVaild: isTokenVaild, createButtonTap: input.createButtonTap, isMyPage: isMyPage)
//    }
//}
