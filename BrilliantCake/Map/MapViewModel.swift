//
//  MapViewModel.swift
//  BrilliantCake
//
//  Created by 박다현 on 8/17/24.
//

import Foundation
import RxSwift
import RxCocoa

final class MapViewModel: BaseViewModel {
    let disposeBag = DisposeBag()
    
    struct Input {
        let currentLocationTap: ControlEvent<Void>
    }
    
    struct Output {
        let currentLocationTap: ControlEvent<Void>
    }
    
    func transform(input: Input) -> Output {
        Output(currentLocationTap: input.currentLocationTap)
    }
}
