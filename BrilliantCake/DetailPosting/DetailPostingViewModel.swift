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
    let disposeBag = DisposeBag()
    var data:PostData?
    
    struct Input {
        let storeButtonTap: ControlEvent<Void>
        let textField: ControlProperty<String>
        let addCommentButtonTap: ControlEvent<Void>
    }
    
    struct Output {
        let postData: BehaviorSubject<PostData?>
        let imageData: PublishSubject<[Data]>
        let storeButtonTap: ControlEvent<Void>
        let newCommnet: PublishSubject<Comments>
    }
    
    func transform(input: Input) -> Output {
        let postData = BehaviorSubject(value: data)
        let imageData = PublishSubject<[Data]>()
        let newCommnet = PublishSubject<Comments>()
        
        postData
            .map { value in
                guard let value = value else { return [""] }
                return value.files.compactMap { $0 }
            }
            .flatMap { urls -> Single<[Result<Data, NetworkError>]> in
                let requests = urls.map { url -> Single<Result<Data, NetworkError>> in
                    NetworkManager.shared.fetchPostImage(url: url)
                }
                return Single.zip(requests) // 모든 요청을 병합
            }
            .subscribe(onNext: { results in
                let images = results.compactMap { result -> Data? in
                    if case .success(let data) = result {
                        return data
                    }
                    return nil
                }
                imageData.onNext(images)
                print("Fetched images: \(images)")
            }, onError: { error in
                print(error)
            }, onCompleted: {
                print("onCompleted")
            }, onDisposed: {
                print("onDisposed")
            })
            .disposed(by: disposeBag)
        //디스포즈가 실행되지 않음
            
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

        
        return Output(postData: postData, imageData: imageData, storeButtonTap: input.storeButtonTap, newCommnet: newCommnet)
    }
}
