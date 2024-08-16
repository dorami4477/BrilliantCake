//
//  TabbarController.swift
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
            
            let appearance = UINavigationBarAppearance()
            appearance.backgroundColor = .white
            UINavigationBar.appearance().scrollEdgeAppearance = appearance
            
            let browse = BrowseViewController()
            let nav1 = UINavigationController(rootViewController: browse)
            nav1.tabBarItem = UITabBarItem(title: nil, image: UIImage(named: "house.fill"), tag: 0)
            //nav1.tabBarItem.selectedImage = UIImage(named:IconName.topicActive)
            
//            let random = RandomPhotoViewController()
//            let nav2 = UINavigationController(rootViewController: random)
//            nav2.tabBarItem = UITabBarItem(title: nil, image: UIImage(named: IconName.video), tag: 1)
//            nav2.tabBarItem.selectedImage = UIImage(named:IconName.videoActive)
//            
//            let search = SearchViewController()
//            let nav3 = UINavigationController(rootViewController: search)
//            nav3.tabBarItem = UITabBarItem(title: nil, image: UIImage(named: IconName.search), tag: 2)
//            nav3.tabBarItem.selectedImage = UIImage(named:IconName.searchActive)
            

            setViewControllers([nav1], animated: true)
        
        }
    
    }
