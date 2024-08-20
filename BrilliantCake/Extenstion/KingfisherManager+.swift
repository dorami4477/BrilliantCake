//
//  KingfisherManager.swift
//  BrilliantCake
//
//  Created by 박다현 on 8/20/24.
//

import Foundation
import Kingfisher

extension KingfisherManager {
    func setHeaders() {
        let imageDownloadRequest = AnyModifier { request in
            var requestBody = request
            requestBody.setValue(UserDefaultsManager.token, forHTTPHeaderField: Header.authorization.rawValue)
            requestBody.setValue(Header.json.rawValue, forHTTPHeaderField: Header.contentType.rawValue)
            requestBody.setValue(APIKey.key, forHTTPHeaderField: Header.sesacKey.rawValue)
            return requestBody
        }
        
        KingfisherManager.shared.defaultOptions = [
            .requestModifier(imageDownloadRequest)
        ]
    }
}
