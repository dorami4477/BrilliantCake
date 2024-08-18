//
//  TabBarController.swift
//  BrilliantCake
//
//  Created by 박다현 on 8/15/24.
//

import UIKit

final class TabBarController: UITabBarController {
        
        override func viewDidLoad() {
            super.viewDidLoad()
            
            let tabBarappearance = UITabBarAppearance()
            tabBarappearance.configureWithOpaqueBackground()
            UITabBar.appearance().backgroundColor = UIColor.white
            tabBar.tintColor = .black
            
            let browse = BrowseViewController()
            let nav1 = UINavigationController(rootViewController: browse)
            let image1 = resizeImage(image: UIImage(named: "BC_18")!, targetSize: CGSize(width: 30, height: 30))
            let image1Selected = resizeImage(image: UIImage(named: "BC_6")!, targetSize: CGSize(width: 30, height: 30))
            nav1.tabBarItem = UITabBarItem(title: nil, image: image1, tag: 0)
            nav1.tabBarItem.selectedImage = image1Selected
            
            
            let mapVC = MapViewController()
            let nav2 = UINavigationController(rootViewController: mapVC)
            let image2 = resizeImage(image: UIImage(named: "BC_19")!, targetSize: CGSize(width: 30, height: 30))
            let image2Selected = resizeImage(image: UIImage(named: "BC_7")!, targetSize: CGSize(width: 30, height: 30))
            nav2.tabBarItem = UITabBarItem(title: nil, image: image2, tag: 0)
            nav2.tabBarItem.selectedImage = image2Selected
//
//            let search = SearchViewController()
//            let nav3 = UINavigationController(rootViewController: search)
//            nav3.tabBarItem = UITabBarItem(title: nil, image: UIImage(named: IconName.search), tag: 2)
//            nav3.tabBarItem.selectedImage = UIImage(named:IconName.searchActive)

            setViewControllers([nav1, nav2], animated: true)
        
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
