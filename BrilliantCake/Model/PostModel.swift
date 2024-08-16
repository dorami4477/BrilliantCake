//
//  PostModel.swift
//  BrilliantCake
//
//  Created by 박다현 on 8/15/24.
//

import Foundation

struct PostModel: Decodable {
    let data: [PostData]
    let next_cursor: String
}

struct PostData: Decodable, Hashable{
    static func == (lhs: PostData, rhs: PostData) -> Bool {
        lhs.id == rhs.id
    }
    
    public func hash(into hasher: inout Hasher) {
        return hasher.combine(id)
    }
    
    let id: String
    let title: String
    let content: String
    let createdAt: String
    let creator: Creator
    let files: [String]
    let likes: [String]?
    let likes2: [String]?
    let buyers: [String]?
    let hashTags: [String]?
    let comments: [String]?
    
    enum CodingKeys: String, CodingKey {
        case id = "post_id"
        case title
        case content
        case createdAt
        case creator
        case files
        case likes
        case likes2
        case buyers
        case hashTags
        case comments
    }
}

struct Creator: Decodable {
    let user_id: String
    let nick: String
}
