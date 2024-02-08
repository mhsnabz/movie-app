//
//  LoadingView.swift
//  MovieApp
//
//  Created by srbrt on 8.02.2024.
//

import UIKit
public protocol LoadingView: AnyObject {
    var animator: CustomProgress { get }
    func startLoading()
    func stopLoading()
}

public extension LoadingView where Self: UIViewController {
    func startLoading() {
        DispatchQueue.main.async { [weak self] in
            if let self, let window = UIApplication.shared.windows.last {
                self.animator.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                window.addSubview(self.animator)
                self.animator.playAnim()
            }
        }
    }

    func stopLoading() {
        DispatchQueue.main.async { [weak self] in
            self?.animator.removeFromSuperview()
        }
    }
}
