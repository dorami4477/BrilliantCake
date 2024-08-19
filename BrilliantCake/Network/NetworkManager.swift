//
//  NetworkManager.swift
//  BrilliantCake
//
//  Created by 박다현 on 8/14/24.
//

import Foundation
import Alamofire
import RxSwift

enum NetworkError:Error {
    case invaildURL
    case decodingError
    case invaildToken
}

class NetworkManager {
    
    static let shared = NetworkManager()
    private init() { }
    
    func createAccount(nickname: String, email: String, password: String, completion:@escaping () -> Void) {
        
        do {
            let query = SignUpQuery(email: email, password: password, nick: nickname)
            let request = try Router.signUp(query: query).asURLRequest()
            
            AF.request(request)
                .responseDecodable(of: SignUpModel.self) { response in
                    switch response.result {
                    case .success(let success):
                        print("OK", success)
                        completion()
                        
                    case .failure(let failure):
                        print("Fail", failure)
                    }
                }
        } catch {
            print(error)
        }
    }
    
    func createLogin(email: String, password: String, completion:@escaping (String) -> Void) {

        do {
            let query = LoginQuery(email: email, password: password)
            
            let request = try Router.login(query: query).asURLRequest()
            
            AF.request(request)
              .responseDecodable(of: LoginModel.self) { response in
                  
                switch response.result {
                case .success(let success):
                    
                     print("OK", success)
                    UserDefaultsManager.token = success.access
                    UserDefaultsManager.refreshToken = success.refresh
                    completion(success.nick)
                    
                case .failure(let failure):
                    print("Fail", failure)
                }
            }
        } catch {
            print(error)
        }
    }
    
    
    func fetchPost(next: String, productId: String) -> Single<Result<PostModel, NetworkError>> {
        return Single.create { observer -> Disposable in
            do {
                let query = FetchPostQuery(next: next, limit: "10", product_id: productId)
                let request = try Router.fetchPost(query: query).asURLRequestWithQueryString()
                
                AF.request(request)
                .responseDecodable(of: PostModel.self) { [weak self] response in
                    
                    switch response.result {
                    case .success(let value):
                        observer(.success(.success(value)))
                        
                    case .failure:
                        if response.response?.statusCode == 419 {
                            self?.refreshToken { [weak self] in
                                guard let self = self else { return }
                                _ = self.fetchPost(next: next, productId: productId)
                                    .subscribe(onSuccess: { result in
                                        observer(.success(result))
                                    }, onFailure: { error in
                                        observer(.failure(error))
                                    })
                            }
                        } else {
                            observer(.success(.failure(.decodingError)))
                        }
                    }
                }
            } catch {
                print(error, "URLRequestConvertible 에서 asURLRequest 로 요청 만드는거 실패!!")
            }
            return Disposables.create()
        }
    }
    
    func fetchPostImage(url: String) -> Single<Result<Data, NetworkError>> {
        return Single.create { observer -> Disposable in
            do {
                let request = try Router.fetchPostImage(path: url).asURLRequest()
                
                AF.request(request)
                    .responseString { [weak self] response in
                        
                        switch response.result {
                        case .success:
                            guard let imageData = response.data else { return }
                            observer(.success(.success(imageData)))
                            
                        case .failure:
                            if response.response?.statusCode == 419 {
                                self?.refreshToken { [weak self] in
                                    guard let self = self else { return }
                                    _ = self.fetchPostImage(url: url)
                                        .subscribe(onSuccess: { result in
                                            observer(.success(result))
                                        }, onFailure: { error in
                                            observer(.failure(error))
                                        })
                                }
                            } else {
                                observer(.success(.failure(.decodingError)))
                            }
                        }
                    }

            } catch {
                print(error, "URLRequestConvertible 에서 asURLRequest 로 요청 만드는거 실패!!")
            }
            return Disposables.create()
        }
    }
    
    func fetchSpecificPost(id: String) -> Single<Result<PostData, NetworkError>> {
        return Single.create { observer -> Disposable in
            do {
                let request = try Router.fetchSpecificPost(id: id).asURLRequestWithQueryString()
                
                AF.request(request)
                .responseDecodable(of: PostData.self) { [weak self] response in
                    
                    switch response.result {
                    case .success(let value):
                        observer(.success(.success(value)))
                        
                    case .failure:
                        if response.response?.statusCode == 419 {
                            self?.refreshToken { [weak self] in
                                guard let self = self else { return }
                                _ = self.fetchSpecificPost(id: id)
                                    .subscribe(onSuccess: { result in
                                        observer(.success(result))
                                    }, onFailure: { error in
                                        observer(.failure(error))
                                    })
                            }
                        } else {
                            observer(.success(.failure(.decodingError)))
                        }
                    }
                }
            } catch {
                print(error, "URLRequestConvertible 에서 asURLRequest 로 요청 만드는거 실패!!")
            }
            return Disposables.create()
        }
    }
    
    func addComment(id: String, comment: String) -> Single<Result<Comments, NetworkError>> {
        
        return Single.create { observer -> Disposable in
            do {
                let query = CommentsQuery(content: comment)
                let request = try Router.addComment(id: id, query: query).asURLRequest()
                
                AF.request(request)
                    .responseDecodable(of: Comments.self) { [weak self] response in
                        
                        switch response.result {
                        case .success(let value):
                            observer(.success(.success(value)))
                            
                        case .failure:
                            if response.response?.statusCode == 419 {
                                self?.refreshToken { [weak self] in
                                    guard let self = self else { return }
                                    _ = self.addComment(id: id, comment: comment)
                                        .subscribe(onSuccess: { result in
                                            observer(.success(result))
                                        }, onFailure: { error in
                                            observer(.failure(error))
                                        })
                                }
                            } else {
                                observer(.success(.failure(.decodingError)))
                            }
                        }
                    }
            } catch {
                print(error, "URLRequestConvertible 에서 asURLRequest 로 요청 만드는거 실패!!")
            }
            return Disposables.create()
        }
    }
    
    func fetchProfile() {

        do {
            let request = try Router.fetchProfile.asURLRequest()
            
            AF.request(request)
            .responseDecodable(of: ProfileModel.self) { response in
                
                if response.response?.statusCode == 419 {
                   // self.refreshToken()
                } else {
                    switch response.result {
                    case .success(let success):
                        print("OK", success)
//                        self.profileView.emailLabel.text = success.email
//                        self.profileView.userNameLabel.text = success.nick
                    case .failure(let failure):
                        print("Fail", failure)
                    }
                }
            }
        } catch {
            print(error, "URLRequestConvertible 에서 asURLRequest 로 요청 만드는거 실패!!")
        }

    }
    
    func editProfile() {
        
        do {
            let request = try Router.editProfile.asURLRequest()
            
            AF.request(request)
            .responseDecodable(of: ProfileModel.self) { response in
                
                if response.response?.statusCode == 419 {
                   // self.refreshToken()
                } else {
                    switch response.result {
                    case .success(let success):
                        print("OK", success)
                        
                        self.fetchProfile()
                        
                    case .failure(let failure):
                        print("Fail", failure)
                    }
                }
            }

        } catch {
            print(error)
        }
    }
    
    func refreshToken(handler:@escaping () -> Void) {

        do {
            let request = try Router.refresh.asURLRequest()

            AF.request(request)
            .responseDecodable(of: RefreshModel.self) { response in
                if response.response?.statusCode == 418 {
                    print("refreshToken expiration")
                    //리프레시 토큰 만료
                    //로그인으로 이동
                } else {
                    switch response.result {
                    case .success(let success):
                        UserDefaultsManager.token = success.accessToken
                        
                    case .failure(let failure):
                        print("Fail", failure)
                    }
                }
            }

        } catch {
            print(error)

        }
    }
}

