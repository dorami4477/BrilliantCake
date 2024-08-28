//
//  ValidationModel.swift
//  BrilliantCake
//
//  Created by 박다현 on 8/28/24.
//

import Foundation


struct PaymentList: Decodable {
    let data: [ValidationModel]
}

struct ValidationModel: Decodable {
    let buyer_id: String
    let post_id: String
    let merchant_uid: String
    let productName: String
    let price: Int
    let paidAt: String
}
