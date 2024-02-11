//
//  UITextField+Extension.swift
//  MovieApp
//
//  Created by srbrt on 11.02.2024.
//

import UIKit
extension UITextField {
    func setPlaceholderColor(_ color: UIColor) {
        var attributes: [NSAttributedString.Key: Any] = [NSAttributedString.Key.foregroundColor: color]
        attributes[NSAttributedString.Key.font] = UIFont(name: "Nunito-Medium", size: 16)
        attributedPlaceholder = NSAttributedString(string: placeholder ?? "", attributes: attributes)
    }
}
