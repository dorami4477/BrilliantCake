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
    
    var storeID = PublishSubject<String>()
    var storeName = PublishSubject<String>()
    let imageData = PublishSubject<[Data]>()
    
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
            .withLatestFrom(imageData) { _, imageData in
                imageData
            }
            .flatMap { imageData in
                PostNetworkManager.shared.uploadImages(imageData: imageData)
            }
            .flatMap { uploadResult in
                Observable.combineLatest(input.titleText, input.contentText, self.storeID, self.storeName) { title, content, storeID, storeName in
                    (uploadResult, title, content, storeID, storeName)
                }
            }
            .flatMap { [weak self] (uploadResult, title, content, storeID, storeName) in
                guard let self else { return Single<Result<PostData, NetworkError>>.never() }
                
                switch uploadResult {
                case .success(let uploadedFiles):
                    return PostNetworkManager.shared.createPost(
                        title: title,
                        content: content,
                        content1: storeID,
                        content2: storeName,
                        productId: "allBCake",
                        files: uploadedFiles.files
                    )
                case .failure(let error):
                    print("이미지 업로드 실패: \(error)")
                    return Single.error(error)
                }
            }
            .subscribe(with: self) { owner, postCreateResult in
                switch postCreateResult {
                case .success(let uploadedFiles):
                    print(uploadedFiles)
                    postResult.onNext(uploadedFiles)
                    
                case .failure(let error):
                    print(error)
                }
            } onError: { owner, error in
                // 에러 처리
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
        let titleTextObservable = input.titleText.map { !$0.isEmpty }
        let contentTextObservable = input.contentText.map { !$0.isEmpty }
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
