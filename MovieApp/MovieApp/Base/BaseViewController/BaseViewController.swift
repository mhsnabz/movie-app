//
//  BaseViewController.swift
//  MovieApp
//
//  Created by srbrt on 8.02.2024.
//

import UIKit

class BaseViewController: UIViewController, LoadingView {
    lazy var animator = CustomProgress()

    override func viewDidLoad() {
        super.viewDidLoad()
        if let topWindow = UIApplication.shared.windows.last {
            animator = CustomProgress(frame: topWindow.frame)
        }
    }
}
