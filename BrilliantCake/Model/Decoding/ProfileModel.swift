//
//  ProfileModel.swift
//  BrilliantCake
//
//  Created by 박다현 on 8/14/24.
//

import Foundation

struct ProfileModel: Decodable {
    let id: String
    let email: String
    let nick: String
    let posts : [String]
    
    enum CodingKeys: String, CodingKey {
        case id = "user_id"
        case email
        case nick
        case posts
    }
}
