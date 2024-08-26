//
//  SectionOfBasicData.swift
//  BrilliantCake
//
//  Created by 박다현 on 8/26/24.
//

import Foundation
import RxDataSources

struct SectionOfBasicData<Item> {
    var header: String
    var items: [Item]
}

extension SectionOfBasicData: SectionModelType {
    init(original: SectionOfBasicData<Item>, items: [Item]) {
        self = original
        self.items = items
    }
}
