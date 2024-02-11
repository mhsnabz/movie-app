//
//  AlertViewController.swift
//  MovieApp
//
//  Created by srbrt on 11.02.2024.
//

import UIKit

class AlertViewController: UIViewController {
    @IBOutlet var mainView: UIView!
    @IBOutlet var AlertLbl: UILabel!

    var alertTitle: String

    override func viewDidLoad() {
        super.viewDidLoad()

        AlertLbl.text = alertTitle
    }

    init(alertTitle: String) {
        self.alertTitle = alertTitle
        super.init(nibName: "AlertViewController", bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        mainView.animationOpenWindow(for: mainView, completion: {})
    }

    @IBAction func action(_: Any) {
        DispatchQueue.main.async {
            self.mainView.animationCloseWindow(for: self.mainView) { [weak self] in
                guard let self = self else { return }
                self.dismiss(animated: false, completion: nil)
            }
        }
    }
}
