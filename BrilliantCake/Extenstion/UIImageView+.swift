//
//  UIImageView+.swift
//  BrilliantCake
//
//  Created by 박다현 on 8/20/24.
//

import UIKit
import Kingfisher

extension UIImageView {
    //큰사이즈 이미지 (프로그레스뷰)
    func setImages(url:String, indicator: UIProgressView, cloure:@escaping (Result<RetrieveImageResult, KingfisherError>) -> Void) {
        DispatchQueue.main.async {
            let urlString = APIKey.BaseURL + "v1/" + url
            self.kf.setImage(with: URL(string: urlString)) { receivedSize, totalSize in
                let percentage = (Float(receivedSize) / Float(totalSize))
                indicator.setProgress(percentage, animated: true)
                
            } completionHandler: { result in
                cloure(result)
            }
        }
    }
    
    //작은 사이즈 이미지
    func setImage(url:String) {
        self.kf.indicatorType = .activity
        let urlString = APIKey.BaseURL + "v1/" + url
        self.kf.setImage(with: URL(string: urlString),
                         placeholder: UIImage(named: ImageName.missingImage),
                         options: [.cacheOriginalImage])
    }
    
}
