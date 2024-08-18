//
//  StoreViewModel.swift
//  BrilliantCake
//
//  Created by 박다현 on 8/18/24.
//

import Foundation
import RxSwift
import RxCocoa

final class StoreViewModel: BaseViewModel {
    let disposeBag = DisposeBag()
    
    struct Input {
        let storeId: Observable<String>
        let modelSelected: ControlEvent<PostData>
    }
    
    struct Output {
        let postList: Observable<[PostData]>
        let modelSelected: ControlEvent<PostData>
    }
    
    func transform(input: Input) -> Output {
        let postList = PublishSubject<[PostData]>()
        
        let fetchPostObservable = Single.just(("", "allBCake"))
            .flatMap { value in
                NetworkManager.shared.fetchPost(next: value.0, productId: value.1)
            }
            .asObservable()
        
        Observable.combineLatest(fetchPostObservable, input.storeId)
            .subscribe(onNext: { (postResult, storeId) in
                switch postResult {
                case .success(let result):
                    let filtered = result.data.filter { postData in
                        postData.content1 == storeId
                    }
                    postList.onNext(filtered)
                case .failure(let error):
                    print("postdata", error)
                }
            }, onError: { error in
                print(error)
            })
            .disposed(by: disposeBag)
        
        
        return Output(postList: postList, modelSelected: input.modelSelected)
        
    }
}
