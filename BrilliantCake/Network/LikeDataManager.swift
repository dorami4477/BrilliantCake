//
//  LikeDataManager.swift
//  BrilliantCake
//
//  Created by 박다현 on 8/25/24.
//

import Foundation

class LikeDataManager {
    static let shared = LikeDataManager()
    
    private init() {}
    
    private(set) var changedValue: Bool?
    
    func setData(_ data: Bool?) {
        self.changedValue = data
    }
    
    func getData() -> Bool? {
        return changedValue
    }
}
