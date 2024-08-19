//
//  Router.swift
//  BrilliantCake
//
//  Created by 박다현 on 8/14/24.
//

import Foundation
import Alamofire

enum Router {
    case signUp(query: SignUpQuery)
    case login(query: LoginQuery)
    case fetchProfile
    case editProfile
    case refresh
    case fetchPost(query: FetchPostQuery)
    case fetchPostImage(path: String)
    case fetchSpecificPost(id: String)
    case addComment(id: String, query: CommentsQuery)
    case search(query: SearchQuery)
}

extension Router: TargetType {
    
    var method: Alamofire.HTTPMethod {
        switch self {
        case .signUp:
            return .post
        case .login:
            return .post
        case .fetchProfile:
            return .get
        case .editProfile:
            return .put
        case .refresh:
            return .get
        case .fetchPost:
            return .get
        case .fetchPostImage:
            return .get
        case .fetchSpecificPost(id: let id):
            return .get
        case .addComment:
            return .post
        case .search(query: let query):
            return .get
        }
    }
    
    var parameters: String? {
        return nil
    }
    
    var queryItems: [URLQueryItem]? {
        switch self {
        case .fetchPost(let query):
         return [
                URLQueryItem(name: "next", value: query.next),
                URLQueryItem(name: "limit", value: query.limit),
                URLQueryItem(name: "product_id", value: query.product_id)
            ]
        case .search(let query):
         return [
                URLQueryItem(name: "next", value: query.next),
                URLQueryItem(name: "limit", value: query.limit),
                URLQueryItem(name: "product_id", value: query.product_id),
                URLQueryItem(name: "hashTag", value: query.hashTag)
            ]
        default: return nil
        }
    }
    
    var body: Data? {
        switch self {
        case .signUp(let query):
            let encoder = JSONEncoder()
            
            do {
                let data = try encoder.encode(query)
                print("data \(data)")
                return data
            } catch {
                print(error)
                return nil
            }
        case .login(let query):
            let encoder = JSONEncoder()
            
            do {
                let data = try encoder.encode(query)
                print("data \(data)")
                return data
            } catch {
                print(error)
                return nil
            }
        case .fetchPost(let query):
            let encoder = JSONEncoder()
            
            do {
                let data = try encoder.encode(query)
                print("data \(data)")
                return data
            } catch {
                print(error)
                return nil
            }
        case .addComment(let id, let query):
            let encoder = JSONEncoder()
            
            do {
                let data = try encoder.encode(query)
                print("data \(data)")
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
        case .signUp:
            return "/users/join"
        case .login:
            return "/users/login"
        case .fetchProfile, .editProfile:
            return "/users/me/profile"
        case .refresh:
            return "/auth/refresh"
        case .fetchPost:
            return "/posts"
        case .fetchPostImage(path: let path):
            return "/\(path)"
        case .fetchSpecificPost(id: let id):
            return "/posts/\(id)"
        case .addComment(let id, let query):
            return "/posts/\(id)/comments"
        case .search(query: let query):
            return "/posts/hashtags"
        }
    }
    
    var header: [String: String] {
        switch self {
        case .signUp:
            return [
                 Header.contentType.rawValue: Header.json.rawValue,
                 Header.sesacKey.rawValue: APIKey.key
             ]
        case .login:
           return [
                Header.contentType.rawValue: Header.json.rawValue,
                Header.sesacKey.rawValue: APIKey.key
            ]
        case .fetchProfile:
            return [
                Header.authorization.rawValue: UserDefaultsManager.token,
                Header.contentType.rawValue: Header.json.rawValue,
                Header.sesacKey.rawValue: APIKey.key
            ]
        case .editProfile:
            return [
                Header.authorization.rawValue: UserDefaultsManager.token,
                Header.sesacKey.rawValue: APIKey.key
            ]
        case .refresh:
            return [
                Header.authorization.rawValue: UserDefaultsManager.token,
                Header.contentType.rawValue: Header.json.rawValue,
                Header.refresh.rawValue: UserDefaultsManager.refreshToken,
                Header.sesacKey.rawValue: APIKey.key
            ]
        case .fetchPost:
            return [
                Header.authorization.rawValue: UserDefaultsManager.token,
                Header.contentType.rawValue: Header.json.rawValue,
                Header.sesacKey.rawValue: APIKey.key
            ]
        case .fetchPostImage:
            return [
                Header.authorization.rawValue: UserDefaultsManager.token,
                Header.contentType.rawValue: Header.json.rawValue,
                Header.sesacKey.rawValue: APIKey.key
            ]
        case .fetchSpecificPost:
            return [
                Header.authorization.rawValue: UserDefaultsManager.token,
                Header.contentType.rawValue: Header.json.rawValue,
                Header.sesacKey.rawValue: APIKey.key
            ]
        case .addComment:
            return [
                Header.authorization.rawValue: UserDefaultsManager.token,
                Header.contentType.rawValue: Header.json.rawValue,
                Header.sesacKey.rawValue: APIKey.key
            ]
        case .search:
            return [
                Header.authorization.rawValue: UserDefaultsManager.token,
                Header.sesacKey.rawValue: APIKey.key
            ]
        }
    }
    
}
