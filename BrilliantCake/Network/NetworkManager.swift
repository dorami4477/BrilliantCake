//
//  NetworkManager.swift
//  BrilliantCake
//
//  Created by 박다현 on 8/24/24.
//

import Foundation
import RxSwift
import Alamofire

class NetworkManager {
    static func callRequest<Model: Codable>(model: Model.Type, request: URLRequest) -> Single<Result<Model, NetworkError>> {
        return Single.create { observer -> Disposable in
            AF.request(request, interceptor: AuthInterceptor.shared)
                .responseDecodable(of: model.self) { response in
                    
                    switch response.result {
                    case .success(let success):
                        observer(.success(.success(success)))
                        
                    case .failure(let error):
                        guard let response = response.response else { return }
                        switch response.statusCode {
                        case 418:
                            observer(.success(.failure(.expiredToken)))
                        case 420:
                            observer(.success(.failure(.headerError)))
                        case 429:
                            observer(.success(.failure(.exceededRequest)))
                        case 444:
                            observer(.success(.failure(.invaildURL)))
                        case 500:
                            observer(.success(.failure(.serverError)))
                        default:
                            observer(.success(.failure(.unknownError(statusCode: response.statusCode))))
                        }
                    }
                }
            return Disposables.create()
        }
    }

    
    static func callRequest2<Model: Codable>(model: Model.Type, request: URLRequest, completion: @escaping (Result<Model, NetworkError>) -> Void) {

            AF.request(request, interceptor: AuthInterceptor.shared)
                .responseDecodable(of: model.self) { response in
                    
                    switch response.result {
                    case .success(let success):
                        completion(.success(success))
                        
                    case .failure(let error):
                        print(error)
                        
                        guard let response = response.response else { return }
                        switch response.statusCode {
                        case 418:
                            completion(.failure(.expiredToken))

                        case 420:
                            completion(.failure(.headerError))

                        case 429:
                            completion(.failure(.exceededRequest))

                        case 444:
                            completion(.failure(.invaildURL))

                        case 500:
                            completion(.failure(.serverError))
 
                        default:
                            completion(.failure(.unknownError(statusCode: response.statusCode)))
                        }
                    }
                }
    }
}
