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
            let image1 = view.resizeImage(image: UIImage(named: ImageName.browse)!, targetSize: CGSize(width: 30, height: 30))
            nav1.tabBarItem = UITabBarItem(title: nil, image: image1, tag: 0)
            
            let storeVC = StoreListViewController()
            let nav2 = UINavigationController(rootViewController: storeVC)
            let image2 = view.resizeImage(image: UIImage(named: ImageName.store)!, targetSize: CGSize(width: 30, height: 30))
            nav2.tabBarItem = UITabBarItem(title: nil, image: image2, tag: 0)
            
            let mapVC = LodPOISample()
            let nav3 = UINavigationController(rootViewController: mapVC)
            let image3 = view.resizeImage(image: UIImage(named: ImageName.map)!, targetSize: CGSize(width: 30, height: 30))
            nav3.tabBarItem = UITabBarItem(title: nil, image: image3, tag: 0)
            
            setViewControllers([nav1, nav2, nav3], animated: true)
        
        }
    
}
