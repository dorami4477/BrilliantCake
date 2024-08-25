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
    
    static func callRequest<Model: Decodable>(model: Model.Type, request: URLRequest, completion: @escaping (Result<Model, NetworkError>) -> Void) {
        
        AF.request(request, interceptor: AuthInterceptor.shared)
            .responseDecodable(of: model.self) { response in
                
                switch response.result {
                case .success(let success):
                    completion(.success(success))
                    
                case .failure:
                    
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
    
    static func deleteRequest(request: URLRequest, completion: @escaping (Result<Void, NetworkError>) -> Void) {
        
        AF.request(request, interceptor: AuthInterceptor.shared)
            .response { response in
                
                switch response.result {
                case .success:
                    completion(.success(()))
                    
                case .failure:
                    
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
