//
//  BaseCollectionVIewCell.swift
//  BrilliantCake
//
//  Created by 박다현 on 8/14/24.
//

import UIKit

class BaseCollectionVIewCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureHierarchy()
        configureLayout()
        configureView()
    }
    
    func configureHierarchy() {}
    func configureLayout() {}
    func configureView() {}
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
