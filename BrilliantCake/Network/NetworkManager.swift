//
//  NetworkManager.swift
//  BrilliantCake
//
//  Created by 박다현 on 8/14/24.
//

import Foundation
import Alamofire

struct NetworkManager {
    
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
    
    func fetchPost(next: String, productId: String, completion:@escaping (PostModel) -> Void) {
        do {
            let query = FetchPostQuery(next: next, limit: "10", product_id: productId)
            let request = try Router.fetchPost(query: query).asURLRequestWithQueryString()
            
            AF.request(request)
            .responseDecodable(of: PostModel.self) { response in
                
                if response.response?.statusCode == 419 {
                    self.refreshToken()
                } else {
                    switch response.result {
                    case .success(let success):
                        print("OK", success)
                        completion(success)
                    case .failure(let failure):
                        print("Fail", failure)
                        
                    }
                    
                }
                
            }
        } catch {
            print(error, "URLRequestConvertible 에서 asURLRequest 로 요청 만드는거 실패!!")
        }

    }
    
    func fetchProfile() {

        do {
            let request = try Router.fetchProfile.asURLRequest()
            
            AF.request(request)
            .responseDecodable(of: ProfileModel.self) { response in
                
                if response.response?.statusCode == 419 {
                    self.refreshToken()
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
                    self.refreshToken()
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
    
    func refreshToken() {

        do {
            let request = try Router.refresh.asURLRequest()

            AF.request(request)
            .responseDecodable(of: RefreshModel.self) { response in
                if response.response?.statusCode == 418 {
                    //리프레시 토큰 만료
                    //로그인으로 이동
                } else {
                    switch response.result {
                    case .success(let success):
                        print("OK", success)
                        
                        UserDefaultsManager.token = success.accessToken
                        //self.fetchProfile()
                        //self.fetchPost(next: "", productId: "testtest", completion: (PostModel) -> Void)
                        
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

