//
//  CommentLabel.swift
//  BrilliantCake
//
//  Created by 박다현 on 8/18/24.
//

import UIKit

class CommentLabel: UILabel {
    private var padding = UIEdgeInsets(top: 16.0, left: 16.0, bottom: 16.0, right: 16.0)

    convenience init(padding: UIEdgeInsets) {
        self.init()
        self.padding = padding
        self.font = UIFont.systemFont(ofSize: 17)
        self.backgroundColor = .backgroundGray
        self.layer.cornerRadius = 10
        self.clipsToBounds = true
        self.numberOfLines = 0
    }

    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: padding))
    }

    override var intrinsicContentSize: CGSize {
        var contentSize = super.intrinsicContentSize
        contentSize.height += padding.top + padding.bottom
        contentSize.width += padding.left + padding.right

        return contentSize
    }
}
