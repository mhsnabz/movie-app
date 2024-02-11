//
//  BaseViewController.swift
//  MovieApp
//
//  Created by srbrt on 8.02.2024.
//

import RxSwift
import UIKit
class BaseViewController: UIViewController, LoadingView {
    lazy var animator = CustomProgress()
    let disposeBag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()
        if let topWindow = UIApplication.shared.windows.last {
            animator = CustomProgress(frame: topWindow.frame)
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    func observeLoading(viewModel: BaseViewModel) {
        viewModel.isLoading.observe(on: MainScheduler.instance).subscribe { [weak self] event in
            guard let self else { return }
            if event.element ?? false {
                self.startLoading()
            } else {
                self.stopLoading()
            }
        }.disposed(by: disposeBag)
    }
}
