//
//  DetailPostingView.swift
//  BrilliantCake
//
//  Created by 박다현 on 8/17/24.
//

import UIKit

final class DetailPostingView: BaseView {
    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
    let nickNameLebal = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .bold)
        return label
    }()
    
    let image1 = {
        let image = UIImageView()
        return image
    }()
    
    func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: screenSize().width, height: screenSize().width)
        return layout
    }
    
    override func configureHierarchy() {
        addSubview(collectionView)
        collectionView.backgroundColor = .gray
    }
    
    override func configureLayout() {
        collectionView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview()
            make.height.equalTo(300)
        }
    }
}
