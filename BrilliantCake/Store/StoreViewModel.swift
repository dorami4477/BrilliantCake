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
    private let disposeBag = DisposeBag()
    
    struct Input {
        let storeId: Observable<String>
        let modelSelected: ControlEvent<PostData>
    }
    
    struct Output {
        let postList: Observable<[PostData]>
        let storeData: Observable<PostData>
        let modelSelected: ControlEvent<PostData>
    }
    
    func transform(input: Input) -> Output {
        let postList = PublishSubject<[PostData]>()
        let storeData = PublishSubject<PostData>()
        
        let fetchPostObservable = Single.just(("", "allBCake"))
            .flatMap { value in
                PostNetworkManager.shared.fetchPost(next: value.0, productId: value.1)
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
        
        
        input.storeId
            .flatMap{ value in
                PostNetworkManager.shared.fetchSpecificPost(id: value)
            }
            .subscribe(with: self, onNext: { owner, value in
                switch value {
                case .success(let result):
                    storeData.onNext(result)
                case .failure(let error):
                    print("storeData", error)
                }
            }, onError: { owner, error in
                print(error)
            }, onCompleted: { owner in
                print("onCompleted")
            }, onDisposed: { owner in
                print("onDisposed")
            })
            .disposed(by: disposeBag)
        
        
        return Output(postList: postList, storeData: storeData, modelSelected: input.modelSelected)
        
    }
}
