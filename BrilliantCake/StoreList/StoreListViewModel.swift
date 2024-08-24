//
//  StoreListViewModel.swift
//  BrilliantCake
//
//  Created by 박다현 on 8/19/24.
//

import Foundation
import RxSwift
import RxCocoa

final class StoreListViewModel: BaseViewModel {
    
    var isLikePage = BehaviorSubject(value: false)
    private let disposeBag = DisposeBag()
    
    struct Input {
        let modelSelected: ControlEvent<PostData>
    }
    
    struct Output {
        let postList: PublishSubject<[PostData]>
        let modelSelected: ControlEvent<PostData>
        let isTokenVaild: Observable<Bool>
    }
    
    func transform(input: Input) -> Output {
        let postList = PublishSubject<[PostData]>()
        let isTokenVaild = BehaviorSubject(value: true)
        
        isLikePage
            .flatMapLatest { isLikePageValue -> Single<Result<PostModel, PostNetworkError>> in
                if isLikePageValue {
                    return PostNetworkManager.shared.fetchLikePost(next: "", limit: "10")
                } else {
                    return PostNetworkManager.shared.fetchPost(next: "", productId: "allBCakeStore")
                }
            }
            .subscribe { value in
                switch value {
                case .success(let result):
                    postList.onNext(result.data)
                case .failure(let error):
                    print("postdata", error)
                    if error == .expiredToken {
                        isTokenVaild.onNext(false)
                    }
                }
            } onError: { error in
                print(error)
            } onCompleted: {
                print("onCompleted")
            } onDisposed: {
                print("onDisposed")
            }
            .disposed(by: disposeBag)


//            Single.just(("", "allBCakeStore"))
//                .flatMap{ value in
//                    PostNetworkManager.shared.fetchPost(next: value.0, productId: value.1)
//                }
//                .subscribe(with: self, onSuccess: { owner, value in
//                    switch value {
//                    case .success(let result):
//                        postList.onNext(result.data)
//                    case .failure(let error):
//                        print("postdata", error)
//                        if error == .expiredToken {
//                            isTokenVaild.onNext(false)
//                        }
//                    }
//                }, onFailure: { owner, error in
//                    print(error)
//                }, onDisposed: { owner in
//                    print("disposed")
//                })
//                .disposed(by: disposeBag)

        
        return Output(postList: postList, modelSelected: input.modelSelected, isTokenVaild: isTokenVaild)
    }
}
