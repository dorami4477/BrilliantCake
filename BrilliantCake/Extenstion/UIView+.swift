//
//  UIView+.swift
//  BrilliantCake
//
//  Created by 박다현 on 8/18/24.
//

import UIKit

protocol ReuseIdentifierProtocol:AnyObject{
    static var identifier:String { get }
}


extension UIView:ReuseIdentifierProtocol{
    static var identifier:String{
        return String(describing: self)
    }
}

extension UIView {
    func screenSize() -> CGRect {
        guard let window = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return CGRect() }
        let screenSize = window.screen.bounds
        return screenSize
    }
    
    func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        let size = image.size
        let widthRatio  = targetSize.width  / image.size.width
        let heightRatio = targetSize.height / image.size.height
        let ratio = min(widthRatio, heightRatio)
        
        let newSize = CGSize(width: size.width * ratio, height: size.height * ratio)
        
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
        image.draw(in: CGRect(origin: .zero, size: newSize))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
}


