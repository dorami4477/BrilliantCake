//
//  LoginQuery.swift
//  BrilliantCake
//
//  Created by 박다현 on 8/14/24.
//

import Foundation

struct LoginQuery: Encodable {
    let email: String
    let password: String
}


struct SignUpQuery: Encodable {
    let email: String
    let password: String
    let nick: String
}
