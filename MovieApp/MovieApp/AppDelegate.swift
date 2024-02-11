//
//  AppDelegate.swift
//  MovieApp
//
//  Created by srbrt on 8.02.2024.
//

import IQKeyboardManagerSwift
import UIKit
@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(_: UIApplication, didFinishLaunchingWithOptions _: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        IQKeyboardManager.shared.enable = true
        return true
    }
}
