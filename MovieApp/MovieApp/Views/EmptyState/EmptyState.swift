//
//  EmptyState.swift
//  MovieApp
//
//  Created by srbrt on 11.02.2024.
//

import Lottie
import UIKit
public class EmptyState: UIView {
    @IBOutlet var noResult: LottieAnimationView!
    func playAnim() {
        noResult.contentMode = .scaleAspectFit
        noResult.loopMode = .loop
        noResult.animationSpeed = 1
        noResult.play()
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
        if let subView = Bundle.main.loadNibNamed("EmptyState", owner: self, options: nil)?[0] as? UIView {
            subView.frame = bounds
            addSubview(subView)
            playAnim()
        }
    }
}
