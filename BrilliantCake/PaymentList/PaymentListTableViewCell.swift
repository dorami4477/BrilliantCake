//
//  PaymentListTableViewCell.swift
//  BrilliantCake
//
//  Created by 박다현 on 8/28/24.
//

import UIKit
import SnapKit

class PaymentListTableViewCell: BaseTableViewCell {
    
    let dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = .black
        return label
    }()
    
    let amountLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .darkGray
        return label
    }()
    
    let storeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .darkGray
        return label
    }()
    
    let storeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = UIColor.systemYellow
        button.layer.cornerRadius = 10
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        return button
    }()
    
    override func configureHierarchy() {
        contentView.addSubview(dateLabel)
        contentView.addSubview(amountLabel)
        contentView.addSubview(storeLabel)
        contentView.addSubview(storeButton)
    }
    
    override func configureLayout() {
        // 날짜 라벨 제약
        dateLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.leading.equalToSuperview().offset(16)
        }
        
        // 결제 금액 라벨 제약
        amountLabel.snp.makeConstraints { make in
            make.top.equalTo(dateLabel.snp.bottom).offset(8)
            make.leading.equalTo(dateLabel)
        }
        
        // 스토어 라벨 제약
        storeLabel.snp.makeConstraints { make in
            make.top.equalTo(amountLabel.snp.bottom).offset(4)
            make.leading.equalTo(amountLabel)
        }
        
        // 스토어 버튼 제약
        storeButton.snp.makeConstraints { make in
            make.top.equalTo(storeLabel.snp.bottom).offset(12)
            make.leading.equalTo(storeLabel)
            make.height.equalTo(40)
            make.bottom.equalToSuperview().inset(16)
        }
    }
    
    // 데이터 설정 함수
    func configure(date: String, amount: String, store: String, buttonText: String) {
        dateLabel.text = date
        amountLabel.text = "결제 금액: \(amount)"
        storeLabel.text = "스토어: \(store)"
        storeButton.setTitle(buttonText, for: .normal)
    }
}
