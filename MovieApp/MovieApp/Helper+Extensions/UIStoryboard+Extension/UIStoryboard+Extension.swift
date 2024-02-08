//
//  UIStoryboard+Extension.swift
//  MovieApp
//
//  Created by srbrt on 8.02.2024.
//

import UIKit
extension UIStoryboard {
    enum VCIdentifer: String {
        case mainTabbar
    }

    class func getvcObcjet(identifer: VCIdentifer) -> UIViewController {
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: identifer.rawValue)
    }
}
