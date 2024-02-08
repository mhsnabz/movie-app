//
//  CustomProgress.swift
//  MovieApp
//
//  Created by srbrt on 8.02.2024.
//

import Lottie
import UIKit
public class CustomProgress: UIView {
    @IBOutlet var animator: LottieAnimationView!

    func playAnim() {
        animator.contentMode = .scaleAspectFit
        animator.loopMode = .loop
        animator.animationSpeed = 1
        animator.play()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    init() {
        super.init(frame: .zero)
        commonInit()
    }

    private func commonInit() {
        if let subView = Bundle.main.loadNibNamed("CustomProgress", owner: self, options: nil)?[0] as? UIView {
            subView.frame = bounds
            addSubview(subView)
        }
    }
}
