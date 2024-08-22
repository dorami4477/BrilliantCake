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

class UserNetworkManager {
    
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
    
    func fetchProfile() {
        
        do {
            let request = try UserRouter.fetchProfile.asURLRequest()
            
            AF.request(request)
                .responseDecodable(of: ProfileModel.self) { response in
                    
                    if response.response?.statusCode == 419 {
                        // self.refreshToken()
                    } else {
                        switch response.result {
                        case .success(let success):
                            print("OK", success)
                            //self.profileView.emailLabel.text = success.email
                            //self.profileView.userNameLabel.text = success.nick
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
            let request = try UserRouter.editProfile.asURLRequest()
            
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
    
    func refreshToken(handler: @escaping (Result<RefreshModel, NetworkError>) -> Void ) {
    
        do {
            let request = try UserRouter.refresh.asURLRequest()
            
            AF.request(request)
                .responseDecodable(of: RefreshModel.self) { response in
                    
                    if response.response?.statusCode == 418 {
                        print("refreshToken expiration")
                        handler(.failure(.expiredToken))
                    } else {
                        switch response.result {
                        case .success(let success):
                            handler(.success(success))
                            
                        case .failure(let failure):
                            print(failure)
                            handler(.failure(.unknownRefreshTokenError))
                        }
                    }
                }
            
        } catch {
            print(error)
        }
    }
}

