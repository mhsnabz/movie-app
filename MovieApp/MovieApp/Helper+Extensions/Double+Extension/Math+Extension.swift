//
//  Math+Extension.swift
//  MovieApp
//
//  Created by srbrt on 9.02.2024.
//

import UIKit
extension Double {
    func rounded(toDecimalPlaces decimalPlaces: Int = 1) -> String {
        let multiplier = pow(10.0, Double(decimalPlaces))
        return String((self * multiplier).rounded() / multiplier)
    }
}

extension Int {
    func formatAbbreviated() -> String {
        let num = abs(self)
        let sign = (self < 0) ? "-" : ""

        if num >= 1_000_000 {
            let roundedNum = num / 1_000_000
            return sign + "\(roundedNum)m"
        } else if num >= 1000 {
            let roundedNum = num / 1000
            return sign + "\(roundedNum)k"
        } else {
            return sign + "\(self)"
        }
    }
}
