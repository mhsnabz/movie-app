// Created by Cal Stephens on 7/26/23.
// Copyright © 2023 Airbnb Inc. All rights reserved.

// MARK: - LottieAnimationSource

/// A data source for a Lottie animation.
/// Either a `LottieAnimation` loaded from a `.json` file,
/// or a `DotLottieFile` loaded from a `.lottie` file.
public enum LottieAnimationSource: Sendable {
    /// A `LottieAnimation` loaded from a `.json` file
    case lottieAnimation(LottieAnimation)

    /// A `DotLottieFile` loaded from a `.lottie` file
    case dotLottieFile(DotLottieFile)
}

extension LottieAnimationSource {
    /// The default animation displayed by this data source
    var animation: LottieAnimation? {
        switch self {
        case let .lottieAnimation(animation):
            return animation
        case let .dotLottieFile(dotLottieFile):
            return dotLottieFile.animation()?.animation
        }
    }
}

public extension LottieAnimation {
    /// This animation represented as a `LottieAnimationSource`
    var animationSource: LottieAnimationSource {
        .lottieAnimation(self)
    }
}

public extension DotLottieFile {
    /// This animation represented as a `LottieAnimationSource`
    var animationSource: LottieAnimationSource {
        .dotLottieFile(self)
    }
}
