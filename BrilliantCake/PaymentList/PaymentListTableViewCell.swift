//
//  PaymentListTableViewCell.swift
//  BrilliantCake
//
//  Created by 박다현 on 8/28/24.
//

import UIKit
import SnapKit

class PaymentListTableViewCell: BaseTableViewCell {
    
    let contentBack: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 20
        view.clipsToBounds = true
        return view
    }()
    
    let dateLabel: UILabel = {
        let label = UILabel()
        label.font = AppFont.size15Bold
        label.textColor = .black
        return label
    }()
    
    let amountLabel: UILabel = {
        let label = UILabel()
        label.font = AppFont.size15
        label.textColor = .darkGray
        return label
    }()
    
    let storeLabel: UILabel = {
        let label = UILabel()
        label.font = AppFont.size15
        label.textColor = .darkGray
        return label
    }()
    
    let storeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = UIColor.systemYellow
        button.layer.cornerRadius = 10
        button.titleLabel?.font = AppFont.size17Bold
        return button
    }()
    
    override func configureHierarchy() {
        contentView.backgroundColor = .systemGroupedBackground
        contentView.addSubview(contentBack)
        contentBack.addSubview(dateLabel)
        contentBack.addSubview(amountLabel)
        contentBack.addSubview(storeLabel)
        contentBack.addSubview(storeButton)
    }
    
    override func configureLayout() {
        
        contentBack.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(10)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.leading.equalToSuperview().offset(20)
        }
        
        amountLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.leading.equalTo(dateLabel.snp.trailing).offset(10)
        }
        
        storeLabel.snp.makeConstraints { make in
            make.top.equalTo(amountLabel.snp.bottom).offset(5)
            make.leading.equalTo(dateLabel.snp.trailing).offset(10)
        }
        
        storeButton.snp.makeConstraints { make in
            make.top.equalTo(storeLabel.snp.bottom).offset(12)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.height.equalTo(40)
            make.bottom.equalToSuperview().inset(16)
        }
    }
    
    func configure(date: String, amount: String, store: String, buttonText: String) {
        dateLabel.text = date.convertToDateTime
        amountLabel.text = "결제 금액: \(amount)원"
        storeLabel.text = "스토어: \(store)"
        storeButton.setTitle(buttonText, for: .normal)
    }
    
}
