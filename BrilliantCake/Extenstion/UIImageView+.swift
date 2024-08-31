//
//  UIImageView+.swift
//  BrilliantCake
//
//  Created by 박다현 on 8/20/24.
//

import UIKit
import Kingfisher

extension UIImageView {
    
    func setImage(url:String) {
        self.kf.indicatorType = .activity
        let urlString = APIKey.BaseURL + "v1/" + url
        self.kf.setImage(with: URL(string: urlString),
                         placeholder: UIImage(named: ImageName.missingImage),
                         options: [.cacheOriginalImage])
    }
}
