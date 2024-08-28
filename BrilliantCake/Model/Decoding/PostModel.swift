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

struct PostData: Decodable{
    let id: String
    let productId: String
    let title: String
    let content: String
    let content1: String
    let content2: String
    let content3: String?
    let content4: String?
    let price: Int?
    let createdAt: String
    let creator: Creator
    let files: [String]
    let likes: [String]?
    let likes2: [String]?
    let buyers: [String]?
    let hashTags: [String]?
    let comments: [Comments]?
    
    enum CodingKeys: String, CodingKey {
        case id = "post_id"
        case productId = "product_id"
        case title
        case content
        case content1
        case content2
        case content3
        case content4
        case price
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
    let profileImage: String?
}

struct Comments: Decodable {
    let comment_id: String
    let content: String
    let createdAt: String
    let creator: Creator
}
