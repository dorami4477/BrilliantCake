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
    var isLikeButtonTap = BehaviorSubject(value: LikeDataManager.shared.getData())
    
    struct Input {
        let modelSelected: ControlEvent<PostData>
        let likeButtonTapped: PublishSubject<(String, Bool)>
    }
    
    struct Output {
        let postList: PublishSubject<[PostData]>
        let modelSelected: ControlEvent<PostData>
        let isTokenVaild: Observable<Bool>
        let isLikePage: BehaviorSubject<Bool>
    }
    
    func transform(input: Input) -> Output {
        let postList = PublishSubject<[PostData]>()
        let isTokenVaild = BehaviorSubject(value: true)
        
        Observable.combineLatest(isLikePage, isLikeButtonTap)
            .flatMapLatest { isLikePageValue -> Single<Result<PostModel, PostNetworkError>> in
                if isLikePageValue.0 {
                    return PostNetworkManager.shared.fetchLikePost(next: "", limit: "10")
                    
                } else {
                    return PostNetworkManager.shared.fetchPost(next: "", limit: "15", productId: ProductId.allBCakeStore.rawValue)
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
            }
            .disposed(by: disposeBag)
        
        input.likeButtonTapped
            .flatMap{ value in
                PostNetworkManager.shared.likePost(id: value.0, like: value.1)
            }
            .subscribe(with: self, onNext: { owner, value in
                switch value {
                case .success:
                    LikeDataManager.shared.setData(true)
                    owner.isLikeButtonTap.onNext(LikeDataManager.shared.getData())
                    
                case .failure(let error):
                    print("likeData", error)
                    if error == .expiredToken {
                        isTokenVaild.onNext(false)
                    }
                }
            })
            .disposed(by: disposeBag)
        
        
        return Output(postList: postList, modelSelected: input.modelSelected, isTokenVaild: isTokenVaild, isLikePage: isLikePage)
    }
}
