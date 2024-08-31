//
//  StoreMapInfoView.swift
//  BrilliantCake
//
//  Created by 박다현 on 8/21/24.
//

import UIKit
import SnapKit

final class StoreMapInfoView: BaseView {
    
    private let iconView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: ImageName.button)
        imageView.tintColor = .black
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = AppFont.size22Bold
        label.textColor = .black
        return label
    }()
    
    private let addressLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = AppFont.size14
        label.numberOfLines = 0
        label.textColor = .darkGray
        return label
    }()
    
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 10
        view.layer.borderColor = UIColor.black.cgColor
        view.layer.borderWidth = 5
        view.clipsToBounds = true
        return view
    }()
    
    private let titleView: UIView = {
        let view = UIView()
        view.backgroundColor = .main
        return view
    }()
    
    init(frame: CGRect, title: String, address: String) {
        super.init(frame: frame)

        titleLabel.text = title
        addressLabel.text = address
    }
    
    
    override func configureHierarchy() {
        addSubview(containerView)
        containerView.addSubview(titleView)
        containerView.addSubview(addressLabel)
        titleView.addSubview(iconView)
        titleView.addSubview(titleLabel)
    }
    
    override func configureLayout() {
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(10)
        }
        
        titleView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview()
            make.height.equalToSuperview().dividedBy(2)
        }
        
        iconView.snp.makeConstraints { make in
            make.centerY.equalTo(titleLabel)
            make.trailing.equalTo(titleLabel.snp.leading).offset(-10)
            make.size.equalTo(24)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalTo(titleView).offset(17)
            make.centerY.equalTo(titleView)
        }
        
        addressLabel.snp.makeConstraints { make in
            make.top.equalTo(titleView.snp.bottom).offset(5)
            make.horizontalEdges.equalTo(containerView).inset(10)

        }
    }
}
