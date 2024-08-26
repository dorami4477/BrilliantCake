//
//  SearchQuery.swift
//  BrilliantCake
//
//  Created by 박다현 on 8/19/24.
//

import Foundation

struct SearchQuery: Encodable {
    let next: String
    let limit: String
    let product_id: String
    let hashTag: String
}
