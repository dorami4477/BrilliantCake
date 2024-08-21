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
    
    struct Input {
        let selectedModel: ControlEvent<PostData>
        let textField: ControlProperty<String>
        let searchButtonTap: ControlEvent<Void>
        let cancelButtonTap: ControlEvent<Void>
    }
    
    struct Output {
        let postList:Observable<[PostData]>
        let selectedModel: ControlEvent<PostData>
        let isTokenVaild: Observable<Bool>
    }
    
    func transform(input: Input) -> Output {
        let postList = PublishSubject<[PostData]>()
        let isTokenVaild = BehaviorSubject(value: true)
        
        Single.just(("", "allBCake"))
            .flatMap{ value in
                PostNetworkManager.shared.fetchPost(next: value.0, productId: value.1)
            }
            .subscribe(with: self, onSuccess: { owner, value in
                switch value {
                case .success(let result):
                    owner.data = result.data
                    postList.onNext(owner.data)
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
        
        input.searchButtonTap
            .debounce(.seconds(1), scheduler: MainScheduler.instance)
            .withLatestFrom(input.textField)
            .distinctUntilChanged()
            .flatMap { value in
                let query = SearchQuery(next: "", limit: "10", product_id: "allBCake", hashTag: value)
                let result = PostNetworkManager.shared.searchWithHashTag(query: query)
                return result
            }
            .subscribe { result in
                switch result {
                case .success(let value):
                    postList.onNext(value.data)
                    
                case .failure(let error):
                    print(error)
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

        input.cancelButtonTap
            .subscribe(with: self) { owner, _ in
                postList.onNext(owner.data)
            }
            .disposed(by: disposeBag)
        
        return Output(postList: postList, selectedModel: input.selectedModel, isTokenVaild: isTokenVaild)
    }
}
