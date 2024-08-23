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
        
    }
    
    struct Output {
        let profileData: Observable<ProfileModel>
        let isTokenVaild: Observable<Bool>
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
            }, onFailure: { owner, error in
                print(error)
            }, onDisposed: { owner in
                print("disposed")
            })
            .disposed(by: disposeBag)
        
        return Output(profileData: profileData, isTokenVaild: isTokenVaild)
    }
}
