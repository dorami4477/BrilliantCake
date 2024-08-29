//
//  PaymemtListViewModel.swift
//  BrilliantCake
//
//  Created by 박다현 on 8/28/24.
//

import Foundation
import RxSwift

final class PaymemtListViewModel {
    let disposeBag = DisposeBag()
    
    struct Input {
        
    }
    
    struct Output {
        let list: PublishSubject<[ValidationModel]>
        let isTokenVaild: BehaviorSubject<Bool>
    }
    
    func transform(input: Input) -> Output {
        let list = PublishSubject<[ValidationModel]>()
        let isTokenVaild = BehaviorSubject(value: true)
        
        Observable.just("")
            .flatMap { _ in
                PaymentNetworkManager.shared.fetchList()
            }
            .subscribe { result in
                switch result {
                case .success(let value):
                    list.onNext(value.data)
                    print(value.data)
                    
                case .failure(let error):
                    print(error)
                    if error == .expiredToken {
                        isTokenVaild.onNext(false)
                    }
                }
            }
            .disposed(by: disposeBag)
        
        return Output(list: list, isTokenVaild: isTokenVaild)
    }
}
