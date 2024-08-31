//
//  PaymentRouter.swift
//  BrilliantCake
//
//  Created by 박다현 on 8/28/24.
//

import Foundation
import Alamofire

enum PaymentRouter {
    case validation(query: ValidationQuery)
    case list
}

extension PaymentRouter: TargetType {
    
    var method: Alamofire.HTTPMethod {
        switch self {
        case .validation:
            return .post
        case .list:
            return .get
        }
    }
    
    var parameters: String? {
        return nil
    }
    
    var queryItems: [URLQueryItem]? {
        return nil
    }
    
    var body: Data? {
        switch self {
        case .validation(let query):
            let encoder = JSONEncoder()
            
            do {
                let data = try encoder.encode(query)
                return data
                
            } catch {
                print(error)
                return nil
            }
            
        default: return nil
            
        }
    }
    
    var baseURL: String {
        return APIKey.BaseURL + "v1"
    }
    
    var path: String {
        switch self {
        case .validation:
            return "/payments/validation"
        case .list:
            return "/payments/me"
        }
    }
    
    var header: [String: String] {
        switch self {
        case .validation, .list:
            return [
                Header.authorization.rawValue: UserDefaultsManager.token,
                Header.sesacKey.rawValue: APIKey.key
            ]
        }
    }
    
}

