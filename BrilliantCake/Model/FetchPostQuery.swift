//
//  FetchPostQuery.swift
//  BrilliantCake
//
//  Created by 박다현 on 8/16/24.
//

import Foundation

struct FetchPostQuery: Encodable {
    let next: String?
    let limit: String
    let product_id: String?
}
