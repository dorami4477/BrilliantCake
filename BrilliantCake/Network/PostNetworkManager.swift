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
import UIKit

enum PostNetworkError:Error, Equatable {
    case invailRequest
    case notFoundPost
    case expiredToken
    case commonError(error: NetworkError)
}

final class PostNetworkManager {
    
    static let shared = PostNetworkManager()
    let disposeBag = DisposeBag()
    
    private init() { }
    
    func fetchPost(next: String, limit:String, productId: String) -> Single<Result<PostModel, PostNetworkError>> {
        return Single.create { observer -> Disposable in
            do {
                let query = FetchPostQuery(next: next, limit: limit, product_id: productId)
                let request = try PostRouter.fetchPost(query: query).asURLRequestWithQueryString()
                
                NetworkManager.callRequest(model: PostModel.self, request: request) { result in
                    switch result {
                    case .success(let value):
                        observer(.success(.success(value)))
                    case .failure(let error):
                        switch error {
                        case .unknownError(statusCode: 400),
                             .unknownError(statusCode: 401),
                             .unknownError(statusCode: 403):
                            observer(.success(.failure(.invailRequest)))
                            
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
    
    func fetchSpecificPost(id: String) -> Single<Result<PostData, PostNetworkError>> {
        return Single.create { observer -> Disposable in
            do {
                let request = try PostRouter.fetchSpecificPost(id: id).asURLRequestWithQueryString()
                
                NetworkManager.callRequest(model: PostData.self, request: request) { result in
                    switch result {
                    case .success(let value):
                        observer(.success(.success(value)))
                    case .failure(let error):
                        switch error {
                        case .unknownError(statusCode: 400),
                             .unknownError(statusCode: 401),
                             .unknownError(statusCode: 403):
                            observer(.success(.failure(.invailRequest)))
                            
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
    
    func addComment(id: String, comment: String) -> Single<Result<Comments, PostNetworkError>> {
        return Single.create { observer -> Disposable in
            do {
                let query = CommentsQuery(content: comment)
                let request = try PostRouter.addComment(id: id, query: query).asURLRequest()
                
                NetworkManager.callRequest(model: Comments.self, request: request) { result in
                    switch result {
                    case .success(let value):
                        observer(.success(.success(value)))
                    case .failure(let error):
                        switch error {
                        case .unknownError(statusCode: 400),
                             .unknownError(statusCode: 401),
                             .unknownError(statusCode: 403):
                            observer(.success(.failure(.invailRequest)))
                            
                        case .unknownError(statusCode: 410):
                            observer(.success(.failure(.notFoundPost)))
                            
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
    
    func searchWithHashTag(query: SearchQuery) -> Single<Result<PostModel, PostNetworkError>> {
        return Single.create { observer -> Disposable in
            do {
                let request = try PostRouter.search(query: query).asURLRequestWithQueryString()
                
                NetworkManager.callRequest(model: PostModel.self, request: request) { result in
                    switch result {
                    case .success(let value):
                        observer(.success(.success(value)))
                    case .failure(let error):
                        switch error {
                        case .unknownError(statusCode: 400),
                             .unknownError(statusCode: 401),
                             .unknownError(statusCode: 403):
                            observer(.success(.failure(.invailRequest)))
                            
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
    
    func likePost(id: String, like: Bool) -> Single<Result<LikeQuery, PostNetworkError>> {
        return Single.create { observer -> Disposable in
            do {
                let query = LikeQuery(like_status: like)
                let request = try PostRouter.like(id: id, query: query).asURLRequest()
                
                NetworkManager.callRequest(model: LikeQuery.self, request: request) { result in
                    switch result {
                    case .success(let value):
                        observer(.success(.success(value)))
                    case .failure(let error):
                        switch error {
                        case .unknownError(statusCode: 400),
                             .unknownError(statusCode: 401),
                             .unknownError(statusCode: 403):
                            observer(.success(.failure(.invailRequest)))
                            
                        case .unknownError(statusCode: 410):
                            observer(.success(.failure(.notFoundPost)))
                            
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
    
    func fetchLikePost(next: String, limit: String) -> Single<Result<PostModel, PostNetworkError>> {
        return Single.create { observer -> Disposable in
            do {
                let query = FetchPostQuery(next: next, limit: limit, product_id: nil)
                let request = try PostRouter.fetchlike(query: query).asURLRequestWithQueryString()
                
                NetworkManager.callRequest(model: PostModel.self, request: request) { result in
                    switch result {
                    case .success(let value):
                        observer(.success(.success(value)))
                    case .failure(let error):
                        switch error {
                        case .unknownError(statusCode: 400),
                             .unknownError(statusCode: 401),
                             .unknownError(statusCode: 403):
                            observer(.success(.failure(.invailRequest)))
                            
                        case .unknownError(statusCode: 410):
                            observer(.success(.failure(.notFoundPost)))
                            
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
    
    func uploadImages(imageData: [Data]) -> Single<Result<FilesModel, NetworkError>>{
        return Single.create { observer -> Disposable in
            
            let url = URL(string: PostRouter.uploadFiles.baseURL + PostRouter.uploadFiles.path)!
            
            let headers: HTTPHeaders = [
                Header.authorization.rawValue: UserDefaultsManager.token,
                Header.contentType.rawValue: Header.multipart.rawValue,
                Header.sesacKey.rawValue: APIKey.key
            ]
            
            AF.upload(multipartFormData: { MultipartFormData in
                imageData.forEach { image in
                    
                    MultipartFormData.append(image,
                                             withName: "files",
                                             fileName: "iamge.jpg",
                                             mimeType: "image/jpg")
                }
            }, to: url, method: .post, headers: headers)
            .validate()
            .responseDecodable(of: FilesModel.self) { reponse in
                switch reponse.result {
                case .success(let reuslt):
                    observer(.success(.success(reuslt)))
                    
                case .failure:
                    observer(.success(.failure(.expiredToken)))
                }
            }
            return Disposables.create()
        }
        
    }
    
    func createPost(title: String, content:String, content1:String, content2: String, productId:String, files:[String]) -> Single<Result<PostData, PostNetworkError>> {
        return Single.create { observer -> Disposable in
            do {
                let query = CreatePostQuery(title: title, content: content, content1: content1, content2: content2, product_id: productId, files: files)
                let request = try PostRouter.createPost(query: query).asURLRequest()
                
                NetworkManager.callRequest(model: PostData.self, request: request) { result in
                    switch result {
                    case .success(let value):
                        observer(.success(.success(value)))
                    case .failure(let error):
                        switch error {
                        case .unknownError(statusCode: 400),
                             .unknownError(statusCode: 401),
                             .unknownError(statusCode: 403):
                            observer(.success(.failure(.invailRequest)))
                        
                        case .unknownError(statusCode: 410):
                            observer(.success(.failure(.notFoundPost)))
                            
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
    
    func fetchUserPost(id:String, next: String) -> Single<Result<PostModel, PostNetworkError>> {
        return Single.create { observer -> Disposable in
            do {
                let query = FetchPostQuery(next: next, limit: "13", product_id: "allBCake")
                let request = try PostRouter.fetchUserPost(id: id, query: query).asURLRequestWithQueryString()
                
                NetworkManager.callRequest(model: PostModel.self, request: request) { result in
                    switch result {
                    case .success(let value):
                        observer(.success(.success(value)))
                    case .failure(let error):
                        switch error {
                        case .unknownError(statusCode: 400),
                             .unknownError(statusCode: 401),
                             .unknownError(statusCode: 403):
                            observer(.success(.failure(.invailRequest)))
                            
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
    
    func deletePost(id:String) -> Single<Result<Void, PostNetworkError>> {
        return Single.create { observer -> Disposable in
            do {
                let request = try PostRouter.deletePost(id: id).asURLRequest()
                NetworkManager.deleteRequest(request: request) { response in
                        switch response {
                        case .success:
                            observer(.success(.success(())))
                        case .failure(let error):
                            switch error {
                            case .unknownError(statusCode: 400),
                                 .unknownError(statusCode: 401),
                                 .unknownError(statusCode: 403):
                                observer(.success(.failure(.invailRequest)))
                                
                            case .unknownError(statusCode: 445) :
                                observer(.success(.failure(.notFoundPost)))
                                
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
