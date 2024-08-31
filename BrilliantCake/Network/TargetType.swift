//
//  TargetType.swift
//  BrilliantCake
//
//  Created by 박다현 on 8/14/24.
//

import Foundation
import Alamofire

protocol TargetType: URLRequestConvertible {
    var baseURL: String { get }
    var method: HTTPMethod { get }
    var path: String { get }
    var header: [String: String] { get }
    var parameters: String? { get }
    var queryItems: [URLQueryItem]? { get }
    var body: Data? { get }
}

extension TargetType {
    
    func asURLRequest() throws -> URLRequest {
        let url = try baseURL.asURL()
        var request = try URLRequest(url: url.appendingPathComponent(path), method: method)
        request.allHTTPHeaderFields = header
        request.httpBody = body
        
        return request
    }
    

    func asURLRequestWithQueryString() throws -> URLRequest {
        let url = try baseURL.asURL()
        var urlComponents = URLComponents(url: url.appendingPathComponent(path), resolvingAgainstBaseURL: false)
        urlComponents?.queryItems = queryItems
        
        guard let finalURL = urlComponents?.url else {
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url: finalURL)
        request.httpMethod = method.rawValue
        request.allHTTPHeaderFields = header
        
        return request
    }
}


