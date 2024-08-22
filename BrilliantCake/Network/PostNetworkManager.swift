//
//  PostNetworkManager.swift
//  BrilliantCake
//
//  Created by 박다현 on 8/14/24.
//

import Foundation
import Alamofire
import RxSwift
import Kingfisher

enum NetworkError:Error {
    case invaildURL
    case decodingError
    case expiredToken
    case unknownRefreshTokenError
}

class PostNetworkManager {
    
    static let shared = PostNetworkManager()
    let disposeBag = DisposeBag()
    
    private init() { }
    
    func fetchPost(next: String, productId: String) -> Single<Result<PostModel, NetworkError>>  {
            return Single.create { observer -> Disposable in
                do {
                    let query = FetchPostQuery(next: next, limit: "10", product_id: productId)
                    let request = try PostRouter.fetchPost(query: query).asURLRequestWithQueryString()
                    
                    AF.request(request, interceptor: AuthInterceptor.shared)
                        .responseDecodable(of: PostModel.self) { response in
                            switch response.result {
                            case .success(let success):
                                print("게시물호출")
                                observer(.success(.success(success)))
                            case .failure(let error):
                                print(error)
                                observer(.success(.failure(.expiredToken)))
                            }
                        }
                } catch {
                    print(error, "URLRequestConvertible 에서 asURLRequest 로 요청 만드는거 실패")
                }
                return Disposables.create()
            }
        }
    
    func fetchSpecificPost(id: String) -> Single<Result<PostData, NetworkError>> {

        return Single.create { observer -> Disposable in
            do {
                let request = try PostRouter.fetchSpecificPost(id: id).asURLRequestWithQueryString()
                
                AF.request(request, interceptor: AuthInterceptor.shared)
                    .responseDecodable(of: PostData.self) { response in
                        switch response.result {
                        case .success(let success):
                            observer(.success(.success(success)))
                        case .failure(let error):
                            print(error)
                            observer(.success(.failure(.expiredToken)))
                        }
                    }
            } catch {
                print(error, "URLRequestConvertible 에서 asURLRequest 로 요청 만드는거 실패")
            }
            return Disposables.create()
        }
    }
    
    func addComment(id: String, comment: String) -> Single<Result<Comments, NetworkError>> {
        
        return Single.create { observer -> Disposable in
            do {
                let query = CommentsQuery(content: comment)
                let request = try PostRouter.addComment(id: id, query: query).asURLRequest()
                
                AF.request(request, interceptor: AuthInterceptor.shared)
                    .responseDecodable(of: Comments.self) { response in
                        switch response.result {
                        case .success(let success):
                            observer(.success(.success(success)))
                        case .failure(let error):
                            print(error)
                            observer(.success(.failure(.expiredToken)))
                        }
                    }
            } catch {
                print(error, "URLRequestConvertible 에서 asURLRequest 로 요청 만드는거 실패")
            }
            return Disposables.create()
        }

    }
    
    func searchWithHashTag(query: SearchQuery) -> Single<Result<PostModel, NetworkError>> {
        return Single.create { observer -> Disposable in
            do {
                let request = try PostRouter.search(query: query).asURLRequestWithQueryString()
                
                AF.request(request, interceptor: AuthInterceptor.shared)
                    .responseDecodable(of: PostModel.self) { response in
                        switch response.result {
                        case .success(let success):
                            observer(.success(.success(success)))
                        case .failure(let error):
                            print(error)
                            observer(.success(.failure(.expiredToken)))
                        }
                    }
            } catch {
                print(error, "URLRequestConvertible 에서 asURLRequest 로 요청 만드는거 실패")
            }
            return Disposables.create()
        }
    }
    
    func likePost(id: String, like: Bool) -> Single<Result<LikeQuery, NetworkError>> {
        return Single.create { observer -> Disposable in
            do {
                let query = LikeQuery(like_status: like)
                let request = try PostRouter.like(id: id, query: query).asURLRequest()
                
                AF.request(request, interceptor: AuthInterceptor.shared)
                    .responseDecodable(of: LikeQuery.self) { response in
                        switch response.result {
                        case .success(let success):
                            observer(.success(.success(success)))
                        case .failure(let error):
                            print(error)
                            observer(.success(.failure(.expiredToken)))
                        }
                    }
            } catch {
                print(error, "URLRequestConvertible 에서 asURLRequest 로 요청 만드는거 실패")
            }
            return Disposables.create()
        }
    }
    
}
