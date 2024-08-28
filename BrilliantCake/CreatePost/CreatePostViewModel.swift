//
//  CreatePostViewModel.swift
//  BrilliantCake
//
//  Created by 박다현 on 8/23/24.
//

import Foundation
import RxSwift
import RxCocoa

final class CreatePostViewModel: BaseViewModel {
    let disposeBag = DisposeBag()
    deinit{
        print(self)
    }
    var storeID = BehaviorSubject(value: "")
    var storeName = BehaviorSubject(value: "")
    let imageData = PublishSubject<[Data]>()
    let createdNewPost = PublishSubject<Bool>()
    
    struct Input {
        let titleText: ControlProperty<String>
        let contentText: ControlProperty<String>
        let storeButtonTap: ControlEvent<Void>
        let pickerViewTap: ControlEvent<Void>
        let submitButtonTap: ControlEvent<Void>
    }   
    
    struct Output {
        let postResult: PublishSubject<PostData>
        let pickerViewTap: ControlEvent<Void>
        let storeButtonTap: ControlEvent<Void>
        let submitButtonActive: BehaviorSubject<Bool>
    }
    
    func transform(input: Input) -> Output {
        let postResult = PublishSubject<PostData>()
        
        input.submitButtonTap
            .throttle(.milliseconds(500), scheduler: MainScheduler.instance)
            .withLatestFrom(imageData)
            .flatMap { imageData in
                PostNetworkManager.shared.uploadImages(imageData: imageData)
            }
            .withUnretained(self)
            .flatMap {  owner, uploadResult in
                Observable.combineLatest(input.titleText.distinctUntilChanged(),
                                         input.contentText.distinctUntilChanged(),
                                         owner.storeID.distinctUntilChanged(),
                                         owner.storeName.distinctUntilChanged())
                    { title, content, storeID, storeName in
                        return (uploadResult, title, content, storeID, storeName)
                    }
            }
            .flatMapLatest { (uploadResult, title, content, storeID, storeName) in
                switch uploadResult {
                case .success(let uploadedFiles):
                    return PostNetworkManager.shared.createPost(
                        title: title,
                        content: content,
                        content1: storeID,
                        content2: storeName,
                        productId: ProductId.allBCake.rawValue,
                        files: uploadedFiles.files
                    )
                case .failure(let error):
                    print("이미지 업로드 실패: \(error)")
                    return Single.error(error)
                }
            }
            .subscribe(with: self) { owner, postCreateResult in
                switch postCreateResult {
                case .success(let postData):
                    owner.createdNewPost.onNext(false)
                    postResult.onNext(postData)
                    
                case .failure(let error):
                    print(error)
                }
            } onError: { owner, error in
                print("Error 발생: \(error)")
            } onCompleted: { owner in
                print("통신 완료")
            } onDisposed: { owner in
                print("구독 종료")
            }
            .disposed(by: disposeBag)
        
        
        let submitButtonActive = BehaviorSubject<Bool>(value: false)
        let storeIDObservable = storeID.map { !$0.isEmpty }
        let storeNameObservable = storeName.map { !$0.isEmpty }
        let titleTextObservable = input.titleText.map { !$0.trimmingCharacters(in: .whitespaces).isEmpty }
        let contentTextObservable = input.contentText.map { !$0.trimmingCharacters(in: .whitespaces).isEmpty }
        let imageDataObservable = imageData.map { !$0.isEmpty }
        
        Observable.combineLatest(
            storeIDObservable,
            storeNameObservable,
            titleTextObservable,
            contentTextObservable,
            imageDataObservable
        )
        .map { storeIDValid, storeNameValid, titleValid, contentValid, imageValid in
            return storeIDValid && storeNameValid && titleValid && contentValid && imageValid
        }
        .bind(to: submitButtonActive)
        .disposed(by: disposeBag)
        
        return Output(postResult: postResult, 
                      pickerViewTap: input.pickerViewTap,
                      storeButtonTap: input.storeButtonTap,
                      submitButtonActive: submitButtonActive)
    }
}
