//
//  CreatePostViewModel.swift
//  BrilliantCake
//
//  Created by 박다현 on 8/23/24.
//

import Foundation
import RxSwift
import RxCocoa

final class CreatePostViewModel: BaseViewModel {
    let disposeBag = DisposeBag()
    
    struct Input {
        
    }
    
    struct Output {
        
    }
    
    func transform(input: Input) -> Output {
        //먼저 이미지 -> 데이터로
        //PostNetworkManager.shared.uploadImages(image: UIImage(named: "BC_5")!) { value in
        //    print(value)
        //}
        Output()
    }
}
