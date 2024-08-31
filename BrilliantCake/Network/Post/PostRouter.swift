//
//  PostRouter.swift
//  BrilliantCake
//
//  Created by 박다현 on 8/20/24.
//

import Foundation
import Alamofire

enum PostRouter {
    case fetchPost(query: FetchPostQuery)
    case fetchPostImage(path: String)
    case fetchSpecificPost(id: String)
    case addComment(id: String, query: CommentsQuery)
    case search(query: SearchQuery)
    case like(id: String, query: LikeQuery)
    case uploadFiles
    case createPost(query: CreatePostQuery)
    case fetchlike(query: FetchPostQuery)
    case fetchUserPost(id: String, query: FetchPostQuery)
    case deletePost(id: String)
}

extension PostRouter: TargetType {
    
    var method: Alamofire.HTTPMethod {
        switch self {
        case .fetchPost:
            return .get
        case .fetchPostImage:
            return .get
        case .fetchSpecificPost:
            return .get
        case .addComment:
            return .post
        case .search:
            return .get
        case .like:
            return .post
        case .uploadFiles:
            return .post
        case .createPost:
            return .post
        case .fetchlike:
            return .get
        case .fetchUserPost:
            return .get
        case .deletePost:
            return .delete
        }
        
        
    }
    
    var parameters: String? {
        return nil
    }
    
    var queryItems: [URLQueryItem]? {
        switch self {
        case .fetchPost(let query), .fetchlike(let query), .fetchUserPost(_, let query):
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
        case .addComment(_, let query):
            let encoder = JSONEncoder()
            
            do {
                let data = try encoder.encode(query)
                print("data \(data)")
                return data
            } catch {
                print(error)
                return nil
            }
        case .like(_, let query):
            let encoder = JSONEncoder()
            
            do {
                let data = try encoder.encode(query)
                print("data \(data)")
                return data
            } catch {
                print(error)
                return nil
            }
        case .createPost(let query):
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
        case .fetchPost:
            return "/posts"
        case .fetchPostImage(path: let path):
            return "/\(path)"
        case .fetchSpecificPost(id: let id):
            return "/posts/\(id)"
        case .addComment(let id, _):
            return "/posts/\(id)/comments"
        case .search:
            return "/posts/hashtags"
        case .like(let id, _):
            return "/posts/\(id)/like"
        case .uploadFiles:
            return "/posts/files"
        case .createPost:
            return "/posts"
        case .fetchlike:
            return "/posts/likes/me"
        case .fetchUserPost(let id, _):
            return "/posts/users/\(id)"
        case .deletePost(let id):
            return "posts/\(id)"
        }
    }
    
    var header: [String: String] {
        switch self {
        case .fetchPost, .fetchPostImage, .fetchSpecificPost, .addComment, .like, .createPost:
            return [
                Header.authorization.rawValue: UserDefaultsManager.token,
                Header.contentType.rawValue: Header.json.rawValue,
                Header.sesacKey.rawValue: APIKey.key
            ]
        case .search, .fetchlike, .fetchUserPost, .deletePost:
            return [
                Header.authorization.rawValue: UserDefaultsManager.token,
                Header.sesacKey.rawValue: APIKey.key
            ]
        case .uploadFiles:
            return [
                Header.authorization.rawValue: UserDefaultsManager.token,
                Header.contentType.rawValue: Header.multipart.rawValue,
                Header.sesacKey.rawValue: APIKey.key
            ]
        }
    }
    
}

