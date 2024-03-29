//
//  Infallible+Driver.swift
//  RxCocoa
//
//  Created by Anton Siliuk on 14/02/2022.
//  Copyright © 2022 Krunoslav Zaher. All rights reserved.
//

import RxSwift

public extension InfallibleType {
    /// Converts `InfallibleType` to `Driver`.
    ///
    /// - returns: Observable sequence.
    func asDriver() -> Driver<Element> {
        SharedSequence(asObservable().observe(on: DriverSharingStrategy.scheduler))
    }
}
