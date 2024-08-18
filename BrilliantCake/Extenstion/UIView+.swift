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
}


