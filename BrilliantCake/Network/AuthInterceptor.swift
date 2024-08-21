//
//  AuthInterceptor.swift
//  BrilliantCake
//
//  Created by 박다현 on 8/20/24.
//

import Foundation
import Alamofire
import RxSwift

final class AuthInterceptor: RequestInterceptor {

    let disposeBag = DisposeBag()
    static let shared = AuthInterceptor()

    private init() {}

    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
        guard urlRequest.url?.absoluteString.hasPrefix(APIKey.BaseURL) == true else {
                          completion(.success(urlRequest))
                          return
                      }

        var urlRequest = urlRequest
        urlRequest.setValue(UserDefaultsManager.token, forHTTPHeaderField: Header.authorization.rawValue)
        urlRequest.setValue(Header.json.rawValue, forHTTPHeaderField: Header.contentType.rawValue)
        urlRequest.setValue(APIKey.key, forHTTPHeaderField: Header.sesacKey.rawValue)
        completion(.success(urlRequest))
    }

    func retry(_ request: Request, for session: Session, dueTo error: Error, completion: @escaping (RetryResult) -> Void) {
        print("retry 진입")
        guard let response = request.task?.response as? HTTPURLResponse, response.statusCode == 419
        else {
            completion(.doNotRetryWithError(error))
            return
        }

        // 토큰 갱신 API 호출
        if request.retryCount < 2 {
            UserNetworkManager.shared.refreshToken()
                .subscribe { result in
                    switch result {
                    case .success(let value):
                        print("Retry-토큰 재발급 성공: \(value)")
                        completion(.retry)
                    case .failure(let error):
                        print("리프레시토큰 만료?")
                        completion(.doNotRetryWithError(error))
                    }
                }
                .disposed(by: disposeBag)
        } else {
            completion(.doNotRetryWithError(error))
        }
    }
}
