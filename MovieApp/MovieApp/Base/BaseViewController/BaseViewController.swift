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
        // Subscribe to the isLoading PublishSubject of the provided viewModel
        viewModel.isLoading
            // Observe on the MainScheduler to ensure UI updates are performed on the main thread
            .observe(on: MainScheduler.instance)
            // Subscribe to events emitted by the isLoading subject
            .subscribe { [weak self] event in
                // Ensure self is not nil to prevent retain cycles
                guard let self else { return }
                // Check if the event contains a value (isLoading state)
                if event.element ?? false {
                    // If isLoading is true, call the startLoading method of the current object (in a view controller)
                    self.startLoading()
                } else {
                    // If isLoading is false, call the stopLoading method of the current object (in a view controller)
                    self.stopLoading()
                }
            }
            // Dispose of the subscription when it's no longer needed to avoid memory leaks
            .disposed(by: disposeBag)
    }
}
