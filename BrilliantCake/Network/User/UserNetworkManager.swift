//
//  UserNetworkManager.swift
//  BrilliantCake
//
//  Created by 박다현 on 8/20/24.
//

import Foundation
import Alamofire
import RxSwift
import Kingfisher

final class UserNetworkManager {
    
    static let shared = UserNetworkManager()
    let disposeBag = DisposeBag()
    private init() { }
    
    
    func createAccount(nickname: String, email: String, password: String, completion:@escaping () -> Void) {
        
        do {
            let query = SignUpQuery(email: email, password: password, nick: nickname)
            let request = try UserRouter.signUp(query: query).asURLRequest()
            
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
            
            let request = try UserRouter.login(query: query).asURLRequest()
            
            AF.request(request)
                .responseDecodable(of: LoginModel.self) { response in
                    
                    switch response.result {
                    case .success(let success):
                        UserDefaultsManager.token = success.access
                        UserDefaultsManager.refreshToken = success.refresh
                        UserDefaultsManager.userID = success.id
                        KingfisherManager.shared.setHeaders()
                        completion(success.nick)
                        
                    case .failure(let failure):
                        print("Fail", failure)
                    }
                }
        } catch {
            print(error)
        }
    }

    func fetchProfile() -> Single<Result<ProfileModel, NetworkError>> {
        return Single.create { observer -> Disposable in
            do {
                let request = try UserRouter.fetchProfile.asURLRequest()
                
                AF.request(request, interceptor: AuthInterceptor.shared)
                    .responseDecodable(of: ProfileModel.self) { response in
                        switch response.result {
                        case .success(let success):
                            observer(.success(.success(success)))
                            
                        case .failure(let error):
                            print(error)
                            observer(.success(.failure(.expiredToken)))
                        }
                    }
            } catch {
                print(error)
            }
            return Disposables.create()
        }
    }
    
    func editProfile() {
        
        do {
            let request = try UserRouter.editProfile.asURLRequest()
            
            AF.request(request)
                .responseDecodable(of: ProfileModel.self) { response in
                    
                    if response.response?.statusCode == 419 {
                        // self.refreshToken()
                    } else {
                        switch response.result {
                        case .success(let success):
                            print("OK", success)
                            
                            //self.fetchProfile()
                            
                        case .failure(let failure):
                            print("Fail", failure)
                        }
                    }
                }
            
        } catch {
            print(error)
        }
    }
    
    func refreshToken(handler: @escaping (Result<RefreshModel, NetworkError>) -> Void ) {
    
        do {
            let request = try UserRouter.refresh.asURLRequest()
            
            AF.request(request)
                .responseDecodable(of: RefreshModel.self) { response in
                    guard let statusCode = response.response?.statusCode else { return }
                    if statusCode == 418 {
                        handler(.failure(.expiredToken))
                        
                    } else {
                        switch response.result {
                        case .success(let success):
                            handler(.success(success))
                            
                        case .failure(let failure):
                            print(failure)
                            handler(.failure(.unknownError(statusCode: statusCode)))
                        }
                    }
                }
            
        } catch {
            print(error)
        }
    }
}

