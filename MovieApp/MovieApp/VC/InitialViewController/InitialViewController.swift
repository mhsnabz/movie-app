//
//  InitialViewController.swift
//  MovieApp
//
//  Created by srbrt on 8.02.2024.
//

import UIKit

class InitialViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        if UserDefaults.didShowLandingPage() {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
                self?.performSegue(withIdentifier: "goToMain", sender: nil)
            }
        } else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
                self?.performSegue(withIdentifier: "goToLanding", sender: nil)
            }
        }
    }
}
