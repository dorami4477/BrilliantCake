//
//  BrowseCollectionViewCell.swift
//  BrilliantCake
//
//  Created by 박다현 on 8/15/24.
//

import UIKit
import SnapKit

final class BrowseCollectionViewCell: BaseCollectionVIewCell {
    let mainImageView = {
       let image = UIImageView()
        image.contentMode = .scaleAspectFill
        return image
    }()
    
    override func configureHierarchy() {
        addSubview(mainImageView)
    }
    
    override func configureLayout() {
        mainImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
