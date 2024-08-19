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
    
    struct Input {
        let selectedModel: ControlEvent<PostData>
    }
    
    struct Output {
        let postList:Observable<[PostData]>
        let selectedModel: ControlEvent<PostData>
    }
    
    func transform(input: Input) -> Output {
        let postList = PublishSubject<[PostData]>()
        
        Single.just(("", "allBCake"))
            .flatMap{ value in
                NetworkManager.shared.fetchPost(next: value.0, productId: value.1)
            }
            .subscribe(with: self, onSuccess: { owner, value in
                switch value {
                case .success(let result):
                    postList.onNext(result.data)
                case .failure(let error):
                    print("postdata", error)
                }
            }, onFailure: { owner, error in
                print(error)
            }, onDisposed: { owner in
                print("disposed")
            })
            .disposed(by: disposeBag)
        
        
        return Output(postList: postList, selectedModel: input.selectedModel)
    }
}
