//
//  PaymentNetworkManager.swift
//  BrilliantCake
//
//  Created by 박다현 on 8/28/24.
//

import Foundation
import RxSwift

enum PaymentNetworkError:Error, Equatable {
    case invalid
    case unknownAccessToken
    case forbidden
    case alreadyDone
    case expiredToken
    case commonError(error: NetworkError)
}


final class PaymentNetworkManager {
    
    static let shared = PaymentNetworkManager()
    private init() {}
    
    func validation(impId:String, postId: String) -> Single<Result<ValidationModel, PaymentNetworkError>> {
       
        return Single.create { observer -> Disposable in
            do {
                let query = ValidationQuery(imp_uid: impId, post_id: postId)
                let request = try PaymentRouter.validation(query: query).asURLRequest()
               
                NetworkManager.callRequest(model: ValidationModel.self, request: request) { result in
                    switch result {
                    case .success(let value):
                        observer(.success(.success(value)))
                    case .failure(let error):
                        switch error {
                        case .unknownError(statusCode: 400):
                            observer(.success(.failure(.invalid)))
                            
                        case .unknownError(statusCode: 401):
                            observer(.success(.failure(.unknownAccessToken)))
                            
                        case .unknownError(statusCode: 403):
                            observer(.success(.failure(.forbidden)))
                            
                        case .unknownError(statusCode: 409):
                            observer(.success(.failure(.alreadyDone)))
                            
                        case .expiredToken :
                            observer(.success(.failure(.expiredToken)))
                            
                        default:
                            observer(.success(.failure(.commonError(error: error))))
                        }
                    }
                }
            } catch {
                print(error, "asURLRequest 실패")
            }
            return Disposables.create()
        }
    }
    
    
    func fetchList() -> Single<Result<PaymentList, PaymentNetworkError>> {
        return Single.create { observer -> Disposable in
            do {
                let request = try PaymentRouter.list.asURLRequest()
                
                NetworkManager.callRequest(model: PaymentList.self, request: request) { result in
                    switch result {
                    case .success(let value):
                        observer(.success(.success(value)))
                    case .failure(let error):
                        switch error {
                        case .unknownError(statusCode: 401):
                            observer(.success(.failure(.unknownAccessToken)))
                            
                        case .unknownError(statusCode: 403):
                            observer(.success(.failure(.forbidden)))
                            
                        case .expiredToken :
                            observer(.success(.failure(.expiredToken)))
                            
                        default:
                            observer(.success(.failure(.commonError(error: error))))
                        }
                    }
                }
            } catch {
                print(error, "asURLRequest 실패")
            }
            return Disposables.create()
        }
    }
}
