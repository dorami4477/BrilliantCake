//
//  DetailPostingViewModel.swift
//  BrilliantCake
//
//  Created by 박다현 on 8/17/24.
//

import Foundation
import RxSwift
import RxCocoa

final class DetailPostingViewModel: BaseViewModel {
    
    private let disposeBag = DisposeBag()
    var data:PostData?
    
    struct Input {
        let storeButtonTap: ControlEvent<Void>
        let textField: ControlProperty<String>
        let addCommentButtonTap: ControlEvent<Void>
    }
    
    struct Output {
        let postData: BehaviorSubject<PostData?>
        let storeButtonTap: ControlEvent<Void>
        let newCommnet: PublishSubject<Comments>
    }
    
    func transform(input: Input) -> Output {
        let postData = BehaviorSubject(value: data)
        let newCommnet = PublishSubject<Comments>()
            
        input.addCommentButtonTap
            .debounce(.seconds(1), scheduler: MainScheduler.instance)
            .withLatestFrom(input.textField)
            .distinctUntilChanged()
            .flatMap { value in
                guard let data = self.data else { return Single<Result<Comments, NetworkError>>.never() }
                let result = NetworkManager.shared.addComment(id: data.id, comment: value)
                return result
            }
            .subscribe { result in
                switch result {
                case .success(let commnets):
                    newCommnet.onNext(commnets)
                    
                case .failure(let error):
                    print(error)
                }
            } onError: { error in
                print(error)
            } onCompleted: {
                print("onCompleted")
            } onDisposed: {
                print("onDisposed")
            }
            .disposed(by: disposeBag)

        
        return Output(postData: postData, storeButtonTap: input.storeButtonTap, newCommnet: newCommnet)
    }
}
