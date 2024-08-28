//
//  PaymentViewModel.swift
//  BrilliantCake
//
//  Created by 박다현 on 8/28/24.
//

import Foundation
import RxSwift
import RxCocoa
import iamport_ios

final class PaymentViewModel: BaseViewModel {
    
    var productID: String = ""
    
    
    let disposeBag = DisposeBag()
    
    struct Input {
        let impResponse: BehaviorRelay<IamportResponse?>
    }
    
    struct Output {
        let validPayment: Observable<ValidationModel>
        let errorStatus: Observable<PaymentNetworkError>
    }
    
    func transform(input: Input) -> Output {
        let validPayment = PublishSubject<ValidationModel>()
        let errorStatus = PublishSubject<PaymentNetworkError>()
        
        input.impResponse
            .flatMap { [weak self] response in
                PaymentNetworkManager.shared.validation(impId: response?.imp_uid ?? "", postId: self?.productID ?? "")
            }
            .subscribe(onNext: { result in
                switch result {
                case .success(let value):
                    print(value)
                    validPayment.onNext(value)
                    
                case .failure(let error):
                    print(error)
                    errorStatus.onNext(error)
                }
            })
            .disposed(by: disposeBag)
        
        
        return Output(validPayment: validPayment, errorStatus: errorStatus)
    }
}
