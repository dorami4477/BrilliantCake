//
//  ProfileViewModel.swift
//  BrilliantCake
//
//  Created by 박다현 on 8/23/24.
//

import Foundation
import RxSwift
import RxCocoa

final class ProfileViewModel: BaseViewModel {
    private let disposeBag = DisposeBag()
    
    struct Input {
        let itemSelected: ControlEvent<IndexPath>
    }
    
    struct Output {
        let profileData: Observable<ProfileModel>
        let isTokenVaild: Observable<Bool>
        let itemSelected: ControlEvent<IndexPath>
    }
    
    func transform(input: Input) -> Output {
        let profileData = PublishSubject<ProfileModel>()
        let isTokenVaild = BehaviorSubject(value: true)
        
        Single.just("")
            .flatMap { _ in
                UserNetworkManager.shared.fetchProfile()
            }
            .subscribe(with: self, onSuccess: { owner, value in
                switch value {
                case .success(let result):
                    profileData.onNext(result)
                    
                case .failure(let error):
                    print("profileData", error)
                    if error == .expiredToken {
                        isTokenVaild.onNext(false)
                    }
                }
            })
            .disposed(by: disposeBag)
        
        
        return Output(profileData: profileData, isTokenVaild: isTokenVaild, itemSelected: input.itemSelected)
    }
}
