//
//  LikedStoreListViewModel.swift
//  BrilliantCake
//
//  Created by 박다현 on 8/24/24.
//

import Foundation
import RxSwift
import RxCocoa

class LikedStoreListViewModel {
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
        
        Single.just(("", "allBCakeStore"))
            .flatMap{ value in
                PostNetworkManager.shared.fetchLikePost(next: value.0, limit: value.1)
            }
            .subscribe(with: self, onSuccess: { owner, value in
                switch value {
                case .success(let result):
                    postList.onNext(result.data)
                case .failure(let error):
                    print("postdata", error)
                    if error == .expiredToken {
                        isTokenVaild.onNext(false)
                    }
                }
            }, onFailure: { owner, error in
                print(error)
            }, onDisposed: { owner in
                print("disposed")
            })
            .disposed(by: disposeBag)
        
        return Output(postList: postList, modelSelected: input.modelSelected, isTokenVaild: isTokenVaild)
    }
}
