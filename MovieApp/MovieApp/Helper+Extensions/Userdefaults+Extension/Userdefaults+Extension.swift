//
//  Userdefaults+Extension.swift
//  MovieApp
//
//  Created by srbrt on 8.02.2024.
//

import Foundation
extension UserDefaults {
    enum Keys: String {
        case didShowLanding
    }

    class func didShowLandingPage() -> Bool {
        return standard.bool(forKey: Keys.didShowLanding.rawValue)
    }

    class func setShowLandingPage() {
        standard.setValue(true, forKey: Keys.didShowLanding.rawValue)
    }
}
