//
//  MainTabbarController.swift
//  MovieApp
//
//  Created by srbrt on 8.02.2024.
//

import UIKit

class MainTabbarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabbar()
    }

    private func setupTabbar() {
        tabBarController?.tabBar.barTintColor = .black
        tabBar.backgroundColor = .black
        tabBar.barTintColor = .red
        tabBar.backgroundImage = UIImage()
        UITabBar.appearance().tintColor = .red
    }
}
