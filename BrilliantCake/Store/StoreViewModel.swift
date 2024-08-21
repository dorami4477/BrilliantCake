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
        let mapButtonTap: ControlEvent<Void>
    }
    
    struct Output {
        let postList: Observable<[PostData]>
        let storeData: Observable<PostData>
        let modelSelected: ControlEvent<PostData>
        let isTokenVaild: Observable<Bool>
        let mapCoord: Observable<[Double]>
    }
    
    func transform(input: Input) -> Output {
        let postList = PublishSubject<[PostData]>()
        let storeData = PublishSubject<PostData>()
        let isTokenVaild = BehaviorSubject(value: true)
        let mapCoord = PublishSubject<[Double]>()
        
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
                    if error == .expiredToken {
                        isTokenVaild.onNext(false)
                    }
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
                    if error == .expiredToken {
                        isTokenVaild.onNext(false)
                    }
                }
            }, onError: { owner, error in
                print(error)
            }, onCompleted: { owner in
                print("onCompleted")
            }, onDisposed: { owner in
                print("onDisposed")
            })
            .disposed(by: disposeBag)
        
        input.mapButtonTap
            .withLatestFrom(storeData) { _, value in
                guard let value = value.content3 else { return "" }
                return value
            }
            .map { [weak self] csvString in
                guard let self else { return [1] }
                print(self.convertCSVStringToArray(csvString))
                return self.convertCSVStringToArray(csvString)
            }
            .subscribe(onNext: { array in
                mapCoord.onNext(array)
            })
            .disposed(by: disposeBag)
        
        return Output(postList: postList, 
                      storeData: storeData,
                      modelSelected: input.modelSelected,
                      isTokenVaild: isTokenVaild,
                      mapCoord: mapCoord)
        
    }
    
    
    func convertCSVStringToArray(_ csvString: String) -> [Double] {
            let components = csvString
                .trimmingCharacters(in: .whitespaces)
                .components(separatedBy: ",")
            
            // 각 문자열을 정수로 변환
            let array = components.compactMap { component -> Double? in
                return Double(component.trimmingCharacters(in: .whitespaces))
            }
            
            return array
        }
}
