//
//  SelectStoreTableViewCell.swift
//  BrilliantCake
//
//  Created by 박다현 on 8/24/24.
//

import UIKit
import SnapKit

final class SelectStoreTableViewCell: BaseTableViewCell {
    let nameLabel = {
        let label = UILabel()
        label.font = AppFont.size18Bold
        return label
    }()
    
    let detailsLabel = {
        let label = UILabel()
        label.font = AppFont.size14
        label.textColor = .gray
        label.numberOfLines = 0
        return label
    }()

    override func configureHierarchy() {
        contentView.addSubview(nameLabel)
        contentView.addSubview(detailsLabel)
    }
    
    override func configureLayout() {
        nameLabel.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview().inset(20)
        }
        
        detailsLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(4)
            make.horizontalEdges.equalToSuperview().inset(20)
        }
    }
    
}
