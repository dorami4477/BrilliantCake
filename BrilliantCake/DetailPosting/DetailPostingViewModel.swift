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
    var isMyPage = BehaviorSubject(value: false)
    var data:PostData?
    
    struct Input {
        let storeButtonTap: ControlEvent<Void>
        let textField: ControlProperty<String>
        let addCommentButtonTap: ControlEvent<Void>
        let deleteButtonTap: PublishSubject<Void>
    }

    struct Output {
        let postData: BehaviorSubject<PostData?>
        let storeButtonTap: ControlEvent<Void>
        let newCommnet: PublishSubject<Comments>
        let isTokenVaild: Observable<Bool>
        let isMyPage: BehaviorSubject<Bool>
    }
    
    func transform(input: Input) -> Output {
        let postData = BehaviorSubject(value: data)
        let newCommnet = PublishSubject<Comments>()
        let isTokenVaild = BehaviorSubject(value: true)
            
        input.addCommentButtonTap
            .debounce(.seconds(1), scheduler: MainScheduler.instance)
            .withLatestFrom(input.textField)
            .distinctUntilChanged()
            .flatMap { value in
                guard let data = self.data else { return Single<Result<Comments, PostNetworkError>>.never() }
                let result = PostNetworkManager.shared.addComment(id: data.id, comment: value)
                return result
            }
            .subscribe { result in
                switch result {
                case .success(let commnets):
                    newCommnet.onNext(commnets)
                    
                case .failure(let error):
                    print(error)
                    if error == .expiredToken {
                        isTokenVaild.onNext(false)
                    }
                }
            }
            .disposed(by: disposeBag)
        
        input.deleteButtonTap
            .withLatestFrom(postData)
            .flatMapLatest { value in
                guard let value else { return Single<Result<(), PostNetworkError>>.never() }
                return PostNetworkManager.shared.deletePost(id:value.id)
            }
            .subscribe(with: self) { owner, result in
                switch result {
                case .success:
                    NotificationCenter.default.post(name: .delete, object: nil)
                    
                case .failure(let error):
                    if error == .expiredToken {
                        isTokenVaild.onNext(false)
                    }
                }
            }
            .disposed(by: disposeBag)
            

        
        return Output(postData: postData, storeButtonTap: input.storeButtonTap, newCommnet: newCommnet, isTokenVaild: isTokenVaild, isMyPage: isMyPage)
    }
}
