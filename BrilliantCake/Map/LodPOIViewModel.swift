//
//  LodPOIViewModel.swift
//  BrilliantCake
//
//  Created by 박다현 on 8/29/24.
//

import Foundation
import RxSwift

final class LodPOIViewModel: BaseViewModel {
    let disposeBag = DisposeBag()
    
    struct Input {
        
    }
    
    struct Output {
        let postList: Observable<[PostData]>
    }
    
    func transform(input: Input) -> Output {
        let postList = PublishSubject<[PostData]>()
        let isTokenVaild = BehaviorSubject(value: true)
        
    Observable.just("")
        .flatMapLatest { _ in
                PostNetworkManager.shared.fetchPost(next: "", limit: "15", productId: ProductId.allBCakeStore.rawValue)
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
        
        
        return Output(postList: postList)
    }
}
