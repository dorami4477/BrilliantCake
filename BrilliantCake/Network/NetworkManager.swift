//
//  NetworkManager.swift
//  BrilliantCake
//
//  Created by 박다현 on 8/24/24.
//

import Foundation
import RxSwift
import Alamofire

enum NetworkError:Error, Equatable {
    case invaildURL
    case expiredToken
    case unknownError(statusCode: Int)
    case serverError
    case headerError
    case exceededRequest
    
    var statusCode: Int {
        switch self {
        case .invaildURL:
            return 444
        case .expiredToken:
            return 418
        case .unknownError(let statusCode):
            return statusCode
        case .serverError:
            return 500
        case .headerError:
            return 420
        case .exceededRequest:
            return 429
        }
    }   
}

enum NetworkManager {
    
    static func callRequest<Model: Decodable>(model: Model.Type, request: URLRequest, completion: @escaping (Result<Model, NetworkError>) -> Void) {
        
        AF.request(request, interceptor: AuthInterceptor.shared)
            .responseDecodable(of: model.self) { response in
                
                switch response.result {
                case .success(let success):
                    completion(.success(success))
                    
                case .failure:
                    
                    guard let response = response.response else { return }
      
                    switch response.statusCode {
                    case NetworkError.expiredToken.statusCode:
                        completion(.failure(.expiredToken))
                           
                    case NetworkError.headerError.statusCode:
                        completion(.failure(.headerError))
                        
                    case NetworkError.exceededRequest.statusCode:
                        completion(.failure(.exceededRequest))
                        
                    case NetworkError.invaildURL.statusCode:
                        completion(.failure(.invaildURL))
                        
                    case NetworkError.serverError.statusCode:
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
                    case NetworkError.expiredToken.statusCode:
                        completion(.failure(.expiredToken))
                           
                    case NetworkError.headerError.statusCode:
                        completion(.failure(.headerError))
                        
                    case NetworkError.exceededRequest.statusCode:
                        completion(.failure(.exceededRequest))
                        
                    case NetworkError.invaildURL.statusCode:
                        completion(.failure(.invaildURL))
                        
                    case NetworkError.serverError.statusCode:
                        completion(.failure(.serverError))
                        
                    default:
                        completion(.failure(.unknownError(statusCode: response.statusCode)))
                    }
                }
            }
    }
}
