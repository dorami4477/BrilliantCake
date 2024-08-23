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
    
    struct Input {
      //  let imageData: Observable<[Data]>
      //  let postData: Observable<CreatePostQuery>
        let pickerViewTap: ControlEvent<Void>
    }
    
    struct Output {
        let postResult: PublishSubject<PostData>
        let pickerViewTap: ControlEvent<Void>
    }
    
    func transform(input: Input) -> Output {
        let postResult = PublishSubject<PostData>()
        
//        input.imageData
//            .flatMap { imageData in
//                PostNetworkManager.shared.uploadImages(imageData: imageData)
//            }
//            .withLatestFrom(input.postData) { uploadedFiles, postData in
//                (uploadedFiles, postData)
//            }
//            .flatMap { (uploadResult, postData) in
//                print("uploadResult", uploadResult)
//                print("postData", postData)
//                
//                switch uploadResult {
//                case .success(let uploadedFiles):
//                    return PostNetworkManager.shared.createPost(
//                        title: postData.title,
//                        content: postData.content,
//                        content1: postData.content1,
//                        content2: postData.content2,
//                        productId: postData.product_id,
//                        files: uploadedFiles.files
//                    )
//                case .failure(let error):
//                    print("이미지 업로드 실패: \(error)")
//                    return Single.error(error) // 에러를 방출하여 스트림 종료
//                }
//            }
//            .subscribe(with: self) { owner, postCreateResult in
//                switch postCreateResult {
//                case .success(let uploadedFiles):
//                    print(uploadedFiles)
//                    postResult.onNext(uploadedFiles)
//                    
//                case .failure(let error):
//                    print(error)
//                }
//            } onError: { owner, error in
//                // 에러 처리
//                print("Error 발생: \(error)")
//            } onCompleted: { owner in
//                print("통신 완료")
//            } onDisposed: { owner in
//                print("구독 종료")
//            }
//            .disposed(by: disposeBag)
        
        return Output(postResult: postResult, pickerViewTap: input.pickerViewTap)
    }
}
