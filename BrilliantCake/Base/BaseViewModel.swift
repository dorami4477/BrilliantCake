//
//  BaseViewModel.swift
//  BrilliantCake
//
//  Created by 박다현 on 8/16/24.
//

import Foundation

protocol BaseViewModel {
    associatedtype Input
    associatedtype Output
    
    func transform(input:Input) -> Output
}
