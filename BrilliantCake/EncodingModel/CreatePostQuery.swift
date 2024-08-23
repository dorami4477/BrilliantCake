//
//  CreatePostQuery.swift
//  BrilliantCake
//
//  Created by 박다현 on 8/23/24.
//

import Foundation

struct CreatePostQuery: Encodable {
    let title: String
    let content: String
    let content1: String
    let content2: String
    let product_id: String
    let files: [String]
}
