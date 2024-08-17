//
//  DetailPostingCVCell.swift
//  BrilliantCake
//
//  Created by 박다현 on 8/17/24.
//

import UIKit

final class DetailPostingCVCell: BaseCollectionVIewCell {
    let mainImageView = UIImageView()
    
    override func configureHierarchy() {
        contentView.addSubview(mainImageView)
    }
    
    override func configureLayout() {
        mainImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
